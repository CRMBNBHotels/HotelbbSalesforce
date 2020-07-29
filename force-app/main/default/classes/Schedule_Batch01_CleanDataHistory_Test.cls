/*
* Test Class for Schedule_Batch01_CleanDataHistory
* @author: Georges Hobeika
* @date: 04/01/2019
* @Coverage: 100%
*/
@isTest
public class Schedule_Batch01_CleanDataHistory_Test {
    
    @istest static void testSchedule() {
        String CRON_EXP = '0 0 22 ? * SUN *';
        String description = 'Clean Booking Data';
        System.schedule(description, CRON_EXP , new Schedule_Batch01_CleanDataHistory());
    }
    
}