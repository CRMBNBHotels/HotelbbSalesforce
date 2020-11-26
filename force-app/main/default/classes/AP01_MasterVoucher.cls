/*
* Description: Class to fill the information of the master voucher on before insert CRMSS-826
* @author: TMA JK
* @date: 01/10/2020
* @Test: AP01_MasterVoucher_Test
* @Coverage: 89%
*/

public class AP01_MasterVoucher {
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////Fill Information On the Master Voucher /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public static void fillMasterVoucherInformationInsert(list<Master_Voucher__c> listMasterVoucher){
        
        //Get only user id and contact / person account id that need to be fetched
        List<id> listUserIdToCheck = new List<Id>();
        List<id> listContactIdToCheck = new List<Id>();
        
        for(Master_Voucher__c masterVoucher : listMasterVoucher){
            
            if(masterVoucher.OwnerId != null)
                listUserIdToCheck.add(masterVoucher.OwnerId);
            
            if(masterVoucher.Personal_account__c != null)
                listContactIdToCheck.add(masterVoucher.Personal_account__c);
        }
        
        //Get Custom settings data for the value of valorisation
        List<InvitationValorisationmdt__mdt> listInvitationValorisation = [select Prestation_offerte__c,Valorisation__c
                                                                      from InvitationValorisationmdt__mdt
                                                                      Where object__c = 'Master Voucher'];
        //Set  a map of prestation offerte -> Valorisation
        Map<String,Decimal> mapPrestaValorisation = new Map<String,Decimal>();
        
        For(InvitationValorisationmdt__mdt val :listInvitationValorisation){
            mapPrestaValorisation.put(val.Prestation_offerte__c, val.Valorisation__c);           
        }
        
        
        //Fetch the info of the User and Contact / Person Account
        Map<Id,User> mapUser;
        
        if(listUserIdToCheck != null && listUserIdToCheck.size() >0 )
            mapUser = new Map<Id,User> ([Select id,division,Department
                                         From User
                                         Where isActive = True and id in :listUserIdToCheck]);
        Map<Id,Contact> mapContact;
        
        if(listContactIdToCheck != null && listContactIdToCheck.size() >0 )
            mapContact = new Map<Id,Contact> ([Select id,name, MobilePhone, Email
                                               From Contact
                                               Where id in :listContactIdToCheck]);
        String MasterVoucherRT = Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_Consultation_DevName).getRecordTypeId();
        
        //Fill the Information on the Master Voucher Based on the data fetched
        for(Master_Voucher__c masterVoucher : listMasterVoucher){
            
            if(Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_OnCreation_DevName) != null && masterVoucher.RecordTypeID  == Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_OnCreation_DevName).getRecordTypeId()){
                masterVoucher.RecordTypeID = MasterVoucherRT;
            }
            
            //Fill prenom nom emetteur
            masterVoucher.Pr_nom_Nom_de_l_m_tteur__c = masterVoucher.OwnerId;
      
            //Fill Service emetteur TMA-EIT CG CRMSS-960 26/11/2020
            if(masterVoucher.OwnerId != null && mapUser.containskey(masterVoucher.OwnerId) ){
                
                if(mapUser.get(masterVoucher.OwnerId).Department != null && mapUser.get(masterVoucher.OwnerId).Department != 'SRC'){
                    
                    masterVoucher.Service_emetteur__c = mapUser.get(masterVoucher.OwnerId).Department;
                }
            }
            
            //Fill person account information
            if(masterVoucher.Personal_account__c != null &&  mapContact.containskey(masterVoucher.Personal_account__c)){
                
                masterVoucher.Nom_Pr_nom_client__c = mapContact.get(masterVoucher.Personal_account__c).name;
                masterVoucher.Email_client__c = mapContact.get(masterVoucher.Personal_account__c).Email;
                masterVoucher.Num_ro_de_t_l_phone_client__c = mapContact.get(masterVoucher.Personal_account__c).mobilePhone;
            }
            
            //Fill valorisation
            if(masterVoucher.Prestation_offerte__c != null && mapPrestaValorisation.containsKey(masterVoucher.Prestation_offerte__c)){
                masterVoucher.Valorisation__c = mapPrestaValorisation.get(masterVoucher.Prestation_offerte__c);
            }
            
            //Fill date d'expiration
            if(masterVoucher.Dur_e_de_validit__c != null ){
                if(masterVoucher.Dur_e_de_validit__c == Label.AP01_MasterVoucher_Duree2Mois )
                    masterVoucher.Date_d_expiration__c = date.today().addmonths(2);
                
                if(masterVoucher.Dur_e_de_validit__c == Label.AP01_MasterVoucher_Duree6Mois )
                    masterVoucher.Date_d_expiration__c = date.today().addmonths(6);
            }
        }
    }
}