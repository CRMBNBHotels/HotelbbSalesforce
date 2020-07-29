/*
* Description: Test Class for AP16_Opportunity 
* @author: TMA-EIL Cynthia Geagea
* @date: 18/11/2019
*/

@isTest
public class AP16_Opportunity_Test {
    
    @isTest
    public static void updateFirstBookDateTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            
            list<Account> listPersonAcc = new list<Account>();
            
            Account personAcc1 = new Account(LastName = 'test1', Email__pc = 'test1@asce.com');
            listPersonAcc.add(personAcc1);
            Account personAcc2 = new Account(LastName = 'test2', Email__pc = 'test2@asce.com');
            listPersonAcc.add(personAcc2);
            
            insert listPersonAcc;
            
            list<Opportunity> listNewMasterBookings =  new list<Opportunity>();
            
            Opportunity book1 = new Opportunity(Name = 'MBooking1', CloseDate = date.today(), StageName = 'Open', Person_account__c = personAcc1.id, RecordTypeId = masterBookingRTId, Departure_Date__c = date.today());
            listNewMasterBookings.add(book1);
            
            Opportunity book2 = new Opportunity(Name = 'MBooking2', CloseDate = date.today(), StageName = 'Open', Person_account__c = personAcc1.id, RecordTypeId = masterBookingRTId, Departure_Date__c = date.today());
            listNewMasterBookings.add(book2);
            
            Test.startTest();
            
            insert listNewMasterBookings;
            
            book2.Person_account__c = personAcc2.Id;
            update listNewMasterBookings;
            
            Test.stopTest();
                
        }
    }

}