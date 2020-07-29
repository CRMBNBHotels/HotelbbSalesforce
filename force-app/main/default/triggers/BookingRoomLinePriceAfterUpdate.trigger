trigger BookingRoomLinePriceAfterUpdate on Booking_Room_Line_Price__c (after update) {
    AP01_BookingRoomLinePrice.DeleteBookingRoomLinePrice(trigger.new);
}