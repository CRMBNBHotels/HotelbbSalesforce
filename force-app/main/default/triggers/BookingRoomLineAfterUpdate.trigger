trigger BookingRoomLineAfterUpdate on Booking_Room_Line__c (after update) {
	AP01_BookingRoomLine.DeleteBookingRoomLine(trigger.new);
    // if(PAD.canTrigger('AP02_BookingRoomLine')){
     //   AP02_BookingRoomLine.updateBookingBreakfast(Trigger.new , trigger.oldMap,  true , FALSE);
  //  }
}