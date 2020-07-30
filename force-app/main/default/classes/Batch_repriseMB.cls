Global class Batch_repriseMB implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String MBRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.MasterBookingRTDevName).getRecordTypeId();
        String BRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId();
        string query='select id,person_account__c,Booking_Person_account__c, Masterbooking_Person_account__c, RecordTypeId '+
            ' from opportunity where Person_Account__c != null and ((RecordTypeId  = :BRT and Booking_Person_account__c = null) or (RecordTypeId  = :MBRT and Masterbooking_Person_account__c = null))' ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> listOpp){
        List<Opportunity> listOppToUpdate = new List<Opportunity>();
        for(Opportunity opp: listOpp){
            if(opp.Person_Account__c != null){
                if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.MasterBookingRTDevName).getRecordTypeId()){
                    opp.Masterbooking_Person_account__c = opp.Person_Account__c;
                    listOppToUpdate.add(opp);
                }else if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId()){
                    opp.Booking_Person_account__c = opp.Person_Account__c;
                    listOppToUpdate.add(opp);
                }
            }
        }
        if(listOppToUpdate != null && listOppToUpdate.size()>0){
            update listOppToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}