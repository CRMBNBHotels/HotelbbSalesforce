/*
* Scheduler for CleanDataHistory batch. Job to run each sunday at 10:00 PM
* String CRON_EXP = '0 0 22 ? * SUN *';
  String description = 'Clean Booking Data';
  System.schedule(description, CRON_EXP , new Schedule_Batch01_CleanDataHistory());
* @author: Georges Hobeika
* @date: 04/01/2019
* @Test:  
*/

global without sharing class Schedule_Batch01_CleanDataHistory implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
       String jobId = Database.executeBatch(new Batch01_CleanDataHistory(), 200);
    }
    
}