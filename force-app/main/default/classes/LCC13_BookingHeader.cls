/*
* Description: Controller class for booking header component => 
* @author: TMA-EI CG
* @date: 18/06/2020
* @Test class: LCC13_BookingHeader_Test
* @Coverage: 100 %
* @Lightning Components: LC13_BookingHeader
*/

public class LCC13_BookingHeader {

     @AuraEnabled
    public static Booking__c GetBookingInfo(String bookingId) {
        
        if(bookingId != null){
            
            Booking__c book = [Select Id,Stage__c, Arrival_date__c, Departure_date__c, Hotel__c,Hotel__r.Commercial_Hotel_Name__c , Invoiced_amount_TTC__c, CAD_Status__c, PMS_booking_ID__c, ID_CRS_VB__c,Hotel_Name_IDUNIX__c, Modifiable_Reservation_Date__c, Cancellable_Booking__c
                               from booking__c 
                               where id=:bookingId];
            
            return book;
        }
        
        return null;
    }

}