/*
* Description: Scheduler for Batch_AccountSchedule_Batch_Account_EClubStatus_EClubStatus . Job to run every day at 00:01 AM  
* String CRON_EXP = '0 1 0 1/1 * ? *';
  String description = 'Update EClubStatus';
  System.schedule(description, CRON_EXP, new Schedule_Batch_Account_EClubStatus());

* @author: TMA-EI JKA
* @date: 21/10/2019
* @Test: Schedule_Batch_Account_EClubStatus_Test
* @Coverage: 100%
*/

global without sharing class Schedule_Batch_Account_EClubStatus implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
       String jobId = Database.executeBatch(new Batch_Account_EClubStatus());
    }
}