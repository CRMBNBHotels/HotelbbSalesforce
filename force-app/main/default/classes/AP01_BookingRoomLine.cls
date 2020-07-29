/*

* @!#  Ticket - 49 REDMINE 1537  Classe to delete Booking Room Line if the field todelete__c is true

* @author: TMA-EI JK

* @date: 31/05/2018

* @test: AP01_BookingRoomLinePrice_Test

*/
public class AP01_BookingRoomLine {
    public static void DeleteBookingRoomLine(List<Booking_Room_Line__c> listBRL){
        List<Booking_Room_Line__c> listBRLToDelete = new List<Booking_Room_Line__c>();
        for(Booking_Room_Line__c objtBRL : listBRL){
            if(objtBRL.ToDelete__c){
                Booking_Room_Line__c objBRLTempl = new Booking_Room_Line__c();
                objBRLTempl.id = objtBRL.id;
                listBRLToDelete.add(objBRLTempl);
            }
        }
        if(listBRLToDelete != null && listBRLToDelete.size() > 0){
            delete listBRLToDelete;
        }
    }
}