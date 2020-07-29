trigger AfterDeleteHotelRoomOption on Hotel_Room_Option__c (after delete) 
{
    AP01_Hotel_Room_Option.updateBookingRoomLine(null,trigger.Old,null);
}