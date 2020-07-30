@isTest
public class LCC12_BucketOfBooking_Test {
    public static testmethod void GetBucketOfBookingInfoTest(){
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
        listBook.add(book);
        
        Booking__c book2 = new Booking__c();
        book2.externalid__c = '1234';
        book2.name='test book2';
        book2.Bucket_of_booking__c = BOB.id;
        listBook.add(book2);
        
        insert listBook;
        
        LCC12_BucketOfBooking.GetBucketOfBookingInfo(book.id);
        LCC12_BucketOfBooking.GetBucketOfBookingInfo(null);
    }
}