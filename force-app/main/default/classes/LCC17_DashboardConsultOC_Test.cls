/*
* Description: Test class for LC17_DashboardConsultOC 
* @author: TMA-EI CG
* @date: 26/10/2020
*/

@isTest
public class LCC17_DashboardConsultOC_Test {
    
    @isTest
    public static void GetRelatedVouchersTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,division = Label.AP01_MasterVoucher_DivisionCorporate, FirstName = 'user',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        // testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            Id MVcreationId = Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_OnCreation_DevName).getRecordTypeId();
            
            Account PersonAccount =  Utils.CreatePersonAccount('Person', null);    
            PersonAccount.LastName = 'Test';
            PersonAccount.FirstName = 'Test';
            PersonAccount.personemail = 'personaccounttest@asce.com';
            PersonAccount.personmobilephone = '96156848474';
            insert PersonAccount;
            
            
            Master_Voucher__c masterVouch = new Master_Voucher__c();
            masterVouch.recordtypeid = MVcreationId;
            masterVouch.Personal_account__c = PersonAccount.Id;
            masterVouch.Nombre_de_copie_s__c = 10;
            masterVouch.Nom_Pr_nom_client__c = 'testPrenom';
            masterVouch.Offert_l_occasion_de__c = 'testOccasion';
            masterVouch.Prestation_Offerte__c = 'Une nuit en chambre 1-2 personnes';
            masterVouch.Nature_de_la_demande__c = 'Animation';
            masterVouch.P_riode_de_validit__c = 'Du lundi au dimanche';
            
            test.startTest();
            insert masterVouch;
            test.stopTest();
            
            LCC17_DashboardConsultOC.GetRelatedVouchers(masterVouch.ID);
            
        }
    }
    
}