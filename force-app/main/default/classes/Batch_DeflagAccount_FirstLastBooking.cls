/*
* Description: CRMSS-395 batch to deflag the person account to re-calculate from scratch
* @author: TMA-EIL CG
* @date: 30/12/2019
* @Test: Batch_FirstLastBooking_Test
* @Coverage: 100%
*/

global without sharing class Batch_DeflagAccount_FirstLastBooking implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query ='select id from account where TechIsNotFirst_02__c = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Account> listAcc){
        
        List<Account> listAcctoUpdate = new List<Account>();
        
        for(Account acc  : listAcc){
            
            acc.TechIsNotFirst_02__c = false;
            listAcctoUpdate.add(acc);
        }
        
        Database.SaveResult[] srListPA;
        
        if(listAcctoUpdate != null && listAcctoUpdate.size()>0){
            
            srListPA = Database.update(listAcctoUpdate, false);
        }
    }
    
    global void finish(Database.BatchableContext BC){}

}