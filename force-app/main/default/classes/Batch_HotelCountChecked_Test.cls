/*
* Description: Test class for Batch_UpdateMB_ConfNb_HotelName
* @author: TMA-EIL JKA
* @date: 19/12/2019
*/

@isTest
public class Batch_HotelCountChecked_Test {
    
    @isTest
    static void batchHotelCountChecked(){
        
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
            List<Account> listPersonAcc = new List<Account>();
            List<Hotel__c> listHotels = new List<Hotel__c>();
            List<Opportunity> listBookings = new List<Opportunity>();
            
            Account personAcc1 = new Account(LastName = 'test1', Email__pc = 'test1@abcd.com', Hotels_Count__c = 0);
            listPersonAcc.add(personAcc1);
            Account personAcc2 = new Account(LastName = 'test2', Email__pc = 'test2@abcd.com', Hotels_Count__c = 0);
            listPersonAcc.add(personAcc2);
            
            insert listPersonAcc;
            
            Hotel__c testHotel1 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel1',Hotel_ID__c='2343');
            listHotels.add(testHotel1);
            Hotel__c testHotel2 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel2',Hotel_ID__c='23431');
            listHotels.add(testHotel2);
            Hotel__c testHotel3 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel3',Hotel_ID__c='23432');
            listHotels.add(testHotel3);
            Hotel__c testHotel4 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotel4',Hotel_ID__c='23433');
            listHotels.add(testHotel4);
            
            insert listHotels;
            
            
            Opportunity book1 = new Opportunity(Name = 'Booking1', Hotel__c = testHotel1.id, CloseDate = date.today(), StageName = 'Checked', Booking_Person_account__c = personAcc1.id, RecordTypeId = bookingRTId);
            listBookings.add(book1);
            
            Opportunity book2 = new Opportunity(Name = 'Booking2', Hotel__c = testHotel1.id, CloseDate = date.today(), StageName = 'Checked', Booking_Person_account__c = personAcc1.id, RecordTypeId = bookingRTId);
            listBookings.add(book2);
            
            Opportunity book3 = new Opportunity(Name = 'Booking3', Hotel__c = testHotel2.id, CloseDate = date.today(), StageName = 'Cancelled', Booking_Person_account__c = personAcc2.id, RecordTypeId = bookingRTId);
            listBookings.add(book3);
            
            Opportunity book4 = new Opportunity(Name = 'Booking4', Hotel__c = testHotel3.id, CloseDate = date.today(), StageName = 'Checked', Booking_Person_account__c = personAcc2.id, RecordTypeId = bookingRTId);
            listBookings.add(book4);
            
            insert listBookings;
            
            test.startTest();
            
            
            Batch_HotelCountChecked batchObj = new Batch_HotelCountChecked(null,0);
            DataBase.executeBatch(batchObj);
            
            map<String,String> mapPAId = new map<String,String>();
            mapPAId.put(listPersonAcc[0].ID,'Test class error');
            
            batchObj = new Batch_HotelCountChecked(mapPAId,0);
            DataBase.executeBatch(batchObj);
            batchObj = new Batch_HotelCountChecked(mapPAId,3);
            DataBase.executeBatch(batchObj);
            
            String[] toAddresses = new String[] {'joanna.karam@ei-technologies.com'};
            String Subject = 'Batch Error : Batch_HotelCountChecked ';
            
            Utils_Email.sendEmailApex(toAddresses, Subject,mapPAId);
            
            test.stopTest();
            
            
        }
    }
}