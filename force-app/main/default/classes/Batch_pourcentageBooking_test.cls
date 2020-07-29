@isTest
public class Batch_pourcentageBooking_test {
    @isTest static void testCountryFields() {
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        Opportunity masterBook = new Opportunity(Name = 'masterBookingTest', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
        masterBook.Channel__c = 'Apps';
        insert masterBook;
        List<Hotel__c> lstHotels = TestDataFactory.createHotels(5);
        lstHotels[0].Country__c = 'DE'; 
        lstHotels[1].Country__c = 'FR'; 
        lstHotels[2].Country__c = 'ES'; 
        lstHotels[3].Country__c = 'IT'; 
        lstHotels[4].Country__c = 'CA'; 
        insert lstHotels;
        List<Account> lstGuestAccounts = TestDataFactory.createGuestAccounts(5);
        insert lstGuestAccounts;
        List<Opportunity> lstBookings = TestDataFactory.createBusinessBookings(10, lstGuestAccounts);
        lstBookings[0].Hotel__c = lstHotels[0].Id;
        lstBookings[0].person_account__c = lstGuestAccounts[0].Id;
        lstBookings[0].Master_Booking_FK__c = masterBook.id;
        lstBookings[1].Hotel__c = lstHotels[1].Id;
        lstBookings[1].person_account__c = lstGuestAccounts[1].Id;
        lstBookings[1].Master_Booking_FK__c = masterBook.id;
        lstBookings[2].Hotel__c = lstHotels[2].Id;
        lstBookings[2].person_account__c = lstGuestAccounts[2].Id;
        lstBookings[2].Master_Booking_FK__c = masterBook.id;
        lstBookings[3].Hotel__c = lstHotels[3].Id;
        lstBookings[3].person_account__c = lstGuestAccounts[3].Id;
        lstBookings[3].Master_Booking_FK__c = masterBook.id;
        lstBookings[4].Hotel__c = lstHotels[4].Id;
        lstBookings[4].person_account__c = lstGuestAccounts[4].Id;
        lstBookings[4].Master_Booking_FK__c = masterBook.id;
        lstBookings[5].Hotel__c = lstHotels[0].Id;
        lstBookings[5].person_account__c = lstGuestAccounts[0].Id;
        lstBookings[5].Master_Booking_FK__c = masterBook.id;
        lstBookings[6].Hotel__c = lstHotels[1].Id;
        lstBookings[6].person_account__c = lstGuestAccounts[1].Id;
        lstBookings[6].Master_Booking_FK__c = masterBook.id;
        lstBookings[7].Hotel__c = lstHotels[2].Id;
        lstBookings[7].person_account__c = lstGuestAccounts[2].Id;
        lstBookings[7].Master_Booking_FK__c = masterBook.id;
        lstBookings[8].Hotel__c = lstHotels[3].Id;
        lstBookings[8].person_account__c = lstGuestAccounts[3].Id;
        lstBookings[8].Master_Booking_FK__c = masterBook.id;
        lstBookings[9].Hotel__c = lstHotels[4].Id;
        lstBookings[9].person_account__c = lstGuestAccounts[4].Id;
        lstBookings[9].Master_Booking_FK__c = masterBook.id;
        Test.startTest();
        insert lstBookings;

       database.executeBatch(new Batch_pourcentageBooking());
        Test.stopTest();
    }
}