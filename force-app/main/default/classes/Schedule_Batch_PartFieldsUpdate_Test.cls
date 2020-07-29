/*
* Description: Test class for Schedule_Batch_PartnershipFieldsUpdate 
* @author: TMA-EI CG
* @date:  06-01-2020
*/

@isTest
public class Schedule_Batch_PartFieldsUpdate_Test {
    
    @istest static void testSchedule() {
        
        String CRON_EXP = '0 0 12 1/1 * ? *';
        String description = 'Schedule Batch Partnership Fields Update';
        System.schedule(description, CRON_EXP, new Schedule_Batch_PartnershipFieldsUpdate());
    }
}