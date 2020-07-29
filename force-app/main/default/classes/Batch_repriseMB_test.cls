@isTest
public class Batch_repriseMB_test {
    @isTest
    static void Batch_repriseMB_test(){
        
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);      
        insert PartnerAccount;
        Account PersonAccount = Utils.CreatePersonAccount('Person', PartnerAccount.Id);                      
        insert PersonAccount;
        
        Opportunity masterBooking = Utils.CreateMasterBookingOpportunity('MasterBooking', PersonAccount.Id);
        masterBooking.Person_Account__c = PersonAccount.Id;
        masterBooking.StageName =  label.ClosedWonStage;
        masterBooking.CloseDate = date.today();
        
        Opportunity booking = Utils.CreateBookingOpportunity('Booking');
        booking.Person_Account__c = PersonAccount.Id;
        booking.StageName =  label.ClosedWonStage;
        booking.CloseDate = date.today();
        
        insert (new List<Opportunity>{masterBooking, booking});
        booking.Booking_Person_account__c = null;
        masterBooking.Masterbooking_Person_account__c = null;
        update (new List<Opportunity>{masterBooking, booking});
        database.executeBatch(new Batch_repriseMB());        
    }
}