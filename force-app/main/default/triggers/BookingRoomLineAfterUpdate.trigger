trigger BookingRoomLineAfterUpdate on Booking_Room_Line__c (after update) {
    
	AP01_BookingRoomLine.DeleteBookingRoomLine(trigger.new);
}