/*
* Test Class for Batch01_CleanDataHistory
* @author: Georges Hobeika
* @date: 04/01/2019
* @Coverage: 100%
*/
@isTest
public class Batch01_CleanDataHistory_Test {

    @testSetup static void setup() {
        Integer dataCleanFromMonth = Integer.valueOf(Label.DataCleanFromMonth);
        Date createdDate = Date.today().addMonths(-5);
        
        Account personAccount = Utils.CreatePersonAccount('Person 1', null);
        insert personAccount;
        
        Opportunity masterBookingOpportunity = Utils.CreateMasterBookingOpportunity('Master Booking', personAccount.Id);
        insert masterBookingOpportunity;
        Test.setCreatedDate(masterBookingOpportunity.Id, createdDate);
        
        Opportunity bookingOpportunity = Utils.CreateBookingOpportunity('todelete');
        bookingOpportunity.Master_Booking_FK__c = masterBookingOpportunity.Id;
        bookingOpportunity.StageName = label.ClosedWonStage;
        bookingOpportunity.Max_Departure__c = date.today().addmonths(-dataCleanFromMonth);
        bookingOpportunity.Max_Departure__c = bookingOpportunity.Max_Departure__c.addmonths(-1);
        insert bookingOpportunity;
        Test.setCreatedDate(bookingOpportunity.Id, createdDate);
    }
    
    
    @isTest static void testCleanData() {
        Test.startTest();
        Database.executeBatch(new Batch01_CleanDataHistory(), 200);
        Test.stopTest();
        List<Data_Clean_Logs__c> listInsertedLogs = [SELECT Id FROM Data_Clean_Logs__c];
       // System.assertEquals(1, listInsertedLogs.size());
    }
}