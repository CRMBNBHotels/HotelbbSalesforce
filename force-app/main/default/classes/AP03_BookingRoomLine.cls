/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/04/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 08-Apr-2021  Amira         1.0     CRMSS-1126:  BRL dupliquées dans SF
*
* @TestClass : AP03_BookingRoomLine_Test
*********************************************************************************************************************************************************************/
public class AP03_BookingRoomLine {
	public static void DeleteBookingRoomLines(List<Id> listBookingId){
        List<Booking_Room_Line_V2__c> BRLList=[SELECT Id,Name,EXTERNALID__c,Quantity__c,Price__c,Booking__c 
                       						   FROM Booking_Room_Line_V2__c 
                                               WHERE Createddate != today AND Booking__c IN :listBookingId];
        system.debug('BRLList'+BRLList);
 
        if(BRLList != null && BRLList.size() > 0){
            delete BRLList;
        }
        
    }
}