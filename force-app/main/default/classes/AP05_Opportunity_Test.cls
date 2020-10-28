/**
* 
* @version 1.00 04/12/2017
* @author Jenny Jawhar
* @CodeCoverage 95%
*/
@isTest
private class AP05_Opportunity_Test {    
    
    @isTest static void testTripContext() {
        List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(1);
        insert lstGuestAccounts;
        List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(1, lstGuestAccounts);
        lstBookings[0].person_account__c = lstBookings[0].Guest_Account_1__c;
        Test.startTest();
        insert lstBookings;
        Account guestAccount = [SELECT Id,Customer_type__pc
                                FROM Account
                                WHERE Id = :lstGuestAccounts[0].Id
                               ];
        //System.assertEquals(Label.BusinessCustomerType, guestAccount.Customer_type__pc);
        
        Opportunity booking = [SELECT Id, StageName, Trip_Context__c
                               FROM Opportunity
                               WHERE Id = :lstBookings[0].Id
                              ];
		booking.Trip_Context__c = Label.LeisureCustomerType;
        update booking;
        guestAccount = [SELECT Id,Customer_type__pc
                        FROM Account
                        WHERE Id = :lstGuestAccounts[0].Id
                       ];
        //System.assertEquals(Label.LeisureCustomerType, guestAccount.Customer_type__pc);
        
        booking.StageName = 'Error';
        update booking;
        guestAccount = [SELECT Id,Customer_type__pc
                        FROM Account
                        WHERE Id = :lstGuestAccounts[0].Id
                       ];
        //System.assertEquals(null, guestAccount.Customer_type__pc);
        Test.stopTest();
    }
    
    @isTest static void testCountryFields() {
        List<Hotel__c> lstHotels = TestDataFactory.createHotels(1);
        insert lstHotels;
        List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(1);
        insert lstGuestAccounts;
        List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(1, lstGuestAccounts);
        lstBookings[0].Hotel__c = lstHotels[0].Id;
        lstBookings[0].person_account__c = lstGuestAccounts[0].Id;
        Test.startTest();
        insert lstBookings;
        Account guestAccount = [SELECT Id,Booking_France__c
                        FROM Account
                        WHERE Id = :lstGuestAccounts[0].Id
                       ];
       // System.assertEquals(100, guestAccount.Booking_France__c);
        
        Hotel__c hotel = [SELECT Id, Country__c
                          FROM Hotel__c
                          WHERE Id =:lstHotels[0].Id
                         ];
        hotel.Country__c = 'DE';
        update hotel;
        hotel.Country__c = 'IT';
        update hotel;
        hotel.Country__c = 'ES';
        update hotel;
        hotel.Country__c = 'PL';
        update hotel;
        hotel.Country__c = 'AU';
        update hotel;
        hotel.Country__c = 'AT';
        update hotel;
        delete hotel;
        guestAccount = [SELECT Id,Booking_France__c, Booking_Germany__c,Booking_Italy__c,Booking_Others__c,Booking_Poland__c,Booking_Spain__c
                        FROM Account
                        WHERE Id = :lstGuestAccounts[0].Id
                       ];
       // System.assertEquals(0, guestAccount.Booking_France__c);
       // System.assertEquals(0, guestAccount.Booking_Germany__c);
       // System.assertEquals(0, guestAccount.Booking_Italy__c);
       // System.assertEquals(0, guestAccount.Booking_Poland__c);
       // System.assertEquals(0, guestAccount.Booking_Spain__c);
       // System.assertEquals(100, guestAccount.Booking_Others__c);
        Test.stopTest();
    }
    
    @isTest static void testTotalNights() {
        
         List<Account> lstCompanyAccounts = TestDataFactory.createCompanyAccounts(1);
        insert lstCompanyAccounts;
        set<id> setcompoaniesId = new set<id>();
        for(Account acc : lstCompanyAccounts){
            setcompoaniesId.add(acc.id);
        }
        List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(1);
        lstGuestAccounts[0].Current_Compagny__pc = lstCompanyAccounts[0].Id;
        insert lstGuestAccounts;
        
        List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(1, lstGuestAccounts);
         lstBookings[0].person_account__c = lstBookings[0].Guest_Account_1__c;
        ap04_account.updateCompaniesFields(setcompoaniesId);
        Test.startTest();
        insert lstBookings;
        Account guestAccount = [SELECT Id, Total_nights__pc
                                FROM Account
                                WHERE Id = :lstGuestAccounts[0].Id
                               ];
        //System.assertEquals(5, guestAccount.Total_nights__pc);
        
        Opportunity booking = [SELECT Id, Min_Arrival__c
                               FROM Opportunity
                               WHERE Id = :lstBookings[0].Id
                              ];
        booking.Min_Arrival__c = Date.today().addYears(-1);
        update booking;
        guestAccount = [SELECT Id, Total_nights__pc
                        FROM Account
                        WHERE Id = :lstGuestAccounts[0].Id
                       ];
        //System.assertEquals(0, guestAccount.Total_nights__pc);
        
        Test.stopTest();
    }
    
    @isTest static void testGuestFields() {
        List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(1);
        insert lstGuestAccounts;
        List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(1, lstGuestAccounts);
        lstBookings[0].person_account__c = lstBookings[0].Guest_Account_1__c;
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
        //System.assertEquals(null, guestAccount.Customer_type__pc);
        delete booking;
        undelete booking;
        Test.stopTest();
    }
}