/*
* Test Class for Batch_DeleteBookingRoomLineObsolete
* @author: Bachir Asmar
* @date: 11/04/2019
* @Coverage:  ??? %
* @Description: By Setting the 
*/
@isTest
public class Batch_DeleteBookingRoomLineObsolete_Test 
{
	
    @isTest
    public static void TestDeleteObsolete() 
    {
        
        Date createdDate = Date.today().addDays(-2);
        
        Account personAccount = Utils.CreatePersonAccount('Person 1', null);
        insert personAccount;
        

        Opportunity bookingOpportunity = Utils.CreateBookingOpportunity('todelete');
        bookingOpportunity.StageName = label.ClosedWonStage;
        bookingOpportunity.createdDate = createdDate;
        insert bookingOpportunity;
        //Test.setCreatedDate(bookingOpportunity.Id, createdDate);


        Booking_Room_Line__c bookingRoomLine = Utils.CreateBookingRoomLine(bookingOpportunity.Id);
        bookingRoomLine.Obsolete__c = True;
        bookingRoomLine.createdDate = createdDate;
        insert bookingRoomLine; 
        //Test.setCreatedDate(bookingRoomLine.Id, createdDate);
        
        Batch_DeleteBookingRoomLineObsolete deleteBRLObsolete = new Batch_DeleteBookingRoomLineObsolete();
        Database.executeBatch(deleteBRLObsolete);
            
    }
}