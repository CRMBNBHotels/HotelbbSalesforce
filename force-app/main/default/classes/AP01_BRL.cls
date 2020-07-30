/*
* Description: Delete all existing Booking Room Line on the booking. 
* BBUS cannot manage BRL Ids from the PMS thus all BRL should be deleted and re-inserted.
* Note that all BRL should be included in one transaction.
* @author: JK
* @date: 20/07/2020
* @Test: AP01_BRL_Test
*/
public class AP01_BRL {
    public static void DeleteExistingBRL(list<Booking_Room_Line_V2__c> listBRL){
        
        //Get Booking id from BRL
        Set<String> setBookingId = new Set<String>();
        
        for(Booking_Room_Line_V2__c BRL : listBRL){
            if(String.isNotEmpty(BRL.Booking__c) && !setBookingId.contains(BRL.Booking__c)){
                setBookingId.add(BRL.Booking__c);
            }
        }
        
        //Get all booking room line having those bookings as parents
        if(setBookingId != null && setBookingId.size() > 0){
            List<Booking_Room_Line_V2__c> listBRLToDelete = [SELECT id 
                                                             FROM Booking_Room_Line_V2__c 
                                                             WHERE Booking__c in :setBookingId];
            
            //Delete BRL
            if(listBRLToDelete != null && listBRLToDelete.size() > 0){
                delete listBRLToDelete;
            }
        }
    }
}