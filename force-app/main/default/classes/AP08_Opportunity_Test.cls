@isTest
public class AP08_Opportunity_Test {
    private static testMethod void fillRespectedBookingLookup(){
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
    }
}