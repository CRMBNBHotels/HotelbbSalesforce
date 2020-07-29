/*
* Description: CRMSS-285 batch to deflag the company account to re-calculate from scratch
* @author: TMA-EIL CG
* @date: 03/01/2020
* @Test: Batch_PartnershipFieldsUpdate_Test
* @Coverage: 100%
*/

global without sharing class Batch_DeflagAccount_PartnerFields implements Database.Batchable<sObject>, Database.Stateful{

    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query ='select id, TechIsNotFirst_03__c from account where TechIsNotFirst_03__c = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Account> listAcc){
        
        List<Account> listAcctoUpdate = new List<Account>();
        
        for(Account acc  : listAcc){
            
            acc.TechIsNotFirst_03__c = false;
            listAcctoUpdate.add(acc);
        }
        
        Database.SaveResult[] srListPA;
        
        if(listAcctoUpdate != null && listAcctoUpdate.size()>0){
            
            srListPA = Database.update(listAcctoUpdate, false);
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}