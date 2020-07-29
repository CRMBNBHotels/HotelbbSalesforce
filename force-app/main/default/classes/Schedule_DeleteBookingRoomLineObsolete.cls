/*--------------------------------------------------------------------------------------------------------------------------
Author: Bachir Asmar
Company: EI-Technologies
Description:  This is the schedule that deletes the Obsolete Booking Room Lines, It runs everyday at 00:01 midnight
Related Batch: Batch_DeleteBookingRoomLineObsolete 

!!!!!!!!!!!!!!!!! In order to run this batch, we should execute the following command: !!!!!!!!!!!!!!!!!!!!!
Schedule_DeleteBookingRoomLineObsolete reminder = new Schedule_DeleteBookingRoomLineObsolete();
String jobID = System.schedule('Schedule_DeleteBookingRoomLineObsolete', Schedule_DeleteBookingRoomLineObsolete.CRON_EXP, reminder);
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

History
-- Date         Name  Version  Remarks 
-- -----------  ----  -------  -----------------------------
-- 11/04/2019   BAS   1.0      Initial version 
---------------------------------------------------------------------------------------------------------------------------
*/
global class Schedule_DeleteBookingRoomLineObsolete implements schedulable
{  
    public String CRON_EXP = '0 1 0 1/1 * ? *'; 
    global void execute(SchedulableContext sc)
    {
        Batch_DeleteBookingRoomLineObsolete batch = new Batch_DeleteBookingRoomLineObsolete();
        ID batchprocessid = Database.executeBatch(batch);
    }   
}