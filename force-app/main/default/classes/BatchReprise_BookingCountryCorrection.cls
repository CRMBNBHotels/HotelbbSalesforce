global class BatchReprise_BookingCountryCorrection  implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id,Country__c from Hotel__c where Country__c =\'France\'  '+
           ' OR Country__c =\'Italy\' OR Country__c =\'Poland\' OR Country__c =\'Germany\' OR Country__c =\'Spain\'' ;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Hotel__c> listHot)
    {
        List<Hotel__c> hotelToUpdate = new List<Hotel__c>();
            for(Hotel__c hot: listHot){
                if(hot.Country__c =='France'){ 
                    hot.Country__c = 'FR';
                }
                if(hot.Country__c =='Italy'){
                    hot.Country__c = 'IT';
                }
                if(hot.Country__c =='Poland'){
                   hot.Country__c = 'PL'; 
                }
                if(hot.Country__c =='Germany'){
                   hot.Country__c = 'DE'; 
                }
                if(hot.Country__c =='Spain'){
                   hot.Country__c = 'ES'; 
                }
                hotelToUpdate.add(hot);
            }
        update hotelToUpdate;
    }
    global void finish(Database.BatchableContext BC)
    {
        database.executeBatch(new BatchReprise_BookingPourcentage());
    }
}