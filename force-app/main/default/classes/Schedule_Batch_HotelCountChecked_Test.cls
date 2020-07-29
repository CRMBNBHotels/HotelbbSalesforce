/*
* Description: Test class for Schedule_Batch_HotelCountChecked 
* @author: TMA-EI JKA
* @date:  19-12-2019
*/

@isTest
public class Schedule_Batch_HotelCountChecked_Test {
    
    @istest static void testSchedule() {
        
        String CRON_EXP = '0 0 12 1/1 * ? *';
        String description = 'Schedule Batch HotelCountChecked';
        System.schedule(description, CRON_EXP, new Schedule_Batch_HotelCountChecked());
    }
}