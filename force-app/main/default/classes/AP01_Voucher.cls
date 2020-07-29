/**
 * @author TMA-EI JK
 * @date 07/03/2019
 * @description Fill fields on the IR/OC recordtypes of the object Voucher and create a case on the creation of an IR
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
            
            //When the status is "Cancelled", the field Date_d_annulation__c is assigned
           /* if(voucher.Statut__c == 'Cancelled' && voucher.Date_d_annulation__c == null){
                voucher.Date_d_annulation__c = Date.today();
                if(voucher.Date_de_mise_en_peremption__c != null){
                    voucher.Date_de_mise_en_peremption__c = null;
                }
                
            }
            //When the status is "Expired", the field Date_de_mise_en_peremption__c is assigned
            else if(voucher.Statut__c == 'Expired' && voucher.Date_de_mise_en_peremption__c == null){
                voucher.Date_de_mise_en_peremption__c = Date.today();
                if(voucher.Date_d_annulation__c != null){
                    voucher.Date_d_annulation__c = null;
                }
            }
            //When the status is "Generated", the record type is modified : To see another Page Layout
            //If IRCreation -> IR
            //If OCCreation -> OC
            //If remove the fields Date_de_mise_en_peremption__c and Date_d_annulation__c
            else */if(voucher.Statut__c == 'Generated'){
                /*if(voucher.Date_de_mise_en_peremption__c != null){
                    voucher.Date_de_mise_en_peremption__c = null;
                }
                if(voucher.Date_d_annulation__c != null){
                    voucher.Date_d_annulation__c = null;
                }*/
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
             //When the status is not Expired or Cancelled => remove the fields Date_de_mise_en_peremption__c and Date_d_annulation__c
           /* else if(voucher.Statut__c != 'Expired' || voucher.Statut__c != 'Cancelled'){
                if(voucher.Statut__c != 'Expired' && voucher.Date_de_mise_en_peremption__c != null){
                    voucher.Date_de_mise_en_peremption__c = null;
                }
                if(voucher.Statut__c != 'Cancelled' && voucher.Date_d_annulation__c != null){
                    voucher.Date_d_annulation__c = null;
                }
            }*/
        }
        FillInvitationInformation(listVouchers);
    }
    
    //This is a common method for both cretion and modification
    public static void FillInvitationInformation(list<Voucher__c> listVouchers){
        //Get Custom settings data for the value of valorisation
        
        //added by TMA EIL CRMSS-469 24-02-2020 Start
        //List<InvitationValorisation__c> listInvitationValorisation = [select Prestation_offerte__c,Valorisation__c
                                                                      //from InvitationValorisation__c];
        List<InvitationValorisationmdt__mdt> listInvitationValorisation = [select Prestation_offerte__c,Valorisation__c
                                                                      from InvitationValorisationmdt__mdt];
        //Set  a map of prestation offerte -> Valorisation
        Map<String,Decimal> mapPrestaValorisation = new Map<String,Decimal>();
        //For(InvitationValorisation__c val :listInvitationValorisation){
        For(InvitationValorisationmdt__mdt val :listInvitationValorisation){
            mapPrestaValorisation.put(val.Prestation_offerte__c, val.Valorisation__c);           
        }
        //added by TMA EIL CRMSS-469 24-02-2020 end
        
        //Set values
        For(Voucher__c voucher : listVouchers){
            //Fill valorisation based on prestation offerte
            if(voucher.Prestation_offerte__c != null && mapPrestaValorisation.containsKey(voucher.Prestation_offerte__c)){
                voucher.Valorisation__c = mapPrestaValorisation.get(voucher.Prestation_offerte__c);
            }
            system.debug('VoucherValor' +voucher.Valorisation__c);
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
    
    
    //Create a Case linked to the invitation
    public static void CreateCase(list<Voucher__c> listVouchers){
        
        
        List<Case> listCaseToInsert = new List<Case>();
        List<Voucher__c> listVoucherToUpdate = new List<Voucher__c>();
        
        //Insert Cases
        For(Voucher__c voucher : listVouchers){
             system.debug('vvvvv voucher.RecordTypeID'+voucher.RecordTypeID);
            System.debug('vvvvv Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name).getRecordTypeId()'+Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name).getRecordTypeId());
            System.debug('vvvvv Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_Emission_Name).getRecordTypeId()'+Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_Emission_Name).getRecordTypeId());
            //Create a case if the voucher is an IR
           if(voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name).getRecordTypeId() || voucher.RecordTypeID  == Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_Emission_Name).getRecordTypeId()){
                   Case caseToCreate = new Case();
                   //caseToCreate.RecordTypeId= Label.Case_RT_Case_linked_to_IR;
                   caseToCreate.RecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Case_linked_to_IR').getRecordTypeId();
                   caseToCreate.Origin = 'Invitation IR';
                   caseToCreate.AccountId = voucher.Person_Account__c;
                   caseToCreate.TYPES__c = voucher.TYPES__c;
                   caseToCreate.OBJETS__c = voucher.OBJET__c;
                   //caseToCreate.MOTIFS__c = voucher.MOTIF__c;
                   caseToCreate.Invitation__c = voucher.id;
                   caseToCreate.Status='Closed';
                   caseToCreate.Type = 'Garantie-RI';
                   caseToCreate.ContactId= voucher.tech_vPersonalContact__c;
                   caseToCreate.Hotel__c= voucher.Hotel__c;
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
         system.debug('####listVoucherToUpdate.size()' +  listVoucherToUpdate.size());
       
        if(listVoucherToUpdate != null && listVoucherToUpdate.size() >0){
            system.debug('#### listVoucherToUpdate AP01 ' + listVoucherToUpdate);
            update listVoucherToUpdate;
          
        }
    }
}