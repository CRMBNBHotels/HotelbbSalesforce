/*
* Description: Batch to delete the records of the object log__c
* @author: Cynthia Geagea
* @date: 27/06/2019
* @Related Batch: BatchSuppression_Logs
* @Test: Schedule_SuppressionLogs_Test
* @Coverage: 100%
*/

global class Schedule_SuppressionLogs implements schedulable{
    
    public String CRON_EXP = '0 0 22 1/1 * ? *'; 
    public String description = 'Suppression Logs';
    
    global void execute(SchedulableContext sc)
    {
        BatchSuppression_Logs batch = new BatchSuppression_Logs();
        ID batchprocessid = Database.executeBatch(batch);
    }

}