/*
* Description: test class for LCC13_BookingHeader
* @author: TMA-EI CG
* @date: 18/06/2020
* @Lightning Components: LC13_BookingHeader
*/

@isTest
public class LCC13_BookingHeader_Test {
    
    @isTest
    public static void GetBookingInfoTest(){
        
        Account PersonAccount = Utils.CreatePersonAccount('Person', null);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        PersonAccount.Externalid__c = '123';
        insert PersonAccount;
        Account perAcc = [select id,personcontactid from account where id = :personaccount.id];
        
        Buket_Of_Booking__c BOB = new Buket_Of_Booking__c();
        BOB.externalID__c = '123';
        BOB.Name = 'Test Bucket';
        BOB.Personal_Account__c = perAcc.personcontactid;
        insert BOB;
        
        List<Booking__c> listBook = new List<Booking__c>();
        
        Booking__c book = new Booking__c();
        book.externalid__c = '123';
        book.name='test book';
        book.Bucket_of_booking__c = BOB.id;
        book.stage__c ='cancelled';
        book.arrival_date__c = Date.newInstance(2020, 06, 17);
        book.departure_date__c = Date.newInstance(2020, 06, 30);
        book.Invoiced_amount_TTC__c = 100;
        book.Modifiable_Reservation_Date__c = true;
        book.Recognition_number__c = '1235';
        
        listBook.add(book);
        
        Booking__c book2 = new Booking__c();
        book2.externalid__c = '1234';
        book2.name='test book2';
        book2.Bucket_of_booking__c = BOB.id;
        listBook.add(book2);
        
        insert listBook;
        
        LCC13_BookingHeader.GetBookingInfo(book.id);
        LCC13_BookingHeader.GetBookingInfo(null);
    }
    
}