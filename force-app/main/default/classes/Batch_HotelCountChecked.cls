/*
* Description: CRMSS-401
* @author: TMA-EIL JKA
* @date: 18-12-2019
* @Test: 
* @Coverage:
*/

Global without sharing class Batch_HotelCountChecked implements Database.Batchable<sObject>, Database.Stateful{
    global Map<String,String> mapAccountId = new Map<String,String>();//this map will be filled in AP09_Opportunity, and used in the finish part to call the batch again
    global Integer Counter;// counter is the number of time the batch has been called 
    global List<Id> lstPAId = new List<Id>();//list of PA ID from the booking list
    
    
    //Defining the constructor of the batch, allowing to run the batch with the global variables above
    global Batch_HotelCountChecked(map<String, String> mapAccountId, integer counter) {
        
        this.Counter = counter;
        this.mapAccountId= new Map<String,String>();
        
        if(mapAccountId != null && mapAccountId.size()>0){
            
            this.mapAccountId= mapAccountId;
        }  
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //This strinbg will be filled manually with failed IDs, using the label BatchHotelCountChecked_Ids
        String StaticListID = Label.BatchHotelCountChecked_Ids;
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            
            liststaticId = StaticListID.split(',');
        }
        
        string query;
        string query2;
        if((mapAccountId == null || mapAccountId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            query = 'select id, Booking_Person_account__c,OldParent__c,OldParentAccount__c from opportunity ' + Label.Batch_HotelCountChecked_01 + ' ALL ROWS';
        }
        else if(mapAccountId != null && mapAccountId.size()>0){
             system.debug('@@@ mapAccountId '+mapAccountId);
            system.debug('@@@ mapAccountId.keyset() '+mapAccountId.keyset());
            set<string> setAccountId = mapAccountId.keyset();
           
            system.debug('@@@ setAccountId '+setAccountId);
            query = 'select id, Booking_Person_account__c,OldParent__c,OldParentAccount__c from opportunity where RecordType.DeveloperName=\'Booking\' and  Booking_Person_account__c != null and Booking_Person_account__c in: setAccountId  ALL ROWS';
            
        }
        else if(liststaticId != null && liststaticId.size() > 0){
            query = 'select id, Booking_Person_account__c,OldParent__c,OldParentAccount__c from opportunity where RecordType.DeveloperName=\'Booking\' and  Booking_Person_account__c != null and Booking_Person_account__c in: liststaticId  ALL ROWS';
        }
        
        system.debug('@@@@@ queryyyyy'+ query);
        if (!string.isBlank(query)){
            List<Opportunity> lstB = Database.query(query);
            
            for(Opportunity book: lstB){
                if(String.isNotBlank(book.Booking_Person_account__c)){
                    system.debug('@@@ in pa');
                lstPAId.add(book.Booking_Person_account__c);
                }
               // if(String.isNotBlank(book.OldParent__c)){
                    
                     //lstPAId.add(book.OldParent__c);
               // }
               
                 if(String.isNotBlank(book.OldParentAccount__c)){
                     system.debug('@@@ in old pa');
                     lstPAId.add(book.OldParentAccount__c);
                }
            }
            System.debug('@@@ batch lstPAId '+lstPAId);
        }
        
        if(lstPAId!=null && lstPAId.size()>0){
            
            query2 = 'select id, Booking_Person_account__c,OldParent__c,OldParentAccount__c from opportunity where RecordType.DeveloperName=\'Booking\' and  Booking_Person_account__c != null and  Booking_Person_account__c in: lstPAId ALL ROWS';
        }
        system.debug('@@@ query2 '+query2);
        return Database.getQueryLocator(query2);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
        
        list<Opportunity> listOppInLot = new list<Opportunity>();
        list<Account> listPAToUpdate = new list<Account>();
        
        if(listBookings != null && listBookings.size()>0){
            
            //if(Limits.getQueries() < Limits.getLimitQueries()){
                
                listOppInLot = [select id, Booking_Person_account__c, Booking_Person_account__r.TechIsNotFirst__c, Booking_Person_account__r.Hotels_Count__c,OldParentAccount__c, OldParentAccount__r.TechIsNotFirst__c, OldParentAccount__r.Hotels_Count__c, Booking_Person_account__r.Tech_HotelCount__c, StageName, Hotel_Name__c, Hotel_ID__c, Hotel__c,IsDeleted,LastModifiedDate,OldParent__c 
                                from opportunity 
                                where RecordType.DeveloperName='Booking' and  Booking_Person_account__c != null and id in : listBookings ALL ROWS];
                
                if(listOppInLot != null && listOppInLot.size()>0){
                    system.debug('@@@ listOppInLot '+listOppInLot);
                    mapAccountId = OpportunityHandler.filterBookings_Batch_HotelCountChecked(listOppInLot);
                } 
           // } 
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        database.executeBatch(new Batch_DeflagAccount());
        //If the counter is less than 2, we call the batch again
        if (counter < 2){
            
            counter ++;
            
            if(mapAccountId != null && mapAccountId.size()>0){
                
                Batch_HotelCountChecked batchObj = new Batch_HotelCountChecked(mapAccountId,counter);
                DataBase.executeBatch(batchObj);
            }
        }
        //If the batch reached 3, we send an email with failed PA Ids, to be filled manually in the label Batch_HotelCountChecked
        else{
            
            String[] toAddresses = new String[] {'joanna.karam@ei-technologies.com'};
                String Subject = 'Batch Error : Batch_HotelCountChecked ';
            
            if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){
                
                Utils_Email.sendEmailApex(toAddresses, Subject, mapAccountId);
            }
            
        }
    }
    
}