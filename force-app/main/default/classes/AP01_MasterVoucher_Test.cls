/*
* Description: Test Class for AP01_MasterVoucher 
* @author: TMA-EIT CG
* @date: 02/10/2020
*/

@isTest
public class AP01_MasterVoucher_Test {
    
    @isTest
    Public Static void fillMasterVoucherInformationInsertTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,division = Label.AP01_MasterVoucher_DivisionCorporate, FirstName = 'user', department = 'DIRECTION GENERALE',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        // testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            Id MVcreationId = Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_OnCreation_DevName).getRecordTypeId();
            
            //Insert PA
            Account acc =  Utils.CreatePartnerAccount('acc', '125252');                      
            insert acc;
            
            
            Account PersonAccount =  Utils.CreatePersonAccount('Person', null);    
            PersonAccount.LastName = 'Test';
            PersonAccount.FirstName = 'Test';
            PersonAccount.personemail = 'personaccounttest@asce.com';
            PersonAccount.personmobilephone = '96156848474';
            insert PersonAccount;
            
            list<Master_Voucher__c> listMasterVoucher = new list<Master_Voucher__c>();
            
            for(Integer i = 0; i<10; i++){
                
                Master_Voucher__c masterVouch = new Master_Voucher__c();
                masterVouch.recordtypeid = MVcreationId;
                masterVouch.Personal_account__c = PersonAccount.Id;
                masterVouch.Nom_Pr_nom_client__c = 'testPrenom'+i;
                masterVouch.Offert_l_occasion_de__c = 'testOccasion'+i;
                masterVouch.Nature_de_la_demande__c = 'Manifestation sportive';
                masterVouch.Nombre_de_copie_s__c = 1;
                masterVouch.P_riode_de_validit__c = 'Du lundi au dimanche';
                masterVouch.Zone_de_validit__c = 'France';
                masterVouch.Prestation_Offerte__c = 'Une nuit en chambre familiale';
                listMasterVoucher.add(masterVouch);
            }
            
            insert listMasterVoucher;
        }
    }
    
}