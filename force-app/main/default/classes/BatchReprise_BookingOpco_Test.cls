/*
* Description: Test class for BatchReprise_BookingOpco
* @author: TMA-EIL Cynthia Geagea
* @date: 17/03/2020
*/

@isTest
public class BatchReprise_BookingOpco_Test {
    
    @isTest
    static void batchBookOpcoTest(){
        
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
            
            list<hotel__c> listHotels = new list<hotel__c>();
            
            hotel__c hotFR = new hotel__c(Commercial_Hotel_Name__c = 'test hotel1', Hotel_ID__c='2343', country__c = 'FR');
            listHotels.add(hotFR);
            
            hotel__c hotIT = new hotel__c(Commercial_Hotel_Name__c = 'test hotel2', Hotel_ID__c='2345', country__c = 'IT');
            listHotels.add(hotIT);
            
            hotel__c hotES = new hotel__c(Commercial_Hotel_Name__c = 'test hotel3', Hotel_ID__c='2346', country__c = 'ES');
            listHotels.add(hotES);
            
            insert listHotels;
            
            list<Opportunity> listBooking=  new list<Opportunity>();
            
            for(integer i = 0; i<50; i++){
                 Opportunity book = new Opportunity(Name = 'Booking', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, hotel__c = hotFR.Id);
           		 listBooking.add(book);
            }
            
            for(integer i = 0; i<50; i++){
                 Opportunity book = new Opportunity(Name = 'Booking', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, hotel__c = hotIT.Id);
           		 listBooking.add(book);
            }
            
            for(integer i = 0; i<50; i++){
                 Opportunity book = new Opportunity(Name = 'Booking', CloseDate = date.today(), StageName = 'Booked', RecordTypeId = bookingRTId, hotel__c = hotES.Id);
           		 listBooking.add(book);
            }
            
            insert listBooking;
            
            /*list<opportunity> listopp = new list<opportunity>([select id, opco__c, hotelcountry__c, recordtype.developername from opportunity where id in: listBooking]);
            system.debug('### cg listopp'+listopp);*/
            
            test.startTest();
            
            BatchReprise_BookingOpco batchobj = new BatchReprise_BookingOpco();
            database.executeBatch(batchobj);
            
            test.stopTest();
            
        }
    }
}