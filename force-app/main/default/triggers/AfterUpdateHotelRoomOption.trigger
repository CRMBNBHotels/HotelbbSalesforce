trigger AfterUpdateHotelRoomOption on Hotel_Room_Option__c (after update) 
{
    AP01_Hotel_Room_Option.updateBookingRoomLine(trigger.New,null,trigger.oldMap);
}