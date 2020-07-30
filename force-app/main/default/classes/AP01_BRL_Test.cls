/**
* @version 1.00 20/07/2020
* @author JK
* @CodeCoverage 90%
*/
@isTest
public class AP01_BRL_Test {
    static testMethod void DeleteExistingBRL_test(){
        //Creation of PA
        Account PersonAccount = Utils.CreatePersonAccount('Person', null);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        insert PersonAccount;
        
        //Get PersonContactId
        PersonAccount = [SELECT id,personcontactId
                         FROM Account
                         WHERE id = :PersonAccount.id];
        
        //Creation of Bucket of Booking linked to a contact
        Buket_of_booking__c Bucket = Utils.CreateBucket(PersonAccount.personcontactid,'123');
        insert Bucket;
        
        //Creation of Booking
        Booking__c Booking = Utils.CreateBooking(Bucket.id,'123');
        insert Booking;
        
        //Creation of first Booking Room Line 
        Booking_Room_Line_V2__c BRL = Utils.CreateBRL(Booking.id,'123');
        insert BRL;
                
    }
}