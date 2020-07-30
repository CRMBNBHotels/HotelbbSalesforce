/** 
* Test class for the BRLHandler Apex Class
* @author JKA
* @version 0.1
* @date 20/07/2020 
*/
@isTest
public class BRLHandler_Test {
    
    @isTest
    static void testBRLHandler(){	
        
        //Insert PA        
        Account PersonAccount = Utils.CreatePersonAccount('Person1',null);
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
        BRL.Quantity__c = 4;
        update BRL;
        delete BRL;
        undelete BRL;
        
        BRLHandler handler = new BRLHandler(true,0);
        Boolean Execute = handler.IsExecuteAnonymousContext;
        Boolean VF = handler.IsVisualforcePageContext;
        Boolean trig = handler.IsTriggerContext;
        Boolean WS = handler.IsWebServiceContext;
        
    }
    
}