/*
* Description: Test Class for AP10_Opportunity 
* @author: TMA-EI Cynthia Geagea
* @date: 16/08/2019
*/

@isTest
public class AP10_Opportunity_Test {
    
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
            
            list<Opportunity> listMasterBookings = new list<Opportunity>();
            
            Opportunity masterBook1 = new Opportunity(Name = 'masterBookingTest1', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            listMasterBookings.add(masterBook1);
            Opportunity masterBook2 = new Opportunity(Name = 'masterBookingTest2', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            listMasterBookings.add(masterBook2);
            
            insert listMasterBookings;
            
            list<Opportunity> listBookings = new list<Opportunity>();
            
            Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'Cancelled', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book1);
            
            Opportunity book2 = new Opportunity(Name = 'Booking2', CloseDate = date.today(), StageName = 'Error', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book2);
            
            Opportunity book3 = new Opportunity(Name = 'Booking3', CloseDate = date.today(), StageName = 'No Show', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book3);
            
            Opportunity book4 = new Opportunity(Name = 'Booking4', CloseDate = date.today(), StageName = 'Checked', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book4);
            
            Opportunity book5 = new Opportunity(Name = 'Booking5', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book5);
            
            //Added by TMA Cynthia Geagea - CRMSS 284-258 - 16/09/2019 - Start
            Opportunity book6 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), Confirmation_Number__c = '010101', StageName = 'Cancelled', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book6);
            
            Opportunity book7 = new Opportunity(Name = 'Booking2', CloseDate = date.today(), Confirmation_Number__c = '010101', StageName = 'Cancelled', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
            listBookings.add(book7);
            //Added by TMA Cynthia Geagea - CRMSS 284-258 - 16/09/2019 - End
            
            test.startTest();
            
            database.insert(listBookings, false);
            
            book5.StageName = 'Cancelled';
            book4.Master_Booking_FK__c = masterBook2.Id;
            database.update(listBookings, false);
            
            //Added by TMA Cynthia Geagea - CRMSS 284-258 - 16/09/2019 - Start
            book7.Master_Booking_FK__c = masterBook2.id;
            database.update(listBookings, false);
            
            book6.Master_Booking_FK__c = masterBook2.Id;
            database.update(listBookings, false);
            //Added by TMA Cynthia Geagea - CRMSS 284-258 - 16/09/2019 - End
            
           // database.delete(book3, false);
            
            //Added by TMA Cynthia Geagea - CRMSS 284-258 - 16/09/2019 - Start
            database.delete(book6, false);
            database.delete(book7, false);
            //Added by TMA Cynthia Geagea - CRMSS 284-258 - 16/09/2019 - End
            
            test.stopTest();
            
        }
    }

}