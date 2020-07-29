/*
* Test Class for AP07_Opportunity
* @author: Georges Hobeika
* @date: 09/01/2019
* @Coverage: 100%
*/
@isTest
public class AP07_Opportunity_Test { 
    
    @testSetup static void setup() {
        
        //create guestAccount
        List<Account> listGuestAccounts = new List<Account>();
        Account guestAccount1 = Utils.CreatePersonAccount('guest account 1', null);
        listGuestAccounts.add(guestAccount1);
        
        Account guestAccount2 = Utils.CreatePersonAccount('guest account 2', null);
        listGuestAccounts.add(guestAccount2);
        Account guestAccount3 = Utils.CreatePersonAccount('guest account 3', null);
        listGuestAccounts.add(guestAccount3);
        Account guestAccount4 = Utils.CreatePersonAccount('guest account 4', null);
        listGuestAccounts.add(guestAccount4);
        Account guestAccount5 = Utils.CreatePersonAccount('guest account 5', null);
        listGuestAccounts.add(guestAccount5);
        insert listGuestAccounts;
        
        //create list of bookings
        List<Opportunity> listBookingsToInsert = new List<Opportunity>();
        Opportunity booking;
        for(Integer i = 1 ; i <= 50 ; i++) {
            booking = Utils.CreateBookingOpportunity('Booking_' + i);
            if(i <= 25) {
                booking.Trip_Context__c = Label.BusinessCustomerType;
            } else {
                booking.Trip_Context__c = Label.LeisureCustomerType;
            }
            booking.Externalid__c = 'Booking_' + i;
            booking.StageName = Label.StageBooked;
            booking.CloseDate = Date.today().addYears(1);
            booking.Guest_Account_1__c = guestAccount1.Id;
            booking.Guest_Account_2__c = guestAccount2.Id;
            booking.Guest_Account_3__c = guestAccount3.Id;
            booking.Guest_Account_4__c = guestAccount4.Id;
            booking.Guest_Account_5__c = guestAccount5.Id;
            listBookingsToInsert.add(booking);
        }
        if(listBookingsToInsert.size() > 0) {
            insert listBookingsToInsert;
        }
        
        
    }
    
    @isTest static void testInsertTripContext() {
        Test.startTest();
        List<Account> listGuestAccounts = [SELECT Id, Customer_Type__pc 
                                           FROM Account
                                           WHERE Name = 'guest account 1'
                                          ];
        if(listGuestAccounts.size() == 1) {
            System.assertEquals(Label.MixedCustomerType, listGuestAccounts[0].Customer_Type__pc);
        }
        Test.stopTest();
    } 
    
    @isTest static void testUpdateTripContext() {
        List<Opportunity> listBookingsToUpdate = new List<Opportunity>();
        Test.startTest(); 
        for(Opportunity booking : [SELECT Id, Trip_Context__c 
                                   FROM Opportunity 
                                  ]) {
                                      if(booking.Trip_Context__c.equals(Label.BusinessCustomerType)) {
                                          booking.Trip_Context__c = Label.LeisureCustomerType;
										  listBookingsToUpdate.add(booking);                                         
                                      }
                                  }
        update listBookingsToUpdate;
        List<Account> listGuestAccounts = [SELECT Id, Customer_Type__pc 
                                           FROM Account
                                           WHERE Name = 'guest account 1'
                                          ];
        if(listGuestAccounts.size() == 1) {
            System.assertEquals(Label.LeisureCustomerType, listGuestAccounts[0].Customer_Type__pc);
        }
        Test.stopTest();
    }
    
    @isTest static void testUpdateGuestAccounts() {
        List<Opportunity> listBookingsToUpdate = new List<Opportunity>();
        Test.startTest(); 
        for(Opportunity booking : [SELECT Id, Trip_Context__c 
                                   FROM Opportunity
                                  ]) {
                                      booking.Guest_Account_1__c = null;
                                      booking.Guest_Account_2__c = null;
                                      booking.Guest_Account_3__c = null;
                                      booking.Guest_Account_4__c = null;
                                      booking.Guest_Account_5__c = null;
                                      listBookingsToUpdate.add(booking);
                                  }
        update listBookingsToUpdate;
        List<Account> listGuestAccounts = [SELECT Id, Customer_Type__pc 
                                           FROM Account
                                           WHERE Name = 'guest account 2'
                                          ];
        if(listGuestAccounts.size() == 1) {
            System.assertEquals(null, listGuestAccounts[0].Customer_Type__pc);
        }
        Test.stopTest();
    }
    
    @isTest static void testDeleteTripContext() {
        Test.startTest();
        delete [SELECT Id
                FROM Opportunity];
        List<Account> listGuestAccounts = [SELECT Id, Customer_Type__pc 
                                           FROM Account
                                           WHERE Name = 'guest account 1'
                                          ];
        if(listGuestAccounts.size() == 1) {
            System.assertEquals(null, listGuestAccounts[0].Customer_Type__pc);
        }
        Test.stopTest();
    }
    
    @isTest static void testMoveGuestAccountOnSameBooking() {
        List<Account> listGuestAccounts = [SELECT Id,Customer_type__pc, Data_History__c
                                           FROM Account
                                           WHERE Name = 'guest account 1' 
                                           LIMIT 1
                                          ];
        if(listGuestAccounts.size() == 1) {
            Account guestAccount = listGuestAccounts[0];
            List<Opportunity> listBookings = [SELECT Id, Trip_Context__c
                                              FROM Opportunity
                                              WHERE Guest_Account_1__c =: guestAccount.Id
                                             ];
            for(Opportunity booking : listBookings) {
                booking.Guest_Account_1__c = null;
                booking.Guest_Account_2__c = guestAccount.Id;
            }
            Test.startTest();
            update listBookings;
            
            listGuestAccounts = [SELECT Id,Customer_type__pc, Data_History__c
                                               FROM Account
                                               WHERE Name = 'guest account 2' 
                                               LIMIT 1
                                              ];
            Account guestAccount2 = listGuestAccounts[0];
            System.assertEquals(null, guestAccount2.Customer_type__pc);
            Test.stopTest();
        }
    }

}