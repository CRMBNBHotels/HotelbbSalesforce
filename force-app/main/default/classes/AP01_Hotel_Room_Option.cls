/*
* Update Booking Room Line that are related to the updated or deleted Hotel_Room_Option
* @author: Jenny Jawhar
* @date: 05/01/2018
* @Test: AP01_Hotel_Room_Option_Test
*/
public without sharing class AP01_Hotel_Room_Option 
{
    /*Commented by TMA-EIL CG CRMSS-448 23/01/2020 Start
    public static void updateBookingRoomLine(list<Hotel_Room_Option__c> triggerNew, list<Hotel_Room_Option__c> triggerOld,map<Id,Hotel_Room_Option__c> oldMap)
    {
        list<string> listRoomCode = new list<string>();
        if(triggerNew != null)
        {
            for(Hotel_Room_Option__c hotelRoomOption: triggerNew)
            {
                Hotel_Room_Option__c oldHotelRoomOption=oldMap==null ? hotelRoomOption : oldMap.get(hotelRoomOption.Id);
                if(oldMap == null || hotelRoomOption.Room_code__c != oldHotelRoomOption.Room_Code__c || hotelRoomOption.Type_code__c != oldHotelRoomOption.Type_code__c
                   || hotelRoomOption.Room_Code_Label__c != oldHotelRoomOption.Room_Code_Label__c || hotelRoomOption.Room_Type__c != oldHotelRoomOption.Room_Type__c
                   || hotelRoomOption.Room_Type_Label__c != oldHotelRoomOption.Room_Type_Label__c)
                {
                    if(!string.IsBlank(hotelRoomOption.Room_Code__c))
                    {
                        listRoomCode.add(hotelRoomOption.Room_Code__c); 
                    }
                    if(!string.IsBlank(oldHotelRoomOption.Room_Code__c))
                    {
                        listRoomCode.add(oldHotelRoomOption.Room_Code__c);
                    }
                }
            }
        }
        else
        {
            for(Hotel_Room_Option__c hotelRoomOption: triggerOld)
            {
                if(!string.IsBlank(hotelRoomOption.Room_Code__c))
                {
                    listRoomCode.add(hotelRoomOption.Room_Code__c); 
                }
            }
        }
        if(listRoomCode.size() > 0)
        {
            list<Booking_Room_Line__c> listBookingRoomLine = [Select Id, Booking_FK__c
                                                              From Booking_Room_Line__c
                                                              Where Room_code__c IN: listRoomCode];
            set<Id> setBookingId = new set<Id>();
            list<Booking_Room_Line__c> listBookingRoomLineToUpdate = new list<Booking_Room_Line__c>();
            for(Booking_Room_Line__c bookingRoomLine: listBookingRoomLine)
            {
                if(!setBookingId.Contains(bookingRoomLine.Booking_FK__c))
                {
                    setBookingId.add(bookingRoomLine.Booking_FK__c);
                    listBookingRoomLineToUpdate.add(bookingRoomLine);
                }
            }
            update listBookingRoomLineToUpdate;
        }
    }
    Commented by TMA-EIL CG CRMSS-448 23/01/2020 Start */
}