/*
* Description: Batch to delete the records of the object log__c
* @author: Cynthia Geagea
* @date: 26/06/2019
* @Test: BatchReprise_Account_Test
* @Coverage: 100%
*/

Global class BatchReprise_Account implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'select id, Data_History__c from Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Account> listAcc){
       
        List<Account> listAccFiltered = new List<Account>();
        
        For(Account acc : listAcc){
            
            if(acc.Data_History__c == null){
                
                acc.Data_History__c = '{&quot;totalRevenue&quot;:0,&quot;totalNights&quot;:0,&quot;mapBookingRevenue&quot;:{},&quot;mapBookingNight&quot;:{},&quot;customerType&quot;:{&quot;leisure&quot;:0,&quot;business&quot;:0},&quot;countryPercentage&quot;:{&quot;spain&quot;:0,&quot;poland&quot;:0,&quot;others&quot;:0,&quot;italy&quot;:0,&quot;germany&quot;:0,&quot;france&quot;:0}}';
                listAccFiltered.add(acc);
            }
        }
        
        update listAccFiltered;
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

}