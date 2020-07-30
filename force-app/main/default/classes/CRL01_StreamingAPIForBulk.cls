public with sharing class CRL01_StreamingAPIForBulk {
    public static List<Object> GetallBulkJobId(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String endpoint = System.URL.getSalesforceBaseURL().toExternalForm()+'/services/data/v47.0/jobs/ingest/';
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('content-type', 'application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setMethod('GET');
        HttpResponse response = http.send(req);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'records' key as a list
            List<Object> records = (List<Object>) results.get('records');    
            return records;
        }
        return null;
    }
    
    public static void upsertDataInBulkJobAPI(List<Object> records){
        Map<String,BulkJobAPI__c> recordsByIdBulkJob = new  Map<String,BulkJobAPI__c>();
        for(Object record : records){
            BulkJobAPI__c newOrOldrecord = new BulkJobAPI__c();
            Map<String,Object> castRecord = (Map<String,Object>) record ;
            System.debug('record: '+castRecord.get('state'));
            newOrOldrecord.IdBulkJob__c = (String)castRecord.get('id');
            newOrOldrecord.NameOfobject__c = (String)castRecord.get('object');
            newOrOldrecord.State__c = (String)castRecord.get('state');
            recordsByIdBulkJob.put(newOrOldrecord.IdBulkJob__c,newOrOldrecord);
        }
        
        List<BulkJobAPI__c> recordsfromSFDCDataBase = [Select id,IdBulkJob__c ,State__c From BulkJobAPI__c where IdBulkJob__c in :recordsByIdBulkJob.keySet() ];
        Map<String,BulkJobAPI__c> recordsfromSFDCDataBaseByIdBulkJob = new Map<String,BulkJobAPI__c>();
        for(BulkJobAPI__c temp : recordsfromSFDCDataBase){
            recordsfromSFDCDataBaseByIdBulkJob.put(temp.IdBulkJob__c,temp);
        }
        
        for(String temp :recordsfromSFDCDataBaseByIdBulkJob.keySet()){
            if(recordsByIdBulkJob.get(temp).State__c == recordsfromSFDCDataBaseByIdBulkJob.get(temp).State__c ){
                recordsByIdBulkJob.remove(temp);
            }
        }
        
        if(!recordsByIdBulkJob.values().isEmpty()){
            upsert recordsByIdBulkJob.values() IdBulkJob__c;
            System.debug('Done');
        }
	}
    
	@future(callout=true)
    public static void getUpdateBulkJob(){
        CRL01_StreamingAPIForBulk.upsertDataInBulkJobAPI (CRL01_StreamingAPIForBulk.GetallBulkJobId ());
    }
}