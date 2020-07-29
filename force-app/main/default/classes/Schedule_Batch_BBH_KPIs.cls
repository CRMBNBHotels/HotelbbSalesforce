/*
* Description: Scheduler for Batch_BBH_KPIs . Job to every day at 00:00   
* String CRON_EXP = '0 0 0 1/1 * ? *';
  String description = 'Insert KPI Reports TopLoyaltyProgram records';
  System.schedule(description, CRON_EXP, new Schedule_Batch_BBH_KPIs());

* @author: TMA-EIL 
* @date: 10/02/2020
* @Test: Schedule_Batch_BBH_KPIs_Test
* @Coverage: 100 %
*/

Global without sharing class Schedule_Batch_BBH_KPIs implements Schedulable{

    global void execute(SchedulableContext ctx) {
         
       String jobId = Database.executeBatch(new Batch_BBH_KPIs());
    }
}