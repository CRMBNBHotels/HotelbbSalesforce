@isTest
public class VFC01_GetRelatedVouchers_Test {
    
    @isTest
    public static void getvouchers()
    {
        string rtID = Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_Consultation_DevName).getRecordTypeId();
        Master_Voucher__c masterVouch= new Master_Voucher__c();
        masterVouch.RecordTypeId = rtID ;
        masterVouch.Nom_Pr_nom_client__c = 'testPrenom';
        masterVouch.Offert_l_occasion_de__c = 'testOccasion';
        insert masterVouch;
        
        voucher__c voucherOC = new voucher__c();
        insert voucherOC;
  
        system.Test.startTest();
        VFC01_GetRelatedVouchers controller = new VFC01_GetRelatedVouchers(new ApexPages.StandardController(voucherOC));
        system.Test.stopTest();   
        
        
    }
}