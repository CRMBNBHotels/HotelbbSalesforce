/*
* @Description: Test Class For Schedule_SuppressionLogs 
* @author: Bachir Asmar
* @date: 27/06/2019
* @Schduler: Schedule_SuppressionLogs
*/

@isTest
public class Schedule_SuppressionLogs_Test {
    
    @isTest
    Static void ScheduleSuppressionLogsTest(){
        
        Test.startTest();
        Schedule_SuppressionLogs testsche = new Schedule_SuppressionLogs();
        String sch = '0 0 23 * * ?';
        system.schedule('Test supression logs', sch, testsche );
        Test.stopTest();
    }

}