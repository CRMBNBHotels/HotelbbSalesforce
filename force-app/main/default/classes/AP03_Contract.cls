/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Shiksha 
* @date: 08/02/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 08-FEB-2021  Shiksha      1.0     CRMSS-1051: carte logée credit card expire avant la fin du contrat : Statut du contrat devient “Expiré” + Notification Owner 
*                                      CRMSS-359 : Carte logée credit card expire dans 1 mois - notification owner un mois avant la date d’expiration de la carte bancaire
*                                      CRMSS-975 : Une carte logée (Si au statut Actif uniquement) est renouvelée tacitement UN JOUR AVANT LA DATE DE FIN DE CONTRAT
* -- 25-FEB-2021  Amira        2.0     CRMSS-1039: Notification au travel manager lorsque une facture est rattaché à un contrat carte logée
* -- 22-FEB-2021  Shiksha      3.0     CRMSS-1042/1064: carte logée Génération du relevé de facture Batch, récupération des données et calculs
* -- 08-MAR-2021  Shiksha      4.0     CRMSS-1085 : En fonction du code prestation reçu afficher les libellés de prestations selon le mapping
* @TestClass : AP03_Contract_Test
*********************************************************************************************************************************************************************/

public class AP03_Contract {
    /*
    * @Details: CRMSS-1051: carte logée credit card expire avant la fin du contrat : Statut du contrat devient “Expiré” + Notification Owner 
    *           CRMSS-359 : Carte logée credit card expire dans 1 mois - notification owner un mois avant la date d’expiration de la carte bancaire
    *           CRMSS-975 : Une carte logée (Si au statut Actif uniquement) est renouvelée tacitement UN JOUR AVANT LA DATE DE FIN DE CONTRAT           
    */
    public static void carteLogeeNotifActions(List<Contract> aContractList, String aAction){
        List<EmailMessageWrapper> msgWrapperList = New List<EmailMessageWrapper>();
        
        For(Contract cont : aContractList){ 
            EmailMessageWrapper msg = New EmailMessageWrapper(null, null, New List<String> {cont.Owner.email}, null, null,null, null, null, true , cont.Id );
            msgWrapperList.add(msg);

            if (aAction.EqualsIgnoreCase('reconduction')){
                cont.StartDate          = cont.Expiration_Date__c;
                cont.Status             = 'Activated';
                cont.ContractTerm       = cont.ContractTerm;
                cont.Expiration_Date__c = cont.StartDate+cont.ContractTerm;
            }

            if (aAction.EqualsIgnoreCase('expiration')){
                cont.Status='Expired';
            }
        }

        String template = aAction.EqualsIgnoreCase('reconduction') ? 'France_Notification_Owner_Renouvellement_contrat_1612853665624':
                          aAction.EqualsIgnoreCase('expiration')   ? 'Carte_Log_e_Notification_Expiration_Carte_Cr_dit_1613389863605': 'France_Notification_Owner_Expiration_carte_log_e_1612513667178';

        Utils_Email.sendEmail(msgWrapperList, template);
        update aContractList;
    }

    /*
    * @Details: CRMSS-1039: Notification au travel manager lorsque une facture est rattaché à un contrat carte logée
    *           
    */
    public static void CarteLogeeNotifFacture(List<Contract> aContractList){
       
        List<Messaging.EmailFileAttachment> attachmentList     = New List<Messaging.EmailFileAttachment>();
        Map<id,EmailMessageWrapper>         contractMsgMap     = New Map<id,EmailMessageWrapper>();
        Map<Id,Contract>                    contractMap        = New Map<Id,Contract>();
        Id                                  PrevLinekdEntityId = Null;
        DateTime                            Past24             = system.now().AddDays(-1); 

        For (Contract CT : aContractList){
            contractMap.put(CT.id,CT);
        }
       
        List<contentDocumentLink> aContentDocList = [SELECT Id,LinkedEntityId,ContentDocumentId, ContentDocument.FileType, ContentDocument.Title,  ContentDocument.LatestPublishedVersion.VersionData
                                                     FROM contentDocumentLink
                                                     WHERE LinkedEntityId IN:contractMap.keySet() AND contentDocument.createddate> :Past24 AND ContentDocument.Title LIKE 'booking%'
                                                     ORDER By LinkedEntityId];

        For (contentDocumentLink cont : aContentDocList ){            
            if(cont.LinkedEntityId !=PrevLinekdEntityId){
                attachmentList = New List<Messaging.EmailFileAttachment>(); 
            }

            Contract ctr = contractMap.get(cont.LinkedEntityId);

            Messaging.Emailfileattachment   efa = New Messaging.Emailfileattachment();
            efa.setFileName(cont.ContentDocument.Title+'.'+cont.ContentDocument.FileType);             
            efa.setBody(cont.ContentDocument.LatestPublishedVersion.VersionData);
            attachmentList.add(efa);  

            EmailMessageWrapper msg = New EmailMessageWrapper(null, null, New List<String> {ctr.ContactComptabilite__r.email}, ctr.ContactComptabilite__c, null,null, null, null, true , ctr.Id,attachmentList);
            contractMsgMap.put(ctr.id,msg);

            PrevLinekdEntityId = cont.LinkedEntityId;
        }

        Utils_Email.sendEmail(contractMsgMap.Values(), 'Carte_Log_e_Envoie_Facture_Unitaire_1614148487875');
    }

    /*
    * @Details: CRMSS-1042/1064: carte logée Génération du relevé de facture Batch, récupération des données et calculs
    *           CRMSS-1085     : En fonction du code prestation reçu afficher les libellés de prestations selon le mapping
    *
    */

    public static void generateReleveDesFactures(List<Contract> aCarteLogeeList){
        
        Map<Id,Contract>                       aCarteLogeeMap       = New Map<Id,Contract>();
        List<String>                           rowList              = New List<String>(); 
        Map<Contract,List<String>>             contractAttachMap    = New Map<Contract,List<String>>();
        List<EmailMessageWrapper>              msgWrapperList       = New List<EmailMessageWrapper>();
        Map<String,CarteLogeePrestations__mdt> codePrestationMap    = New Map<String,CarteLogeePrestations__mdt>();
        Map<String,CarteLogeePrestations__mdt> libellePrestationMap = New Map<String,CarteLogeePrestations__mdt>();
        List<Attachment>                       attachList           = New List<Attachment>();
        String                                 venteRecord          = '';
        Id                                     prevContract         = Null; 
        String                                 bbusPresta           = '';
        String                                 idPresta             = '';
        String                                 libellePres          = '';

        String columHeader = 'Carte Logée ;Hotel ;Réservé par ;Nom de l’occupant ;Date de séjour ;Prestation ;Qté ;Montant HT ;Taux TVA ;Montant TVA ;Montant TTC ; N° de Facture; ID Client ;N° Résa \n'; 
         
        for (Contract ctrct: aCarteLogeeList){
            aCarteLogeeMap.put(ctrct.Id,ctrct );
        }
        //Get Releves des factures
        List<TableVente__c> venteList   = [SELECT Id, Contrat__c,Contrat__r.Owner.Email,DateSejour__c, IDCRSClient__c, IdPrestation__c, Contrat__r.CorporateCode__r.Name,
                                            LibellePrestation__c, Montant_HT__c, Montant_TTC__c, Montant_TVA__c, NumReservation__c, Nomhotel__c, 
                                            NomBooker__c, Nom_du_stayer__c, NumFactureAvoir__c, PrenomBooker__c, Quantite__c, Taux_TVA__c 
                                            FROM TableVente__c 
                                            WHERE DateSejour__c = LAST_MONTH  AND Contrat__c IN :aCarteLogeeMap.KeySet()
                                            ORDER BY Contrat__c DESC];
        // Get prestatations mapping
        for(CarteLogeePrestations__mdt pres: [SELECT Id,DeveloperName,MasterLabel, LibelleDePrestation__c, PLIBRecusdeBBUS__c 
                                              FROM CarteLogeePrestations__mdt]){
            codePrestationMap.put((pres.DeveloperName.replace(' ', '')).toUpperCase(),pres);
            libellePrestationMap.put((pres.PLIBRecusdeBBUS__c.replace(' ', '')).toUpperCase(),pres);
        }

        for (TableVente__c  vente: venteList){
            if (prevContract != vente.Contrat__c ){            
                rowList = new List<String>();
            }
            bbusPresta  =   String.isBlank(vente.LibellePrestation__c) ? '' : (vente.LibellePrestation__c.replace(' ', '')).toUpperCase();
            idPresta    =   String.isBlank(vente.IdPrestation__c) ? '' : (vente.IdPrestation__c.replace(' ', '')).toUpperCase();

            libellePres =   codePrestationMap.get(idPresta)      != null ? codePrestationMap.get(idPresta).LibelleDePrestation__c :
                            libellePrestationMap.get(bbusPresta) != null ? libellePrestationMap.get(bbusPresta).LibelleDePrestation__c: vente.LibellePrestation__c;

            venteRecord =   vente.Contrat__r.CorporateCode__r.Name + ' ;'  + 
                            vente.Nomhotel__c  + ' ;'  + 
                            vente.PrenomBooker__c + ' ' + vente.NomBooker__c   + ' ;'  + 
                            vente.Nom_du_stayer__c    + ' ;'  + 
                            vente.DateSejour__c.Format()      + ' ;'  + 
                            libellePres     + ' ;'  + 
                            vente.Quantite__c     + ' ;'  + 
                            vente.Montant_HT__c     + ' ;'  + 
                            vente.Taux_TVA__c  + ' ;'  + 
                            vente.Montant_TVA__c  + ' ;'  + 
                            vente.Montant_TTC__c        + ' ;'  + 
                            vente.NumFactureAvoir__c  + ' ;'  + 
                            vente.IDCRSClient__c  + ' ;'  + 
                            vente.NumReservation__c ;
            //System.debug(venteRecord);
            rowList.add(venteRecord);
            contractAttachMap.put(aCarteLogeeMap.get(vente.Contrat__C),rowList);
            prevContract = vente.Contrat__c;
        }

        for (Contract cont: contractAttachMap.KeySet() ){
                        
            String             factureMois          = (DateTime.now().addMonths(-1)).format('MMM YYYY');
            String             fileName             = 'Relevé de factures_'+ cont.ContractNumber + '_' + factureMois;
            Map<String,String> ParameterSubjectMap  = New Map<String,String>{'#ContractDetails' => cont.ContractNumber + ' ' + factureMois};
            Map<String,String> ParameterBodyMap     = New Map<String,String>{'#RelevantDate' => factureMois};
            
            //csv blob
            String             allVentes            = '\uFEFF' + columHeader + String.join(contractAttachMap.get(cont),'\n') + '\n';
            Blob               csvVentesBlob        = Blob.valueof(allVentes);

            //pdf blob
            PageReference       pdf                 = Page.VFP05_ReleveDesFactures;
            pdf.getParameters().put('id',(String)cont.id);
            pdf.setRedirect(true);
            Blob                pdfBlob             = Test.isRunningTest() ? blob.valueOf('Unit.Test') : pdf.getContent();

            // Create the email attachment - csv
            Messaging.EmailFileAttachment csvA = new Messaging.EmailFileAttachment();
            csvA.setFileName(filename+'.csv');
            csvA.contentType= 'text/plain; charset=UTF-8';
            csvA.setBody(csvVentesBlob);

            // Create the email attachment - pdf
            Messaging.EmailFileAttachment pdfA = new Messaging.EmailFileAttachment();
            pdfA.setFileName(filename+'.pdf');
            pdfA.setBody(pdfBlob);


            EmailMessageWrapper msg = New EmailMessageWrapper(null, null, New List<String> {cont.ContactComptabilite__r.email}, cont.ContactComptabilite__c, null,null, ParameterSubjectMap, ParameterBodyMap, true , cont.Id , New List<Messaging.EmailFileAttachment>{csvA, pdfA } );
            msgWrapperList.add(msg);

            //Create Attachments
            Attachment attach=new Attachment();
            attach.Body        = csvVentesBlob;
            attach.Name        = filename+'.csv';
            attach.ContentType = 'text/plain; charset=UTF-8';
            attach.ParentID    = cont.id;
 
            Attachment pdfAttach = new Attachment();
            pdfAttach.Body     = pdfBlob;
            pdfAttach.Name     = filename+'.pdf';           
            pdfAttach.ParentID = cont.id;

            attachList.add(attach);
            attachList.add(pdfAttach);
        }

        Database.Insert (attachList);
        Utils_Email.sendEmail(msgWrapperList, 'Carte_Log_e_Envoi_du_relev_des_factures_1614070497692');
    }

}