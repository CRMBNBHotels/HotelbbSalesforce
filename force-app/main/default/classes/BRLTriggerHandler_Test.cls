/** 
* Test class for the BRLTriggerHandler Apex Class
* @author JKA 
* @version 0.1
* @date 24/01/2020 
*/
@isTest
public class BRLTriggerHandler_Test {
    
    @isTest
    static void testBRLTriggerHandler(){	
        
        //Insert Booking
        Account Partner = Utils.CreatePartnerAccount('Partner1','456');
        insert Partner;
        
        Contact con = Utils.CreateContact('Contact', Partner.Id, label.EN);
        insert con;
        
        Account Person = Utils.CreatePersonAccount('Person1',Partner.Id);
        insert Person;
        
        Account Person2 = Utils.CreatePersonAccount('Person2',Partner.Id);
        insert Person2;
        
        Opportunity MasterBooking = Utils.CreateMasterBookingOpportunity('MasterBooking1', Person.Id);
        MasterBooking.StageName = label.ClosedWonStage;
        insert MasterBooking;
        
        Opportunity MasterBooking2 = Utils.CreateMasterBookingOpportunity('MasterBooking2', Person2.Id);
        MasterBooking.StageName = label.ClosedWonStage;
        insert MasterBooking2;
        
        List<Opportunity> bookings = new List<Opportunity> ();
        list<Opportunity> listBookings = new list<Opportunity>();
        
        Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'Cancelled', Breakfasts__c = 0, RecordTypeId = Label.BookingRecordTypeId, Master_Booking_FK__c = MasterBooking.id);
        listBookings.add(book1);
        
        Opportunity book2 = new Opportunity(Name = 'Booking2', CloseDate = date.today(),  StageName = label.ClosedWonStage, Breakfasts__c = 3, RecordTypeId = Label.BookingRecordTypeId, Master_Booking_FK__c = MasterBooking2.id);
        listBookings.add(book2);
        
        insert listBookings;

        
        
        
        Booking_Room_Line__c roomLine = Utils.CreateBookingRoomLine(book1.Id);

        
        roomLine.Quantity__c = 3;
        roomLine.Room_code__c = 'BREAKFAST';


        
        BookingLinesCustomSettings__c broomCode= new BookingLinesCustomSettings__c(name = 'BREAKFAST',Breakfast_Room_Code__c='BREAKFAST');
        insert broomCode;
        BookingLinesCustomSettings__c chambreCode1= new BookingLinesCustomSettings__c(name = 'F112T',ChamreRoomCode__c='F112T');
        insert chambreCode1;
        BookingLinesCustomSettings__c chambreCode= new BookingLinesCustomSettings__c(name = 'F112',ChamreRoomCode__c='F112');
        insert chambreCode;
        
        BookingLinesCustomSettings__c broomCode1= new BookingLinesCustomSettings__c(name = 'BKF-ECLUB',Breakfast_Room_Code__c='BKF-ECLUB');
        insert broomCode1;
        
        Test.startTest();
        insert roomLine;
        roomLine.Quantity__c = 4;
        roomLine.Room_code__c='BKF-ECLUB';
        update roomLine;
        delete roomLine;
        undelete roomline;
        Test.stopTest();
        
    }
    
}