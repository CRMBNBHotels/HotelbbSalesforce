/*
* Description: Test class for Schedule_BatchReprise_BRLtoBooking 
* @author: TMA-EI JKA
* @date:  17-12-2019
*/

@isTest
public class Schedule_BatchReprise_BRLtoBooking_Test {
    
    @istest static void testSchedule() {
        
        String CRON_EXP = '0 0 22 1/1 * ? *';
        String description = 'Schedule BatchReprise BRLtoBooking';
        System.schedule(description, CRON_EXP, new Schedule_BatchReprise_BRLtoBooking());
        
    }
    
}