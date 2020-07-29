trigger AfterInsertHotelRoomOption on Hotel_Room_Option__c (after insert) 
{
    AP01_Hotel_Room_Option.updateBookingRoomLine(trigger.New,null,null);
}