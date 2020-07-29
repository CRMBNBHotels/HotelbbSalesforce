/*
* Description: Batch to delete the records of the object log__c
* @author: Cynthia Geagea
* @date: 20/06/2019
* @Test: BatchSuppression_Logs_Test
* @Coverage: 100%
*/

global without sharing class BatchSuppression_Logs implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){

        //Datetime limitDate = (DateTime)JSON.deserialize('"' + Label.BatchSuppressionLogs_LimitDate + '"', DateTime.class);
        DateTime myDate = DateTime.now().AddDays(Integer.valueOf(Label.BatchSuppressionLogs_LimitDate));
        String limitDateString = myDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        Datetime limitDate = (DateTime)JSON.deserialize('"' + limitDateString + '"', DateTime.class);
        system.debug('limitDate'+limitDate);
       
        string query='select  id, CreatedDate from Log__c where CreatedDate <: limitDate' ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Log__c> listLogs){
        
        //Datetime limitDate = (DateTime)JSON.deserialize('"' + Label.BatchSuppressionLogs_LimitDate + '"', DateTime.class);
        DateTime myDate = DateTime.now().AddDays(Integer.valueOf(Label.BatchSuppressionLogs_LimitDate));
        String limitDateString = myDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        Datetime limitDate = (DateTime)JSON.deserialize('"' + limitDateString + '"', DateTime.class);
        
        list<Attachment> listAttachments = [select Id, CreatedDate, ParentId from Attachment where CreatedDate <: limitDate and ParentId IN: listLogs];

        delete listAttachments;
        delete listLogs;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

}