/*
* Description: Test class for Schedule_Batch_BBH_KPIs
* @author: TMA-EIL
* @date: 10/02/2019
*/

@isTest
public class Schedule_Batch_BBH_KPIs_Test {

    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 0 1/1 * ? *';
        String description = 'Insert KPI Reports TopLoyaltyProgram records';
        System.schedule(description, CRON_EXP , new Schedule_Batch_BBH_KPIs());
    }
}