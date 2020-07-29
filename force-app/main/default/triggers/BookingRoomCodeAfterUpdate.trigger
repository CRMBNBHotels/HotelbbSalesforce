trigger BookingRoomCodeAfterUpdate on Booking_Room_Code__c (after update) {
    AP01_BookingRoomCode.DeleteBookingRoomCode(Trigger.new);
}