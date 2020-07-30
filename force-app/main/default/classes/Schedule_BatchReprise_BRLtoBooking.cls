/*
* Description: Scheduler for BatchReprise_BRLtoBooking . Job to run every day at 22h
* String CRON_EXP = '0 0 22 1/1 * ? *';
  String description = 'Schedule BatchReprise BRLtoBooking';
  System.schedule(description, CRON_EXP, new Schedule_BatchReprise_BRLtoBooking());

* @author: TMA-EI JKA
* @date:  17-12-2019
* @Test: Schedule_BatchReprise_BRLtoBooking_Test
* @Coverage: 100%
*/

global class Schedule_BatchReprise_BRLtoBooking implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
       String jobId = Database.executeBatch(new BatchReprise_BRLtoBooking(null,0), 50);
    }
}