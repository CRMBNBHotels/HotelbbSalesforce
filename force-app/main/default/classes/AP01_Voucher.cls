/**
* @author TMA-EI JK
* @date 07/03/2019
* @description Fill fields on the IR/OC recordtypes of the object Voucher and create a case on the creation of an IR
* @Test Class: AP01_Voucher_Test
* @Coverage: 83%
*/
public without sharing class AP01_Voucher {
    //This method is to fill fields on creation
    public static void FillInvitationInformationOnCreation(list<Voucher__c> listVouchers){
        
        For(Voucher__c voucher : listVouchers){
            //Fill the interlocuteur if the source of the case is SF not BBUS. If from BBUS this field will be inserted
            if(voucher.Interlocuteur__c == null){
                voucher.Interlocuteur__c = UserInfo.getName();
            }            
        }
        FillInvitationInformation(listVouchers);
    }
    
    //This method is to fill fields on modification
    //On creation, the value of the field "Statut" is  "Open" or "Generated"
    public static void FillInvitationInformationOnModification(list<Voucher__c> listVouchers){
        
        For(Voucher__c voucher : listVouchers){
            
            if(voucher.Statut__c == 'Generated'){
                
                if(Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name) != null && voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name).getRecordTypeId()){
                    voucher.RecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_Emission_Name).getRecordTypeId();
                }
                if(Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_OC_RT_OnCreation_Name) != null && voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_OC_RT_OnCreation_Name).getRecordTypeId()){
                    voucher.RecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_OC_RT_Emission_Name).getRecordTypeId();
                }
                //Changes by JR
                if(Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_Eclub_RT_OnCreation_Name) != null && voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_Eclub_RT_OnCreation_Name).getRecordTypeId()){
                    voucher.RecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_EClub_RT_Emission_Name).getRecordTypeId();
                }
            }
            
        }
        FillInvitationInformation(listVouchers);
    }
    
    //This is a common method for both creation and modification
    public static void FillInvitationInformation(list<Voucher__c> listVouchers){
        
        //Added by TMA-EIT CG CRMSS-870 06/10/2020 Start
        String VoucherOCRT = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get('OC').getRecordTypeId();
        list<Voucher__c> listFilteredVouchers = new list<Voucher__c>();
        
        For(Voucher__c voucher : listVouchers){
            
            
            if(voucher.RecordTypeId != VoucherOCRT){
                
                listFilteredVouchers.add(voucher);
            }
        }
        //Added by TMA-EIT CG CRMSS-870 06/10/2020 End
        
        //Added by TMA-EIT JK CRMSS-896    
        //Get Custom settings data for the value of prestation
        List<PrestationOffertMapping__mdt> listPrestaOfferte = [select Value__c,DeveloperName
                                                                from PrestationOffertMapping__mdt];
        //Set  a map of prestation offerte code -> Value
        Map<String,String> mapPrestaOff = new Map<String,String>();
        
        For(PrestationOffertMapping__mdt presta :listPrestaOfferte){
            mapPrestaOff.put(presta.DeveloperName, presta.Value__c);           
        }
        
        //Get Custom settings data for the value of valorisation
        List<InvitationValorisationmdt__mdt > listInvitationValorisation = [select Prestation_offerte__c,Valorisation__c
                                                                      from InvitationValorisationmdt__mdt ];
        system.debug('###3 listInvitationValorisation ' + listInvitationValorisation);
        
        //Set  a map of prestation offerte -> Valorisation
        Map<String,Decimal> mapPrestaValorisation = new Map<String,Decimal>();
        
        For(InvitationValorisationmdt__mdt  val :listInvitationValorisation){
            mapPrestaValorisation.put(val.Prestation_offerte__c, val.Valorisation__c);           
        }
        system.debug('###3 mapPrestaValorisation ' + mapPrestaValorisation);
        //Set values
        
        if(listFilteredVouchers != null && listFilteredVouchers.size()>0){
            
            For(Voucher__c voucher : listFilteredVouchers){
                
                //Added by TMA-EIT JK CRMSS-896
                //Fill presta value based on prestation code
                if(voucher.Prestation_offerte__c != null && mapPrestaOff.containsKey(voucher.Prestation_offerte__c)){
                    voucher.Prestation_offerte__c = mapPrestaOff.get(voucher.Prestation_offerte__c);
                }
                
                //Fill valorisation based on prestation offerte
                if(voucher.Prestation_offerte__c != null && mapPrestaValorisation.containsKey(voucher.Prestation_offerte__c)){
                    system.debug('### cg voucher.Prestation_offerte__c '+voucher.Prestation_offerte__c );
                    voucher.Valorisation__c = mapPrestaValorisation.get(voucher.Prestation_offerte__c);system.debug('### cg mapPrestaValorisation.get(voucher.Prestation_offerte__c) '+mapPrestaValorisation.get(voucher.Prestation_offerte__c) );
                }
                //Erase the value of Hotel if the field Service is not equal to Hotel
                if(voucher.service__c != null && voucher.Service__c != 'Hotel' && voucher.Hotel__c != null){
                    voucher.Hotel__c = null;
                }
                
                //If the person Account is Generic, automatically assign the Email address
                if(voucher.Guest_Account__c == Label.Account_CompteGenericID){
                    voucher.Email_du_client__c = voucher.Email_PA__c;
                }
            } 
        }  
    }
    
    
    //Create a Case linked to the invitation
    public static void CreateCase(list<Voucher__c> listVouchers){
        
        List<Case> listCaseToInsert = new List<Case>();
        List<Voucher__c> listVoucherToUpdate = new List<Voucher__c>();
        List<Voucher__c> listVoucherToCheck = [select id,RecordTypeID,Hotel__r.country__c,Person_Account__c,TYPES__c, Responsabilite__c, Hotel_name__c, // Modified By TMA-EIL CG CRMSS-829 16/09/2020
                                               OBJET__c,MOTIF__c,tech_vPersonalContact__c,hotel__c,Hotel_transmitter__c from voucher__c where id in:listVouchers];
        
        list<Voucher_Responsability_Setting__mdt> listVouchResponMdt = [select Id, value__c, code__c from Voucher_Responsability_Setting__mdt];
        system.debug('### cg listVouchResponMdt: '+listVouchResponMdt);
        
        //Get metadata voucher case mapping
        List<VoucherCaseMapping__mdt> listCaseVoucher = [select  Id, DeveloperName, Field_Name__c, Case_value__c from VoucherCaseMapping__mdt];
        map<String,String> typeMapping = new map<String,String>();
        map<String,String> objetMapping = new map<String,String>();
        map<String,String> motifMapping = new map<String,String>();
        
        for(VoucherCaseMapping__mdt caseVoucher : listCaseVoucher){
            if(caseVoucher.Field_Name__c == 'Type'){
                typeMapping.put(caseVoucher.DeveloperName,caseVoucher.Case_value__c);
            }else
            if(caseVoucher.Field_Name__c == 'Objet'){
                objetMapping.put(caseVoucher.DeveloperName,caseVoucher.Case_value__c);
            }else
            if(caseVoucher.Field_Name__c == 'Motif'){
                motifMapping.put(caseVoucher.DeveloperName,caseVoucher.Case_value__c);
            }
            
        }
        
        //Insert Cases
        
        For(Voucher__c voucher : listVoucherToCheck){
            
            if(voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name).getRecordTypeId() || 
               voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_Emission_Name).getRecordTypeId()){
                   
                   Case caseToCreate = new Case();
                   //caseToCreate.RecordTypeId= Label.Case_RT_Case_linked_to_IR;
                   if(voucher.Hotel__r.country__c == 'DE' ||voucher.Hotel__r.country__c == 'Germany' || voucher.Hotel__r.country__c == 'AT' ||voucher.Hotel__r.country__c == 'Austria'){
                       caseToCreate.RecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customers_Request_Feedback_Germany').getRecordTypeId();
                   }
                   if(voucher.Hotel__r.country__c == 'IT' ||voucher.Hotel__r.country__c == 'Italy' ){
                       caseToCreate.RecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customers_Request_Feedback_Italy').getRecordTypeId();
                   }
                   if(voucher.Hotel__r.country__c == 'PT'|| voucher.Hotel__r.country__c == 'ES'||voucher.Hotel__r.country__c == 'Portugal'||voucher.Hotel__r.country__c == 'Spain'){
                       caseToCreate.RecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Request_Claim_Feedback_Spain_Portugal').getRecordTypeId();
                   }
                   if(voucher.Hotel__r.country__c == 'FR'||voucher.Hotel__r.country__c == 'France'){
                       
                       caseToCreate.RecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customers_Request_Feedback_France').getRecordTypeId();
                       
                       //Added By TMA-EIL CG CRMSS-829 16/09/2020 Start
                       caseToCreate.Category__c = 'GUARANTIE RI';
                       caseToCreate.Compensation_Type__c = 'Refund/Invit';
                       
                       if(voucher.Hotel_name__c != null && voucher.Hotel_name__c != ''){
                           
                           caseToCreate.Hotel_Name__c = voucher.Hotel_name__c;
                       }
                       if(voucher.Responsabilite__c != null && voucher.Responsabilite__c != '') {
                           
                           for(Voucher_Responsability_Setting__mdt resp : listVouchResponMdt){
                               
                               if(resp.code__c == voucher.Responsabilite__c){
                                   
                                   caseToCreate.Responsabilit__c = resp.value__c;
                                   break;
                               }
                           }
                           
                           
                       }
                       //Added By TMA-EIL CG CRMSS-829 16/09/2020 End
                   }
                   
                   system.debug('### cg voucher.Responsabilite__c: '+voucher.Responsabilite__c);
                   system.debug('### cg caseToCreate.Responsabilit__c: '+caseToCreate.Responsabilit__c);
                   caseToCreate.Origin = 'Invitation IR';
                   caseToCreate.AccountId = voucher.Person_Account__c;
                  /* caseToCreate.TYPES__c = voucher.TYPES__c;
                   caseToCreate.OBJETS__c = voucher.OBJET__c;
                   caseToCreate.MOTIFS__c = voucher.MOTIF__c;*/
                   //Modified JK CRMSS - 896
                   if(voucher.TYPES__c != null && typeMapping.containskey(voucher.TYPES__c)){
                       caseToCreate.TYPES__c = typeMapping.get(voucher.TYPES__c);
                   }else{
                       caseToCreate.TYPES__c = voucher.TYPES__c;
                   }
                   if(voucher.OBJET__c != null && objetMapping.containskey(voucher.OBJET__c)){
                       caseToCreate.OBJETS__c = objetMapping.get(voucher.OBJET__c);
                   }else{
                       caseToCreate.OBJETS__c = voucher.OBJET__c;
                   }
                   if(voucher.MOTIF__c != null && motifMapping.containskey(voucher.MOTIF__c)){
                       caseToCreate.MOTIFS__c = motifMapping.get(voucher.MOTIF__c);
                   }else{
                       caseToCreate.MOTIFS__c = voucher.MOTIF__c;
                   }
                   caseToCreate.Invitation__c = voucher.id;
                   caseToCreate.Status='Closed';
                   caseToCreate.Type = 'Garantie-RI';
                   caseToCreate.Salesforce_Case_Type__c = 'Garantie RI';
                   caseToCreate.ContactId= voucher.tech_vPersonalContact__c;
                   caseToCreate.Hotel__c= voucher.Hotel__c;
                   caseToCreate.Category__c = 'GARANTIE RI';
                   caseToCreate.Compensation_type__c = 'Invitation';
                   caseToCreate.Hotel__c = voucher.Hotel_transmitter__c;
                   listCaseToInsert.add(caseToCreate);
                   
               }
        }     
        
        if(listCaseToInsert != null && listCaseToInsert.size() > 0){
            insert listCaseToInsert;
            
        }
        
        system.debug('####listVoucherToUpdate.size()' +  listVoucherToUpdate.size());
        //Update vouchers
        For(Case cas :listCaseToInsert){
            Voucher__c vouch = new Voucher__c();
            vouch.id = cas.Invitation__c;
            vouch.Demande_d_assistance__c = cas.id;
            listVoucherToUpdate.add(vouch);
        }
        
        if(listVoucherToUpdate != null && listVoucherToUpdate.size() >0){
            update listVoucherToUpdate;
            
        }
    }
}