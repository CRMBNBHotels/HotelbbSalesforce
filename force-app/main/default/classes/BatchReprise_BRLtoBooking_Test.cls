/*
* Description: Test class for BatchReprise_BRLtoBooking(88%) and BookingRoomLineHandler(100%) AP02_BookingRoomLine(92%) Utils_Email(100%)
*when deploying deactivate the following triggers:
BookingRoomLineAfterUpdate
AfterInsertBookingLine
AfterDeleteBookingLine
* @author: TMA-EIL Cynthia Geagea // modified by JKA (17/12/2019)
* @date: 21/11/2019
*/

@isTest
public class BatchReprise_BRLtoBooking_Test {
    
    //added by TMA EIL CRMSS-469 24-02-2020 Start
    @testVisible static List<BookingLinesCustomSettingsmdt__mdt> customMetadata {    
        
        get {
            if ( customMetadata == null )
                customMetadata = [select Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Breakfast_Room_Code__c, Chamre_Room_Code__c from BookingLinesCustomSettingsmdt__mdt]; 
            return customMetadata;
            
        } set;
    }
    //added by TMA EIL CRMSS-469 24-02-2020 end
    
    @isTest
    static void batchBookingBKsandChambresUpdateTest(){
        
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
            
            list<Booking_Room_Line__c> listBRLs = new list<Booking_Room_Line__c>();
            
            list<Opportunity> listBookings = new list<Opportunity>();
            
            
            Opportunity booking1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'booked', RecordTypeId = bookingRTId);
            listBookings.add(booking1);
            Opportunity booking2 = new Opportunity(Name = 'Booking2', CloseDate = date.today(), StageName = 'booked', RecordTypeId = bookingRTId);
            listBookings.add(booking2);
            Opportunity booking3 = new Opportunity(Name = 'Booking3', CloseDate = date.today(), StageName = 'booked', RecordTypeId = bookingRTId);
            listBookings.add(booking3);
            insert listBookings;
            
            //added by TMA EIL CRMSS-469 24-02-2020 Start            
/*
BookingLinesCustomSettings__c broomCode= new BookingLinesCustomSettings__c(name = 'BREAKFASTCHILD',Breakfast_Room_Code__c='BREAKFASTCHILD');
insert broomCode;
BookingLinesCustomSettings__c chambreCode1= new BookingLinesCustomSettings__c(name = 'F224L',ChamreRoomCode__c='F224L');
insert chambreCode1;
*/
            //added by TMA EIL CRMSS-469 24-02-2020 end
            
            for(Integer i = 0; i<50; i++){
                
                Booking_Room_Line__c brl = Utils.CreateBookingRoomLine(Booking1.Id);
                brl.Room_code__c = 'BREAKFASTCHILD';
                brl.Quantity__c = 2;
                listBRLs.add(brl);
            }
            
            for(Integer i = 0; i<50; i++){
                
                Booking_Room_Line__c brl = Utils.CreateBookingRoomLine(Booking2.Id);
                brl.Room_code__c = 'F224L';
                brl.Quantity__c = 2;
                listBRLs.add(brl);
            }
            
            for(Integer i = 0; i<25; i++){
                
                Booking_Room_Line__c brl = Utils.CreateBookingRoomLine(Booking3.Id);
                brl.Room_code__c = 'BREAKFASTCHILD';
                brl.Quantity__c = 2;
                listBRLs.add(brl);
            }
            
            for(Integer i = 0; i<25; i++){
                
                Booking_Room_Line__c brl = Utils.CreateBookingRoomLine(Booking3.Id);
                brl.Room_code__c = 'F224L';
                brl.Quantity__c = 2;
                listBRLs.add(brl);
            }
            
            insert listBRLs;
            
            test.startTest();
            BatchReprise_BRLtoBooking batchObj = new BatchReprise_BRLtoBooking(null,0);
            DataBase.executeBatch(batchObj);  
            
            map<String,String> mapBookId = new map<String,String>();
            mapBookId.put(booking1.ID,'Test class error');
            
            batchObj = new BatchReprise_BRLtoBooking(mapBookId,5);
            DataBase.executeBatch(batchObj);
            database.delete(booking2, false);
            batchObj = new BatchReprise_BRLtoBooking(mapBookId,6);
            DataBase.executeBatch(batchObj);
            
            String[] toAddresses = new String[] {'joanna.karam@ei-technologies.com'};
                String Subject = 'Batch Error : BatchReprise_BRLtoBooking ';
            
            Utils_Email.sendEmailApex(toAddresses, Subject,mapBookId);
            
            test.stopTest();
            
        }
        
    }
}