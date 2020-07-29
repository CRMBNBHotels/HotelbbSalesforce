/*
* Description: Batch to correct the field Data_History_2__c on previously created Person accounts. This batch will be executed only once.
* @author: TMA Cynthia Geagea
* @date: 17/09/2019
* @Test: BatchReprise_Account_DataHist2_Test
* @Coverage: 
*/

Global class BatchReprise_Account_DataHist2 implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'select id, Data_History__c from Account';
        //String query = 'select id,name, Email__pc, Data_History__c from account where LastModifiedDate  =TODAY and LastName like \'test%\' and Email__pc like \'%efram%\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Account> listAcc){
        
        List<Account> listAccFiltered = new List<Account>();
        
        For(Account acc : listAcc){
            Account accToUpdate = new Account();
            if(acc.Data_History__c != null){
                
                system.debug('accounthistory ' +  acc.Data_History__c);
                String accHistoryStr = acc.Data_History__c;                   
                accHistoryStr = accHistoryStr.replaceall('&amp;','&');
                accHistoryStr = accHistoryStr.replaceall('&quot;','"');
                
                AccountDataHistoryOld accntDataHistObject = new AccountDataHistoryOld();    
                accntDataHistObject = AccountDataHistoryOld.parse( accHistoryStr);
                AccountDataHistory accntDataHistObjectNew = new AccountDataHistory();
                
                if(accntDataHistObject != null){
                    accntDataHistObjectNew.CustomerType = accntDataHistObject.CustomerType;
                    accntDataHistObjectNew.CountryPercentage = accntDataHistObject.CountryPercentage;                
                }
                accToUpdate.id=acc.id;
                accToUpdate.Data_History__c = JSON.serialize(accntDataHistObjectNew);
                listAccFiltered.add(accToUpdate); 
            }
            
        }
        
        if(listAccFiltered != null && listAccFiltered.size()>0){
            
            update listAccFiltered;
        } 
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}