/*
* Description: Test class for Batch_UpdateMB_ConfNb_HotelName
* @author: TMA-EIL Cynthia Geagea
* @date: 16/12/2019
*/

@isTest
public class Batch_UpdateMB_ConfNb_HotelName_Test {
    
    @isTest
    static void batchUpdateMBTest(){
        
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
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            
            list<opportunity> listMBs = new list<opportunity>();
            list<Opportunity> listBookings = new list<opportunity>();
            
            hotel__c hotelTest = new Hotel__c();
            hotelTest.Commercial_Hotel_Name__c = 'test hotel';
            insert hotelTest;
            
            for(integer i = 0; i < 5; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
                listMBs.add(masterBook);
            }
            
            insert listMBs;
            
            for(integer j = 0; j <= 4; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Booked',Confirmation_Number__c = '000001', Hotel__c = hotelTest.Id, 
                                                   RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[0].id);
                listBookings.add(book);
            }
            
            for(integer j = 0; j <= 4; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Checked',Confirmation_Number__c = '000002', Hotel__c = hotelTest.Id,
                                                   RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[1].id);
                listBookings.add(book);
            }
            
            for(integer j = 5; j <= 9; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Cancelled',Confirmation_Number__c = '000003', Hotel__c = hotelTest.Id,
                                                   RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[2].id);
                listBookings.add(book);
            }
            
            for(integer j = 10; j <= 14; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Error',Confirmation_Number__c = '000004', Hotel__c = hotelTest.Id, 
                                                   RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[3].id);
                listBookings.add(book);
            }
            
            for(integer j = 15; j <= 19; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'No Show',Confirmation_Number__c = '000005', Hotel__c = hotelTest.Id,
                                                   RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[4].id);
                listBookings.add(book);
            }
            
            
            insert listBookings;
            
            test.startTest();
            
            Batch_UpdateMB_ConfNb_HotelName batchObj = new Batch_UpdateMB_ConfNb_HotelName(null,0);
            DataBase.executeBatch(batchObj);
            
            map<String,String> mapMBId = new map<String,String>();
            mapMBId.put(listMBs[0].ID,'Test class error');
            
            batchObj = new Batch_UpdateMB_ConfNb_HotelName(mapMBId,0);
            DataBase.executeBatch(batchObj);
            
            batchObj = new Batch_UpdateMB_ConfNb_HotelName(mapMBId,3);
            DataBase.executeBatch(batchObj);
            
            database.delete(listMBs[1].ID, false);
            
            batchObj = new Batch_UpdateMB_ConfNb_HotelName(mapMBId,4);
            DataBase.executeBatch(batchObj);
            
            String[] toAddresses = new String[] {'cynthia.geagea@ei-technologies.com'};
            String Subject = 'Batch Error : Batch_UpdateMB_ConfNb_HotelName ';
            
            Utils_Email.sendEmailApex(toAddresses, Subject,mapMBId);
            test.stopTest();
        }
    }

}