/*
* Description: Test class for Schedule_FirstLastBooking
* @author: TMA-EI CG 
* @date: 24/12/2019
*/

@isTest
public class Schedule_FirstLastBooking_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 0 1/1 * ? *';
        String description = 'Update personaccounts first and last booking dates';
        System.schedule(description, CRON_EXP , new Schedule_FirstLastBooking());
    }

}