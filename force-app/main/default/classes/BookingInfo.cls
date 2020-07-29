global without sharing class BookingInfo {
   
    webservice MasterBookingWrapper MasterBookingWrapper;
    
    global class MasterBookingWrapper {
        webservice MasterBooking MasterBooking;
        webservice List<BookingWrapper> BookingWrapper;
    }
    
    global class BookingWrapper {
        webservice Booking Booking;
        webservice PersonAccount GuestAccount1;
        webservice PersonAccount GuestAccount2;
        webservice PersonAccount GuestAccount3;
        webservice PersonAccount GuestAccount4;
        webservice PersonAccount GuestAccount5;
        webservice List<BookingRoomLine> BookingRoomLines;
    }    
}