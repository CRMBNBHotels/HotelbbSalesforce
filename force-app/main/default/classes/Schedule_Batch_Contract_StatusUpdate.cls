/*
* Description: Scheduler for Batch_Contract_StatusUpdate. Job to run every day at 00:01 AM  
* String CRON_EXP = '0 1 0 1/1 * ? *';
  String description = 'Update Corporate Contract Status';
  System.schedule(description, CRON_EXP, new Schedule_Batch_Contract_StatusUpdate());

* @author: TMA-EI Cynthia Geagea
* @date: 31/10/2019
* @Test: Schedule_BatchContractStatusUpdate_Test
* @Coverage: 100%
*/

global without sharing class Schedule_Batch_Contract_StatusUpdate implements Schedulable{

    global void execute(SchedulableContext ctx) {
        
       String jobId = Database.executeBatch(new Batch_Contract_StatusUpdate(), 200);
    }
}