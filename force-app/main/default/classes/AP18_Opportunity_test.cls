/*
* Description: Test Class for AP18_Opportunity 
* @author: TMA-EI Cynthia Geagea
* @date: 111/03/2020
*/

@isTest
public class AP18_Opportunity_test {
    
    @isTest
    public static void testFillOppOpco(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            
            list<hotel__c> listHotels = new list<hotel__c>();
            
            hotel__c hotFR = new hotel__c(Commercial_Hotel_Name__c = 'test hotel1', Hotel_ID__c='2343', country__c = 'FR');
            listHotels.add(hotFR);
            
            hotel__c hotIT = new hotel__c(Commercial_Hotel_Name__c = 'test hotel2', Hotel_ID__c='2345', country__c = 'IT');
            listHotels.add(hotIT);
            
            hotel__c hotES = new hotel__c(Commercial_Hotel_Name__c = 'test hotel3', Hotel_ID__c='2346', country__c = 'ES');
            listHotels.add(hotES);
            
            insert listHotels;
            
            list<Opportunity> listMasterBookings = new list<Opportunity>();
            
            Opportunity masterBook1 = new Opportunity(Name = 'masterBookingTest1', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            listMasterBookings.add(masterBook1);
            Opportunity masterBook2 = new Opportunity(Name = 'masterBookingTest2', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            listMasterBookings.add(masterBook2);
            
            insert listMasterBookings;
            
            list<Opportunity> listBookings = new list<Opportunity>();
            
            Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'Cancelled', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id, hotel__c = hotFR.Id);
            listBookings.add(book1);
            
            Opportunity book2 = new Opportunity(Name = 'Booking2', CloseDate = date.today(), StageName = 'Error', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id, hotel__c = hotIT.Id);
            listBookings.add(book2);
            
            Opportunity book3 = new Opportunity(Name = 'Booking3', CloseDate = date.today(), StageName = 'No Show', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id, hotel__c = hotES.Id);
            listBookings.add(book3);
            
            Opportunity book4 = new Opportunity(Name = 'Booking4', CloseDate = date.today(), StageName = 'Checked', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id, hotel__c = hotFR.Id);
            listBookings.add(book4);
            
            Opportunity book5 = new Opportunity(Name = 'Booking5', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id, hotel__c = hotES.Id);
            listBookings.add(book5);
            
            test.startTest();
            
            database.insert(listBookings, false);
            
            test.stopTest();
        }
        
    }
    
}