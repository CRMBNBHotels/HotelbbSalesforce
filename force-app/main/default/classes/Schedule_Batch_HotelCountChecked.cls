/*
* Description: Scheduler for Batch_HotelCountChecked . Job to run every day at 12 am
* String CRON_EXP = '0 0 12 1/1 * ? *';
String description = 'Schedule Batch HotelCountChecked';
System.schedule(description, CRON_EXP, new Schedule_Batch_HotelCountChecked());

* @author: TMA-EI JKA
* @date:  19-12-2019
* @Test: Schedule_Batch_HotelCountChecked_Test
* @Coverage: 100%
*/

global without sharing class Schedule_Batch_HotelCountChecked implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
       String jobId = Database.executeBatch(new Batch_HotelCountChecked(null,0), 50);
    }
}