/*
* Description: Test Class for AP12_Opportunity 
* @author: TMA-EI julien debes
* @date: 26/09/2019
*/

@isTest
public class AP12_Opportunity_Test {
    
    @isTest
    public static void bookingsStageCountOnMBTest(){
        
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
            Hotel__c hotel = new Hotel__c();
            hotel.Commercial_Hotel_Name__c = '123';
            insert hotel;
            
            Opportunity masterBook1 = new Opportunity(Name = 'masterBookingTest1', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            insert masterBook1;
            
            Opportunity masterBook2 = new Opportunity(Name = 'masterBookingTest2', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            insert masterBook2;
            
            list<Opportunity> listBookings = new list<Opportunity>();
            
            Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'Cancelled', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
                      
            test.startTest();
            
            database.insert(book1, false);
            
            book1.Hotel__c = hotel.id;
            update book1;
            
            book1.Master_Booking_FK__c = masterBook2.id;
            update book1;
            
            delete book1;
            
            masterBook1.Name= 'masterBookingTest1.1';
            update masterBook1;
            
            test.stopTest();
            
        }
    }

}