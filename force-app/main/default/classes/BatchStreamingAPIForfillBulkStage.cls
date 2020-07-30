global class BatchStreamingAPIForfillBulkStage  implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT ID From Account limit 1'); // no need 
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        CRL01_StreamingAPIForBulk.upsertDataInBulkJobAPI (CRL01_StreamingAPIForBulk.GetallBulkJobId ());
        System.debug('done');
    }    
    global void finish(Database.BatchableContext bc){
       
    }    
}