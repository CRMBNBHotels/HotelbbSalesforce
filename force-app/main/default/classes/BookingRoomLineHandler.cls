/* Description: This class is used to filter the booking room lines and call other classes (AP02_BookingRoomLine)
* @author: TMA-EIL JKA
* @date: 13/12/2019
* @Test: BatchReprise_BRLtoBooking_Test
* @Coverage: 100%
*/

public without sharing class BookingRoomLineHandler {
    
    public static Map<String,String> FilterBookingRoomLine(List<Booking_Room_Line__c> listBRL){
        system.debug('### jka in filter');
        Map<String,String> mapBIdErrors = new Map<String,String>();
       
        //set of booking Id filled with the Booking_FK__c of the brl having having a room code and a qty>=1 
        Set<String> SetBookingIDs = new Set<String>();
        // list of brl having a room code, a qty>=1 and not deleted to be send to AP02_BookingRoomLine 
        List<Booking_Room_Line__c> BookingRoomLineToSendAp02 = new  List<Booking_Room_Line__c>();
        
        for(Booking_Room_Line__c brl : listBRL){
           System.debug('### brlbrl');
            SetBookingIDs.add(brl.Booking_FK__c);
           // if the booking room line's code is filled in and its qty is greater than 1 and if the booking room line is not deleted we will add the current BRL the the BookingRoomLineToSendAp02 list
            if(brl.Room_code__c!=null && brl.Quantity__c>=1){// tkt 485 && !brl.IsDeleted){
                     system.debug('### jka before ap02###');
                    BookingRoomLineToSendAp02.add(brl);
            }
        }
        
        
        if(SetBookingIDs!=null && SetBookingIDs.Size()>0){
            system.debug('### jka to senddddd'+SetBookingIDs);
            //The AP02_BookingRoomLine returns the mapBIdErrors filled with failed booking Ids errors
            mapBIdErrors=AP02_BookingRoomLine.bookingRoomLine(BookingRoomLineToSendAp02,SetBookingIDs);
        }
      
        return mapBIdErrors;
    }
}