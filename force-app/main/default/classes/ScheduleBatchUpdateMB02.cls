/*
* Description: Scheduler for Batch_UpdateMB_Nights_Rooms_StageCount . Job to every day at 00:00   
* String CRON_EXP = '0 0 0 1/1 * ? *';
  String description = 'Update Materbooking's number of nights, number of rooms and stage counts';
  System.schedule(description, CRON_EXP, new ScheduleBatchUpdateMB02());

* @author: TMA-EI CG
* @date: 20/12/2019
* @Test: ScheduleBatchUpdateMB02_Test
* @Coverage: 100 %
*/

global without sharing class ScheduleBatchUpdateMB02 implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
         
       String jobId = Database.executeBatch(new Batch_UpdateMB_Nights_Rooms_StageCount(null,0), 50);
    }

}