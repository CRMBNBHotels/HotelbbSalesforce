/*
* Description: Test class for BatchReprise_MasterBookingOpco
* @author: TMA-EIL Cynthia Geagea
* @date: 17/03/2020
*/

@isTest
public class BatchReprise_MasterBookingOpco_Test {

    
    @isTest
    static void batchMBOpcoTest(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        userTest.BypassApex__c = 'AP18_Opportunity';
        
        insert userTest;
        
        System.runAs(userTest){
            
            UtilsBypass.SKIP_APEXCLASS_MAP.put('AP18_Opportunity','skipClass');
            UtilsBypass.SKIP_METHOD_MAP.put('fillMBOpco','skipMethod');
            
            Id bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            Id masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            
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
            
            for(integer i = 0; i<50; i++){
                
                 Opportunity book = new Opportunity(Name = 'Booking', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, hotel__c = hotFR.Id, Master_Booking_FK__c = masterBook1.Id);
           		 listBookings.add(book);
            }
            
            for(integer i = 0; i<50; i++){
                
                 Opportunity book = new Opportunity(Name = 'Booking', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, hotel__c = hotIT.Id, Master_Booking_FK__c = masterBook2.Id);
           		 listBookings.add(book);
            }
            
            insert listBookings;
            
            test.startTest();
            
            BatchReprise_MasterBookingOpco batchobj = new BatchReprise_MasterBookingOpco();
            database.executeBatch(batchobj);
            
            test.stopTest();
        }
    }
}