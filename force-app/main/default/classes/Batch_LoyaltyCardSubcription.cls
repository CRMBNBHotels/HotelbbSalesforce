/*
* Update E-Club Subscription on Account when E-Club Start Date on Loyalty Card <=today and E-Club Renewal Period End Date>=today
* @author: TMA-EI - JK
* @date: 09/08/2018
* @Test: Batch_LoyaltyCardSubcription_Test
*/
global class Batch_LoyaltyCardSubcription implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        User currUser = new User();
        currUser.id = userinfo.getUserId();
        currUser.BypassProcessBuilder__c = true;
        currUser.BypassValidationRule__c = true;
        currUser.BypassWorkflow__c = true;
        update currUser;
        
        string query='select id,E_club_subscription__pc,'+
            '(select id,E_Club_Start_Date__c,E_Club_Renewal_Period_End_Date__c from Loyalty_Cards__r'+
            ' where E_Club_Start_Date__c<= today and  E_Club_Renewal_Period_End_Date__c>= today limit 1)'
            +' from account where recordtypeId = \'' + Label.PersonAccountRecordTypeId + '\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Account> listAcc)
    {
        List<Account> listAccToUpdate = new List<Account>();
        List<Loyalty_Card__c> listLC = new List<Loyalty_Card__c>();
        for(Account acc:listAcc){
            listLC = acc.Loyalty_Cards__r;
            if((listLC == null || listLC.size() == 0) && acc.E_club_subscription__pc){
                acc.E_club_subscription__pc = false;
                listAccToUpdate.add(acc);
            } else if((listLC != null && listLC.size() > 0) && !acc.E_club_subscription__pc){
                acc.E_club_subscription__pc = true;
                listAccToUpdate.add(acc);
            } 
        }
        
        if(listAccToUpdate != null && listAccToUpdate.size()>0){
            update listAccToUpdate;
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        User currUser = new User();
        currUser.id = userinfo.getUserId();
        currUser.BypassProcessBuilder__c = false;
        currUser.BypassValidationRule__c = false;
        currUser.BypassWorkflow__c = false;
        update currUser;
    }
}