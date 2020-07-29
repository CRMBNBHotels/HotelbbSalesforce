/*
* @!#  Ticket - CRMSS-117 
* @author: Bachir Asmar
* @date: 12/04/2019
* @Schduler: Schedule_DeleteBookingRoomLineObsolete
*/

@isTest
public class Schedule_DeleteBookingRoomLineObs_Test 
{	
	public static testMethod void testschedule() 
    {
        Test.startTest();
        Schedule_DeleteBookingRoomLineObsolete testsche = new Schedule_DeleteBookingRoomLineObsolete();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}