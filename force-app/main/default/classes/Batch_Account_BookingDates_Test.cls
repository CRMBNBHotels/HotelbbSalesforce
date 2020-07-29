/*
* Description: Test Class for Batch_Account_BookingDates. This class must be run with the triggers AfterInsertOpportunity and AfterUpdateOpportunity bypassed
* @author: TMA-EIL JKA
* @date: 03/12/2019
*/

@isTest
public class Batch_Account_BookingDates_Test {
    
    @isTest
    static void batchAccBookDateTest(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        
        insert userTest;
        
        System.runAs(userTest){
            
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            
            list<opportunity> listMBs = new list<opportunity>();
            list<Account> listPersonAcc = new list<Account>();
            
            Account personAcc1 = new Account(LastName = 'test1', Email__pc = 'test1@asce.com');
            listPersonAcc.add(personAcc1);
            Account personAcc2 = new Account(LastName = 'test2', Email__pc = 'test2@asce.com');
            listPersonAcc.add(personAcc2);
           
            insert listPersonAcc;
                        
            for(integer i = 0; i < 5; i++){
                
                Opportunity masterBook = new Opportunity(Person_Account__c=personAcc1.id, Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today(),Departure_Date__c=Date.Today()+20);
                listMBs.add(masterBook);
            }
            
            for(integer i = 0; i < 5; i++){
                
                Opportunity masterBook2 = new Opportunity(Person_Account__c =personAcc2.Id,Name = 'masterBookingTest2'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today(),Departure_Date__c=Date.Today()+24);
                listMBs.add(masterBook2);
            }
            insert listMBs;
            
           
            test.startTest();
            map<String,String> mapAccId = new map<String,String>();
            mapAccId.put(personAcc1.ID,'Test class error');
            Batch_Account_BookingDates batchObj = new Batch_Account_BookingDates(mapAccId,0);
            DataBase.executeBatch(batchObj);
            batchObj = new Batch_Account_BookingDates(mapAccId,3);
            DataBase.executeBatch(batchObj);
            
             batchObj = new Batch_Account_BookingDates(null,0);
            DataBase.executeBatch(batchObj);
            test.stopTest();
            
        }
    }
    
}