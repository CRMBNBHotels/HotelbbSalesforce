@isTest private class WS01_BookingInfo_Test {

   @isTest static void testBookingRoomLines() {
        WS01_BookingInfo.BookingRoomLines bookingRoomLines = TestDataFactory.createWSBookingInfoBookingRoomLines(100);
        // Exception : Missing External Id
        bookingRoomLines.BookingRoomLine.get(0).ExternalId = null;
        // Exception : Duplicate external Id
        bookingRoomLines.BookingRoomLine.get(2).ExternalId = bookingRoomLines.BookingRoomLine.get(1).ExternalId;
        // Exception : booking external Id not found
        bookingRoomLines.BookingRoomLine.get(3).Booking = 'Booking';
        Test.startTest();        
        List<WS01_BookingInfo.UpsertResponse> lstResponses = WS01_BookingInfo.doUpsertBookingRoomLines(BookingRoomLines);
        System.assertEquals('ExternalId__c not specified', lstResponses.get(0).Error);
        System.assertEquals('Duplicate external id specified: ' + bookingRoomLines.BookingRoomLine.get(2).ExternalId , lstResponses.get(2).Error);
        System.assertEquals(false, lstResponses.get(3).Success);
        Test.stopTest();
    }
    
    @isTest static void testGuestAccounts() {
        WS01_BookingInfo.PersonAccounts personAccounts = TestDataFactory.createWSPersonAccounts(100);
        // Exception : Missing External Id
        personAccounts.PersonAccount.get(0).ExternalId = null;
        // Exception : Duplicate external Id
        personAccounts.PersonAccount.get(2).ExternalId = personAccounts.PersonAccount.get(1).ExternalId;
        Test.startTest();
        List<WS01_BookingInfo.UpsertResponse> lstResponses = WS01_BookingInfo.doUpsertPersonAccounts(personAccounts);
        System.assertEquals('ExternalId__c not specified', lstResponses.get(0).Error);
        System.assertEquals('Duplicate external id specified: ' + personAccounts.PersonAccount.get(2).ExternalId, lstResponses.get(2).Error);
        Test.stopTest();
    }
    
    @isTest static void testMasterBookings() {
        WS01_BookingInfo.MasterBookings masterBookings = TestDataFactory.createWSBookingInfoMasterBookings(100);
        // Exception : Missing External Id
        masterBookings.MasterBooking.get(0).ExternalId = null;
        // Exception : Duplicate external Id 
        masterBookings.MasterBooking.get(2).ExternalId = masterBookings.MasterBooking.get(1).ExternalId;
        Test.startTest();
        List<WS01_BookingInfo.UpsertResponse> lstResponses = WS01_BookingInfo.doUpsertMasterBookings(masterBookings); 
         system.debug(' lstResponses.get(2).Error '+ lstResponses.get(2).Error);
        system.debug('Duplicate external id specified: ' + masterBookings.MasterBooking.get(2).ExternalId);
        System.assertEquals('ExternalId__c not specified', lstResponses.get(0).Error);
        System.assertEquals('Duplicate external id specified: ' + masterBookings.MasterBooking.get(2).ExternalId, lstResponses.get(2).Error);
        Test.stopTest();
    }
    
    @isTest static void testBookings() {
        WS01_BookingInfo.Bookings bookings = TestDataFactory.createWSBookingInfoBookings(100);
        // Exception : Missing External Id
        bookings.Booking.get(0).ExternalId = null;
        // Exeption : Duplicate External Id
        bookings.Booking.get(2).ExternalId = bookings.Booking.get(1).ExternalId;
        Test.startTest();
        List<WS01_BookingInfo.UpsertResponse> lstResponses = WS01_BookingInfo.doUpsertBookings(bookings);
        System.assertEquals('ExternalId__c not specified', lstResponses.get(0).Error);
        System.assertEquals('Duplicate external id specified: ' + bookings.Booking.get(2).ExternalId, lstResponses.get(2).Error);
        Test.stopTest();
    }
    
    @isTest static void testBookingInfos() {
        WS01_BookingInfo.BookingInfos bookingInfos = TestDataFactory.createWSBookingInfos(5, 5);
        // Exception : Missing External Id for Master Booking
        bookingInfos.BookingInfo.get(0).MasterBookingWrapper.MasterBooking.ExternalId = null;
        // Exception : Missing External Id for Booking
        bookingInfos.BookingInfo.get(1).MasterBookingWrapper.BookingWrapper.get(0).Booking.ExternalId = null;
        // Exception : Missing External Id for Booking Room Lines
        bookingInfos.BookingInfo.get(2).MasterBookingWrapper.BookingWrapper.get(0).BookingRoomLines.get(0).ExternalId = null;
        // Exception : Bad request. Missing Booking information
        bookingInfos.BookingInfo.get(3).MasterBookingWrapper.BookingWrapper.get(0).Booking = null;
        Test.startTest();
        List<WS01_BookingInfo.BookingInfoUpsertResponse> lstResponses = WS01_BookingInfo.doUpsertBookingInfos(bookingInfos);
        
        Test.stopTest();
    }
    
}