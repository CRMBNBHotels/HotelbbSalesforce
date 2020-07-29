/*
* Schedule to Batch_LoyaltyCardSubcription 
* @author: Joanna Karam
* @date: 09/08/2018
* @Test: Sch_BatchLoyaltyCardSubscription_Test
*/
global class Schedule_BatchLoyaltyCardSubscription implements Schedulable{
    public static String CRON_EXP = '0 0 12 1/1 * ? *';
    public static String Description = 'Check/Uncheck loyalty card on the account';
    global void execute(SchedulableContext ctx) {
        Batch_LoyaltyCardSubcription batchLc = new Batch_LoyaltyCardSubcription();
        ID batchprocessid = Database.executeBatch(batchLc);
    }
}