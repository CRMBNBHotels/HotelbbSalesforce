/*

* @!#  Ticket - 49 REDMINE 1537  Classe to delete Booking Room Line Price if the field todelete__c is true

* @author: TMA-EI JK

* @date: 31/05/2018

* @test: AP01_BookingRoomLinePrice_Test

*/
public class AP01_BookingRoomLinePrice {
    public static void DeleteBookingRoomLinePrice(List<Booking_Room_Line_Price__c> listBRLP){
        List<Booking_Room_Line_Price__c> listBRLPToDelete = new List<Booking_Room_Line_Price__c>();
        for(Booking_Room_Line_Price__c objtBRLP : listBRLP){
            if(objtBRLP.ToDelete__c){
                Booking_Room_Line_Price__c objBRLPTempl = new Booking_Room_Line_Price__c();
                objBRLPTempl.id = objtBRLP.id;
                listBRLPToDelete.add(objBRLPTempl);
            }
        }
        if(listBRLPToDelete != null && listBRLPToDelete.size() > 0){
            delete listBRLPToDelete;
        }
    }
}