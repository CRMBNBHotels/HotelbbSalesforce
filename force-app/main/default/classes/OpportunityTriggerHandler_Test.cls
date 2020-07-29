/** 
* Test class for the OpportunityTriggerHandler Apex Class
* @author  JKA
* @version 0.1
* @date 24/01/2020
*/

@isTest
private class OpportunityTriggerHandler_Test {
    
    public static testMethod void testOppTrH() {
        User testUser = TestDataFactory.createSingleUser(false);
        Insert testUser ;
        System.runAs(testUser) {
            List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(1);
            insert lstGuestAccounts;
            List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(1, lstGuestAccounts);
            insert lstBookings;
            
            Opportunity booking = [SELECT Id, StageName, Trip_Context__c, Guest_Account_1__c
                                   FROM Opportunity
                                   WHERE Id = :lstBookings[0].Id
                                  ];
            booking.Guest_Account_1__c = null;
            Test.startTest();
            update booking;
            Account guestAccount = [SELECT Id,Customer_type__pc
                                    FROM Account
                                    WHERE Id = :lstGuestAccounts[0].Id
                                   ];
            delete booking;
            undelete booking;
            Test.stopTest();
        } 
    }
}