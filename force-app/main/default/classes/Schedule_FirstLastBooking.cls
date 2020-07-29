/*
* Description: Scheduler for Batch_FirstLastBooking . Job to every day at 00:00   
* String CRON_EXP = '0 0 0 1/1 * ? *';
  String description = 'Update personaccount's first and last booking dates';
  System.schedule(description, CRON_EXP, new Schedule_FirstLastBooking());

* @author: TMA-EI CG
* @date: 24/12/2019
* @Test: Schedule_FirstLastBooking_Test
* @Coverage: 100 %
*/

global without sharing class Schedule_FirstLastBooking implements Schedulable{

    global void execute(SchedulableContext ctx) {
         
       String jobId = Database.executeBatch(new Batch_FirstLastBooking(null,0), 50);
    }
}