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
    
     @isTest
    static void testCallBBUSWebservice_Bill(){
        Account accObj = new Account(LastName='testAccount',BillingCountry='Germany',BillingPostalCode='12345',Email__pc = 'test1@testtest.com');
        insert accObj;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        DataTableWrapper wrapper = BBUS_DataHistoryManager.callBBUSWebservice('bills',false, '', accObj.Id,null, null);
        Test.stopTest();
    }
    
    @isTest
    static void testCallBBUSWebservice_Loyalty(){
        Account accObj = new Account(LastName='testAccount',BillingCountry='Germany',BillingPostalCode='12345',Email__pc = 'test1@testtest.com');
        accObj.Externalid__c = '123450';
        accObj.Tech_points_results__c ='{"typePt":"ADD","sobj":{"attributes":{"type":"Account","url":"/services/data/v47.0/sobjects/Account/0012500000vUy9LAAS"},"Point_Request__c":"Processing","E_club_Number_of_points__pc":2000000.0,"Tech_BBUS__c":true,"Id":"0012500000vUy9LAAS"},"Reason":"Points regulation","nbPoint":2000000,"Description":"mmm"}';
        insert accObj;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        Set<String> setFieldPoints = new Set<String>();
        setFieldPoints.add('E_club_Number_of_points__pc');
        HttpResponse response = BBUS_DataHistoryManager.callBBUSWebserviceResponse('AccountPoints',null, null, accObj.Externalid__c, setFieldPoints);
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
    
   /*@isTest
    static void testCallBBUSWebservice_Account_NoResponse(){
        String IRRecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
        Account accObj = new Account(LastName='testAccount',BillingCountry='Germany',BillingPostalCode='12345',Email__pc = 'test1@testtest.com');
    	accObj.Externalid__pc ='12345';
        insert accObj;

        set<String> setField = new set<String>();
        set<String> setFieldClub = new set<String>();

        setFieldClub.add('E_club_Expiration_date__pc');
        setField.add('FirstName');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        AP05_Account.regularCallWS(accObj.Externalid__c,accObj.ID,setField,null);
        AP05_Account.regularCallWSEClub(accObj.Externalid__c,accObj.ID,setFieldClub);
        Test.stopTest();
    }*/
    
}