/*
* Description: Test class for AP02_BookingRoomLine
* @author: TMA-EIL Cynthia Geagea
* @date: 29/11/2019
* @coverage : 77%
*/


@isTest
public class AP02_BookingRoomLine_Test {
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
    static void updateBooking(){	
        
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

        
        List<Booking_Room_Line__c> bookingRoomLines = new List<Booking_Room_Line__c> ();
        
        Booking_Room_Line__c roomLine = Utils.CreateBookingRoomLine(book1.Id);
        Booking_Room_Line__c roomLine2 = Utils.CreateBookingRoomLine(book2.Id);
        Booking_Room_Line__c roomLine3 = Utils.CreateBookingRoomLine(book2.Id);
        
        roomLine.Quantity__c = 3;
        roomLine.Room_code__c = 'BREAKFAST';
        roomLine2.Quantity__c = 4;
        roomLine2.Room_code__c = 'F112'; 
        roomLine3.Quantity__c = 0;
        roomLine3.Room_code__c = 'F112'; 
        
        bookingRoomLines.add(roomLine);  
        bookingRoomLines.add(roomLine2); 
        bookingRoomLines.add(roomLine3); 
        //added by TMA EIL CRMSS-469 24-02-2020 Start
        /*
        BookingLinesCustomSettings__c broomCode= new BookingLinesCustomSettings__c(name = 'BREAKFAST',Breakfast_Room_Code__c='BREAKFAST');
        insert broomCode;
        BookingLinesCustomSettings__c chambreCode1= new BookingLinesCustomSettings__c(name = 'F112T',ChamreRoomCode__c='F112T');
        insert chambreCode1;
        BookingLinesCustomSettings__c chambreCode= new BookingLinesCustomSettings__c(name = 'F112',ChamreRoomCode__c='F112');
        insert chambreCode;
        
        BookingLinesCustomSettings__c broomCode1= new BookingLinesCustomSettings__c(name = 'BKF-ECLUB',Breakfast_Room_Code__c='BKF-ECLUB');
        insert broomCode1;
        */
        //added by TMA EIL CRMSS-469 24-02-2020 end
        Test.startTest();
        
        insert bookingRoomLines;
        roomLine.Quantity__c = 4;
        roomLine.Room_code__c='BKF-ECLUB';
        roomLine2.Room_code__c='F112T';
        roomLine.Booking_FK__c = book2.Id;
        roomLine2.Booking_FK__c = book1.Id;
        roomLine3.Quantity__c = 3;
        update bookingRoomLines;
        roomLine2.Booking_FK__c = book2.Id;
        update bookingRoomLines;
        book2.Master_Booking_fk__c = MasterBooking.Id;
        update listBookings;
        delete bookingRoomLines;
        Test.stopTest();
        
    }
    
}