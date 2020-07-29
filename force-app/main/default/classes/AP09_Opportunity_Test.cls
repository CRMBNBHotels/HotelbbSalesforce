/*
* Description: Test Class for AP09_Opportunity 
* @author: TMA-EI Cynthia Geagea
* @date: 09/08/2019
*/

@isTest
public class AP09_Opportunity_Test {
    
    @isTest
    public static void bookedHotelsCountTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            
            list<Account> listPersonAcc = new list<Account>();
            
            Account personAcc1 = new Account(LastName = 'test1', Email__pc = 'test1@asce.com');
            listPersonAcc.add(personAcc1);
            Account personAcc2 = new Account(LastName = 'test2', Email__pc = 'test2@asce.com');
            listPersonAcc.add(personAcc2);
            
            insert listPersonAcc;
            
            list<Hotel__c> listHotels = new list<Hotel__c>();
            
            Hotel__c testHotel1 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel1',Hotel_ID__c='2343');            
            listHotels.add(testHotel1);
            Hotel__c testHotel2 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel2',Hotel_ID__c='23431');
            listHotels.add(testHotel2);
            Hotel__c testHotel3 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel3',Hotel_ID__c='23432');
            listHotels.add(testHotel3);
            Hotel__c testHotel4 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel4',Hotel_ID__c='23433');
            listHotels.add(testHotel4);
            
            insert listHotels;
            
            list<Opportunity> listNewBookings =  new list<Opportunity>();
            
            Opportunity book1 = new Opportunity(Name = 'Booking1', Hotel__c = testHotel1.id, CloseDate = date.today(), StageName = 'Checked', Booking_Person_account__c = personAcc1.id, RecordTypeId = bookingRTId);
            listNewBookings.add(book1);
            
            Opportunity book2 = new Opportunity(Name = 'Booking2', Hotel__c = testHotel1.id, CloseDate = date.today(), StageName = 'Checked', Booking_Person_account__c = personAcc1.id, RecordTypeId = bookingRTId);
            listNewBookings.add(book2);
            
            Opportunity book3 = new Opportunity(Name = 'Booking3', Hotel__c = testHotel2.id, CloseDate = date.today(), StageName = 'Cancelled', Booking_Person_account__c = personAcc1.id, RecordTypeId = bookingRTId);
            listNewBookings.add(book3);
            
            Opportunity book4 = new Opportunity(Name = 'Booking4', Hotel__c = testHotel3.id, CloseDate = date.today(), StageName = 'Checked', Booking_Person_account__c = personAcc1.id, RecordTypeId = bookingRTId);
            listNewBookings.add(book4);
            
            test.startTest();
            
            Database.insert(listNewBookings, false);
            
            book2.Hotel__c = testHotel4.id;
            book3.StageName = 'Checked';
            book4.Booking_Person_account__c = personAcc2.Id;
            
            Database.update(listNewBookings, false);
            
            book4.Booking_Person_account__c = personAcc1.Id;
            
            Database.update(listNewBookings, false);
            
            database.delete(book1, false);
            batch_HotelCountChecked batchObj = new Batch_HotelCountChecked(null,0);
            DataBase.executeBatch(batchObj);
            
            test.stopTest();
            
            
        }
        
    }

}