/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/04/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 08-Apr-2021  Amira         1.0     CRMSS-1126:  BRL dupliquées dans SF
* -- 18-Jun-2021  Amira         2.0     CRMSS-1191:  BRL dupliquées dans SF
*
* @TestClass : AP03_BookingRoomLine_Test
*********************************************************************************************************************************************************************/
public class AP03_BookingRoomLine {
	public static void DeleteBookingRoomLines(List<Id> listBookingId){      
	String previousName =  '';
	Integer countBRL=0;
	List<Booking_Room_Line_V2__c> brlToDeleteList = New List<Booking_Room_Line_V2__c>();
		for (Booking_Room_Line_V2__c brl: [SELECT Name,Id,EXTERNALID__c, Booking__c 
                                           FROM Booking_Room_Line_V2__c 
                                           WHERE Booking__c IN :listBookingId ORDER BY Booking__c,NAME DESC,EXTERNALID__c DESC]){ 
                                               
			if (brl.Booking__c+brl.Name != previousName){
				countBRL = 0;
			}
				countBRL = countBRL+1;
			if (countBRL > 1){
				brlToDeleteList.add(brl);
			}
				previousName = brl.Booking__c+brl.Name;
		}  
			if (brlToDeleteList != null && brlToDeleteList.size() > 0){
            	delete(brlToDeleteList);
            
        }
    }

}