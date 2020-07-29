/**
* 
* @version 1.00 09/08/2018
* @author Joyce Saidy
* @CodeCoverage 100%
*/
@isTest
public class Sch_BatchLoyaltyCardSubscription_Test{
    
    static testMethod void test_Sch_BatchLoyaltyCardSubscription(){
        Schedule_BatchLoyaltyCardSubscription s = new Schedule_BatchLoyaltyCardSubscription();
        System.schedule(Schedule_BatchLoyaltyCardSubscription.Description, Schedule_BatchLoyaltyCardSubscription.CRON_EXP, s);
    }
}