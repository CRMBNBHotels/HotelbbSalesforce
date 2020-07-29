/*
* Description: Test class for Schedule_Batch_Contract_StatusUpdate 
* @author: TMA-EI Cynthia Geagea
* @date: 31/10/2019
*/

@isTest
public class Schedule_BatchContractStatusUpdate_Test {
    
    @isTest 
    static void scheduleBatchContractStatusUpdateTest() {
        String CRON_EXP = '0 1 0 1/1 * ? *';
        String description = 'Update Corporate Contract Status';
        System.schedule(description, CRON_EXP , new Schedule_Batch_Contract_StatusUpdate());
    }

}