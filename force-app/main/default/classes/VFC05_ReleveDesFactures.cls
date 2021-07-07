/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Shiksha 
* @date: 22/02/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 22-FEB-2021  Shiksha      3.0     CRMSS-1042/1064: carte logée Génération du relevé de facture Batch, récupération des données et calculs
* -- 08-MAR-2021  Shiksha      4.0     CRMSS-1085 : En fonction du code prestation reçu afficher les libellés de prestations selon le mapping
* @TestClass : VFC05_ReleveDesFactures_Test
*********************************************************************************************************************************************************************/

/*
* @Details: CRMSS-1042/1064: carte logée Génération du relevé de facture Batch, récupération des données et calculs
*           CRMSS-1085     : En fonction du code prestation reçu afficher les libellés de prestations selon le mapping
*
*/
public class VFC05_ReleveDesFactures {

    public List<TableVente__c> venteList        {get;set;}
    public List<venteWrapper>  venteWrapperList {get;set;}

    public class venteWrapper{        
        public String  Hotel {get;set;} 
        public String  ReservePar{get;set;} 
        public String  NomDelOccupant{get;set;} 
        public String  Prestation{get;set;} 
        public String  NoFacture{get;set;} 
        public String  IDClient{get;set;} 
        public String  NoResa{get;set;} 
        public Integer Qte{get;set;}                     
        public Integer TauxTVA{get;set;} 
        public Decimal MontantTVA{get;set;} 
        public Decimal MontantTTC{get;set;} 
        public Decimal MontantHT{get;set;} 
        public Date    DateDeSejour{get;set;} 

        public venteWrapper ( String aHotel,String aReservePar,String aNomDelOccupant,String aPrestation,String aNoFacture,String aIDClient,String aNoResa,
                              Integer aQte,Integer aTauxTVA,Decimal aMontantTVA,Decimal aMontantTTC,Decimal aMontantHT,Date aDateDeSejour){
            this.Hotel          = aHotel; 
            this.ReservePar     = aReservePar;
            this.NomDelOccupant = aNomDelOccupant;
            this.Prestation     = aPrestation;
            this.NoFacture      = aNoFacture;
            this.IDClient       = aIDClient;
            this.NoResa         = aNoResa;
            this.Qte            = aQte;                   
            this.TauxTVA        = aTauxTVA;
            this.MontantTVA     = aMontantTVA;
            this.MontantTTC     = aMontantTTC;
            this.MontantHT      = aMontantHT;
            this.DateDeSejour   = aDateDeSejour;
        }

    }

    Public Double totalHT {get;set;}
    Public Double totaltva {get;set;}
    Public Double totalTTC {get;set;}

    Public Double tva10TotalHT {get;set;}
    Public Double tva10Totaltva {get;set;}
    Public Double tva10TotalTTC {get;set;}

    Public Double tva20TotalHT {get;set;}
    Public Double tva20Totaltva {get;set;}
    Public Double tva20TotalTTC {get;set;}

    Public Double ExclTotalHT {get;set;}
    Public Double ExclTotaltva {get;set;}
    Public Double ExclTotalTTC {get;set;}

    Public Date premiereConso{get;set;}
    Public Date derniereConso{get;set;}
    Public String corporateCode{get;set;}


    public VFC05_ReleveDesFactures(ApexPages.StandardController controller) { 
        
        Map<String,CarteLogeePrestations__mdt> codePrestationMap    = New Map<String,CarteLogeePrestations__mdt>();
        Map<String,CarteLogeePrestations__mdt> libellePrestationMap = New Map<String,CarteLogeePrestations__mdt>();
        String                                 bbusPresta           = '';
        String                                 idPresta             = '';
        String                                 libellePres          = '';
        venteWrapperList                                            = New List<venteWrapper>();
        
        totalHT         = 0;
        totaltva        = 0;
        totalTTC        = 0;
        tva10TotalHT    = 0;
        tva10Totaltva   = 0;
        tva10TotalTTC   = 0;
        tva20TotalHT    = 0;
        tva20Totaltva   = 0;
        tva20TotalTTC   = 0;
        ExclTotalHT     = 0;
        ExclTotaltva    = 0;
        ExclTotalTTC    = 0;

        venteList   = [ SELECT Id, Contrat__c,Contrat__r.Owner.Email,DateSejour__c, IDCRSClient__c, IdPrestation__c, Contrat__r.CorporateCode__r.Name,
                                LibellePrestation__c, Montant_HT__c, Montant_TTC__c, Montant_TVA__c, NumReservation__c, Nomhotel__c, 
                                NomBooker__c, Nom_du_stayer__c, NumFactureAvoir__c, PrenomBooker__c, Quantite__c, Taux_TVA__c 
                        FROM TableVente__c 
                        WHERE DateSejour__c = LAST_MONTH  AND Contrat__c =:controller.getId()                        
                        ORDER BY Nom_du_stayer__c DESC];

        // Get prestatations mapping
        for(CarteLogeePrestations__mdt pres: [SELECT Id,DeveloperName,MasterLabel, LibelleDePrestation__c, PLIBRecusdeBBUS__c 
                                             FROM CarteLogeePrestations__mdt]){
            codePrestationMap.put((pres.DeveloperName.replace(' ', '')).toUpperCase(),pres);
            libellePrestationMap.put((pres.PLIBRecusdeBBUS__c.replace(' ', '')).toUpperCase(),pres);
        }

                
        for (TableVente__c vente :venteList){
            bbusPresta  =   String.isBlank(vente.LibellePrestation__c) ? '' : (vente.LibellePrestation__c.replace(' ', '')).toUpperCase();
            idPresta    =   String.isBlank(vente.IdPrestation__c) ? '' : (vente.IdPrestation__c.replace(' ', '')).toUpperCase();

            libellePres =   codePrestationMap.get(idPresta)      != null ? codePrestationMap.get(idPresta).LibelleDePrestation__c :
                            libellePrestationMap.get(bbusPresta) != null ? libellePrestationMap.get(bbusPresta).LibelleDePrestation__c: vente.LibellePrestation__c;

            venteWrapperList.add( New venteWrapper( vente.Nomhotel__c ,
                                                    vente.PrenomBooker__c + ' ' + vente.NomBooker__c,
                                                    vente.Nom_du_stayer__c,                                                    
                                                    libellePres,
                                                    vente.NumFactureAvoir__c,
                                                    vente.IDCRSClient__c,
                                                    vente.NumReservation__c,
                                                    Integer.ValueOf(vente.Quantite__c),
                                                    Integer.ValueOf(vente.Taux_TVA__c),
                                                    vente.Montant_TVA__c,
                                                    vente.Montant_TTC__c,
                                                    vente.Montant_HT__c,
                                                    vente.DateSejour__c
                                                    ));

            tva10TotalHT        = vente.Taux_TVA__c == 10 ? tva10TotalHT  + vente.Montant_HT__c  : tva10TotalHT ;
            tva10Totaltva       = vente.Taux_TVA__c == 10 ? tva10Totaltva + vente.Montant_TVA__c : tva10Totaltva;
            tva10TotalTTC       = vente.Taux_TVA__c == 10 ? tva10TotalTTC + vente.Montant_TTC__c : tva10TotalTTC;
            tva20TotalHT        = vente.Taux_TVA__c == 20 ? tva20TotalHT  + vente.Montant_HT__c  : tva20TotalHT ;
            tva20Totaltva       = vente.Taux_TVA__c == 20 ? tva20Totaltva + vente.Montant_TVA__c : tva20Totaltva ;
            tva20TotalTTC       = vente.Taux_TVA__c == 20 ? tva20TotalTTC + vente.Montant_TTC__c : tva20TotalTTC ;
            exclTotalHT         = vente.Taux_TVA__c == 0  ? exclTotalHT   + vente.Montant_HT__c  : exclTotalHT ;
            exclTotaltva        = vente.Taux_TVA__c == 0  ? exclTotaltva  + vente.Montant_TVA__c : exclTotaltva ;
            exclTotalTTC        = vente.Taux_TVA__c == 0  ? exclTotalTTC  + vente.Montant_TTC__c : exclTotalTTC ;
            totalHT             = totalHT  + vente.Montant_HT__c;
            totaltva            = totaltva + vente.Montant_TVA__c;
            totalTTC            = totalTTC + vente.Montant_TTC__c;
            corporateCode       = vente.Contrat__r.CorporateCode__r.Name;
        }

        premiereConso = date.newInstance(System.Today().addMonths(-1).year(), System.Today().addMonths(-1).Month(), 1); 
        derniereConso = (date.newInstance(System.Today().year(), System.Today().Month(), 1)).AddDays(-1); 
    }

}