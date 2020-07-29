/*
* Description: Test class for Schedule_Batch_Account_EClubStatus 
* @author: TMA-EI JKA
* @date: 22/10/2019
*/

@isTest
public class Schedule_Batch_Account_EClubStatus_Test {
    
     @istest static void testSchedule() {
        String CRON_EXP = '0 1 0 1/1 * ? *';
        String description = 'Update EClubStatus';
        System.schedule(description, CRON_EXP , new Schedule_Batch_Account_EClubStatus());
    }

}