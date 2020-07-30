/*
* Description: Scheduler Batch_PartnershipFieldsUpdate . Job to run every day at 12 am
* String CRON_EXP = '0 0 0 1/1 * ? *';
String description = 'Schedule Batch Partnership Fields Update';
System.schedule(description, CRON_EXP, new Schedule_Batch_PartnershipFieldsUpdate());

* @author: TMA-EI CG
* @date:  06-01-2020
* @Test: Schedule_Batch_PartFieldsUpdate_Test
* @Coverage: 100%
*/

global class Schedule_Batch_PartnershipFieldsUpdate implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
       String jobId = Database.executeBatch(new Batch_PartnershipFieldsUpdate(null,0), 50);
    }
}