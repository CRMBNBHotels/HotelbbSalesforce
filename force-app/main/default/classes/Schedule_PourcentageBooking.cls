/*
* Description: Scheduler for Batch_FirstLastBooking . Job to every day at 00:00   
* String CRON_EXP = '0 0 0 * * ?';
  String description = 'Update Booking Percentage'
  System.schedule(description, CRON_EXP, new Batch_pourcentageBooking());

* @author: TMA-EI JK
* @date: 11/03/2020
* @Test: Schedule_PourcentageBooking_Test
* @Coverage: 100 %
*/

global without sharing class Schedule_PourcentageBooking implements Schedulable{

    global void execute(SchedulableContext ctx) {
         
       String jobId = Database.executeBatch(new Batch_pourcentageBooking());
    }
}