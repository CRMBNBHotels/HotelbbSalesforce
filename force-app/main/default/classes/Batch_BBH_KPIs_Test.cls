/*
* Description: Test class for Batch_BBH_KPIs
* @author: TMA-EIL 
* @date: 10/02/2020
*/

@isTest
public class Batch_BBH_KPIs_Test {

    @isTest
    static void batchInsertKPIs(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        
        insert userTest;
        
        System.runAs(userTest){
            
            String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            String personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            
            list<Account> listPersonAcc = new list<Account>();
            list<Opportunity> listBookings = new list<opportunity>();
            list<Hotel__c> listHotels = new list<Hotel__c>();
            
            for(integer i = 0; i < 5; i++){
                
                Account acc = new Account(LastName = 'accTest'+i, Email__pc = 'testAcc'+i+'@asce.com', RecordTypeId = personAccRTId, Date_of_e_club_purchase__pc = date.valueOf('2020-01-01'));
                listPersonAcc.add(acc);
            }
            
            insert listPersonAcc;
            
            hotel__c hotelTest = new Hotel__c();
            hotelTest.Commercial_Hotel_Name__c = 'test hotel';
            hotelTest.Country__c = 'LB';
            listHotels.add(hotelTest);
            
            hotel__c hotelTest1 = new Hotel__c();
            hotelTest1.Commercial_Hotel_Name__c = 'test hotel ES';
            hotelTest1.Country__c = 'ES';
            listHotels.add(hotelTest1);
            
            hotel__c hotelTest2 = new Hotel__c();
            hotelTest2.Commercial_Hotel_Name__c = 'test hotel FR';
            hotelTest2.Country__c = 'FR';
            listHotels.add(hotelTest2);
            
            hotel__c hotelTest3 = new Hotel__c();
            hotelTest3.Commercial_Hotel_Name__c = 'test hotel IT';
            hotelTest3.Country__c = 'IT';
            listHotels.add(hotelTest3);
            
            insert listHotels;
            
            for(integer j = 0; j <= 4; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Checked', Hotel__c = hotelTest1.Id,
                                                   RecordTypeId = bookingRTId, Booking_Person_account__c = listPersonAcc[0].id);
                listBookings.add(book);
            }
            
            for(integer j = 0; j <= 4; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Checked', Hotel__c = hotelTest2.Id,
                                                   RecordTypeId = bookingRTId, Booking_Person_account__c = listPersonAcc[1].id);
                listBookings.add(book);
            }
            
            for(integer j = 5; j <= 9; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Checked', Hotel__c = hotelTest3.Id,
                                                   RecordTypeId = bookingRTId, Booking_Person_account__c = listPersonAcc[2].id);
                listBookings.add(book);
            }
            
            for(integer j = 10; j <= 14; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Checked', Hotel__c = hotelTest.Id, 
                                                   RecordTypeId = bookingRTId, Booking_Person_account__c = listPersonAcc[3].id);
                listBookings.add(book);
            }
            
            for(integer j = 15; j <= 19; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'No Show', Hotel__c = hotelTest.Id,
                                                   RecordTypeId = bookingRTId, Booking_Person_account__c = listPersonAcc[4].id);
                listBookings.add(book);
            }
            
            insert listBookings;
            
            test.startTest();
                
                Batch_BBH_KPIs batchObj = new Batch_BBH_KPIs();
                DataBase.executeBatch(batchObj);
            
            test.stopTest();
            
            list<KPIReports_TopLoyaltyProgram__c> listToCheck = [select id, Booking_date__c, Booking_EClub_Status__c from KPIReports_TopLoyaltyProgram__c];
            system.assertEquals(listToCheck[0].Booking_EClub_Status__c, 'Members');
        }
    }
}