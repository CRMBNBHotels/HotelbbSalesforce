/*
* Description: Test class for Schedule_PourcentageBooking
* @author: TMA-EI JK
* @date: 11/03/2020
*/

@isTest
public class Schedule_PourcentageBooking_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 0 * * ?';
        String description = 'Update Booking Percentage';
        System.schedule(description, CRON_EXP , new Schedule_PourcentageBooking());
    }

}