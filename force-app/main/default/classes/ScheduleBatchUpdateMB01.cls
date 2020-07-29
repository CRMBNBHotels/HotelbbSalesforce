/*
* Description: Scheduler for Batch_UpdateMB_ConfNb_HotelName . Job to run every 2 hours   
* String CRON_EXP = '0 0 0/2 1/1 * ? *';
  String description = 'Update Materbooking's confirmation number and hotel name';
  System.schedule(description, CRON_EXP, new ScheduleBatchUpdateMB01());

* @author: TMA-EI CG
* @date: 17/12/2019
* @Test: ScheduleBatchUpdateMB01_Test
* @Coverage: 100 %
*/

global without sharing class ScheduleBatchUpdateMB01 implements Schedulable{
    
     global void execute(SchedulableContext ctx) {
         
       String jobId = Database.executeBatch(new Batch_UpdateMB_ConfNb_HotelName(null,0), 50);
    }

}