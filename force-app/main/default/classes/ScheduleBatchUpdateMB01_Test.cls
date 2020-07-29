/*
* Description: Test class for ScheduleBatchUpdateMB01 
* @author: TMA-EI CG 
* @date: 17/12/2019
*/

@isTest
public class ScheduleBatchUpdateMB01_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 0/2 1/1 * ? *';
        String description = 'Update Materbooking confirmation number and hotel name';
        System.schedule(description, CRON_EXP , new ScheduleBatchUpdateMB01());
    }

}