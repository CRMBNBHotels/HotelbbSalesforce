/*
* Description: Test class for ScheduleBatchUpdateMB02
* @author: TMA-EI CG 
* @date: 20/12/2019
*/

@isTest
public class ScheduleBatchUpdateMB02_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 0 1/1 * ? *';
        String description = 'Update Materbooking number of nights, number of rooms and stage counts';
        System.schedule(description, CRON_EXP , new ScheduleBatchUpdateMB02());
    }

}