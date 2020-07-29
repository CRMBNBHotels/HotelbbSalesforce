/** 
* Test class for the HotelHandler Apex Class
* @author JKA 
* @version 0.1
* @date 24/01/2020 
*/
@isTest
public class HotelHandler_Test 
{
    @isTest static void testHotelHandler() {
        List<Hotel__c> lstHotels = TestDataFactory.createHotels(1);
        insert lstHotels;
        List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(1);
        insert lstGuestAccounts;
        List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(1, lstGuestAccounts);
        lstBookings[0].Hotel__c = lstHotels[0].Id;
        Test.startTest();
        insert lstBookings;
        Account guestAccount = [SELECT Id,Booking_France__c
                                FROM Account
                                WHERE Id = :lstGuestAccounts[0].Id
                               ];
        
        Hotel__c hotel = [SELECT Id, Country__c
                          FROM Hotel__c
                          WHERE Id =:lstHotels[0].Id
                         ];
        hotel.Country__c = 'DE';
        update hotel;
        
        delete hotel;
        undelete hotel;
        Test.stopTest();
    }
}