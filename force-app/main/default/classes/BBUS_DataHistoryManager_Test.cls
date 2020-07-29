@isTest
public class BBUS_DataHistoryManager_Test {
    @isTest
    static void testCallBBUSWebservice_Wallet(){
        Account accObj = new Account(Name='testAccount',BillingCountry='Germany',BillingPostalCode='12345');
        insert accObj;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        DataTableWrapper wrapper = BBUS_DataHistoryManager.callBBUSWebservice('wallet',false, '', accObj.Id,null, null);
        Test.stopTest();
    }
    
    @isTest
    static void testCallBBUSWebservice_Voucher(){
        Account accObj = new Account(LastName='testAccount',BillingCountry='Germany',BillingPostalCode='12345',Email__pc = 'test1@testtest.com');
        insert accObj;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        DataTableWrapper wrapper = BBUS_DataHistoryManager.callBBUSWebservice('voucher',false, '', accObj.Id,null, null);
        Test.stopTest();
    }
    
    @isTest
    static void testCallBBUSWebservice_Booking(){
        Opportunity oppObj = new Opportunity(Name='testOpportunity',StageName='Checked', CloseDate=date.today());
        insert oppObj;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        DataTableWrapper wrapper = BBUS_DataHistoryManager.callBBUSWebservice('booking',false, '', oppObj.Id,null, null);
        Test.stopTest();
    }
    
    /*@isTest
static void testCallBBUSWebservice_Payment(){
Opportunity oppObj = new Opportunity(Name='testOpportunity',StageName='Checked', CloseDate=date.today());
insert oppObj;
Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
Test.startTest();
DataTableWrapper wrapper = BBUS_DataHistoryManager.callBBUSWebservice('payment',false, '', oppObj.Id);
Test.stopTest();
}*/ 
    
    //Methods Added BY TMA-EI JK CRMSS-96 
    
    
    @isTest
    static void testCallBBUSWebservice_Voucher_NoResponse(){
        system.debug('@@@@ BBVoucher call ');
        String IRRecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
        Account accObj = new Account(LastName='testAccount',BillingCountry='Germany',BillingPostalCode='12345',Email__pc = 'test1@testtest.com');
    
        insert accObj;
        
        Voucher__c voucherObj = new Voucher__c();
        voucherObj.RecordTypeId = IRRecordTypeID;
        voucherObj.Person_Account__c = accObj.id;
        voucherObj.Externalid__c = '1230';
        voucherObj.Statut__c = 'Generated';
        insert voucherObj;
        set<String> setField = new set<String>();
        setField.add('Statut__c');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        AP03_voucher.regularCallWS('1230',(String)voucherObj.id,setField);
       
        Test.stopTest();
    }
   
    
}