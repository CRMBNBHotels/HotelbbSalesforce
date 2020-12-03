/*
* Description: Test class for LCC18_DashboardConsultVoucherOC
* @author: TMA-EI CG
* @date: 03/12/2020
*/

@isTest
public class LCC18_DashboardConsultVoucherOC_Test {

    @isTest
    public static void GetRemainingQuotasTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,division = Label.AP01_MasterVoucher_DivisionCorporate, FirstName = 'user',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        // testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){

        Id MVcreationId = Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_OnCreation_DevName).getRecordTypeId();

        Master_Voucher__c masterVouch = new Master_Voucher__c(recordtypeid = MVcreationId, Offert_l_occasion_de__c = 'testOccasion', Prestation_Offerte__c = 'Une nuit en chambre 1-2 personnes',
        Nature_de_la_demande__c = 'Animation', P_riode_de_validit__c = 'Du lundi au dimanche',Nombre_de_copie_s__c = 1);
        insert masterVouch;

        Voucher__c Vouch = [Select Id, Code_OC__c, Master_Voucher_OC__c FROM Voucher__c where Master_Voucher_OC__c =: masterVouch.Id LIMIT 1];

        Test.StartTest();
        LCC18_DashboardConsultVoucherOC.GetVoucherOC(Vouch.Code_OC__c);
        Test.StopTest();
  
        }
    }

}