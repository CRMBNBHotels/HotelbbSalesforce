/*
* Description: CRMSS-285- This batch will be executed only once at night (00:00) , to Update the total nights partnership, total revenue partnership and total transactions partnership fields 
*             on business account(Company) based on the opportunity Partner Code
* @author: TMA-EIL JKA
* @date: 02/01/2020
* @Test: Batch_PartnershipFieldsUpdate_Test
* @Coverage: 89%
*/

Global without sharing class Batch_PartnershipFieldsUpdate implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String,String> mapAccountId = new Map<String,String>();
    global Integer Counter;// counter is the number of time the batch has been called 
    global set<String> setPAId = new set<String>();//list of PA ID from the booking list
    
    //Defining the constructor of the batch, allowing to run the batch with the global variables above
    global Batch_PartnershipFieldsUpdate(map<String, String> mapAccountId, integer counter) {
        
        this.Counter = counter;
        this.mapAccountId= new Map<String,String>();
        
        if(mapAccountId != null && mapAccountId.size()>0){
            
            this.mapAccountId= mapAccountId;
        }  
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String StaticListID = Label.Batch_PartnershipFieldsUpdate_PAIds;
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            
            liststaticId = StaticListID.split(',');
        }
        
        set<string> setAccountId = mapAccountId.keyset();
        String query;
        String query2;
        system.debug('@@@ mapAccountId '+mapAccountId);
        if((mapAccountId == null || mapAccountId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            
            query = 'select id, PartnerCode__c, RecordtypeId, Master_Booking_FK__c, Master_Booking_FK__r.Bookings_Checked_Count__c,IsDeleted from opportunity '+System.Label.Batch_PartnershipFieldsUpdate_WhereClause+'ALL ROWS';// and LastModifiedDate>=YESTERDAY
        }
        else if(mapAccountId != null && mapAccountId.size()>0){
            
            query = 'select id, PartnerCode__c, RecordtypeId, Master_Booking_FK__c, Master_Booking_FK__r.Bookings_Checked_Count__c,IsDeleted from opportunity where PartnerCode__c in: setAccountId ';
        }
        else if(liststaticId != null && liststaticId.size() > 0){
            
            query = 'select id, PartnerCode__c, RecordtypeId, Master_Booking_FK__c, Master_Booking_FK__r.Bookings_Checked_Count__c,IsDeleted from opportunity where PartnerCode__c in: liststaticId';
        }
        
        if (!string.isBlank(query)){
            system.debug('### cg query'+query);
            List<Opportunity> lstB = Database.query(query);
            system.debug('### cg lstB'+lstB);
            if(lstB!=null && lstB.size()>0){
                
                for(Opportunity book: lstB){
                    
                    if(book.PartnerCode__c != null && string.isNotBlank(book.PartnerCode__c)){
                        system.debug('### cg book.PartnerCode__c'+book.PartnerCode__c);
                        setPAId.add(book.PartnerCode__c);
                    }
                }
            }
        }
        system.debug('### cg setPAId'+setPAId);
        if(setPAId!=null && setPAId.size()>0){
            
            query2 = 'select id, PartnerCode__c, RecordtypeId, Master_Booking_FK__c, Master_Booking_FK__r.Bookings_Checked_Count__c,IsDeleted from opportunity where PartnerCode__c in:setPAId ALL ROWS';
        }
        
        return Database.getQueryLocator(query2);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
        
        list<Opportunity> listOppInLot = new list<Opportunity>();
        list<Account> listPAToUpdate = new list<Account>();
        
        if(listBookings != null && listBookings.size()>0){
            
            listOppInLot = [select id, PartnerCode__c, PartnerCode__r.Total_Transactions_PartnerShip__c, PartnerCode__r.Total_Revenue_PartnerShip__c, PartnerCode__r.Total_Nights_PartnerShip__c,IsDeleted,Invoiced_amount__c,
                            Number_of_nights__c, StageName, OnTheCurrentYear__c, RecordtypeId, Master_Booking_FK__c, Master_Booking_FK__r.Bookings_Checked_Count__c, PartnerCode__r.TechIsNotFirst_03__c
                            from opportunity 
                            where Id in : listBookings ALL ROWS];
            
            if(listOppInLot != null && listOppInLot.size()>0){
                
                mapAccountId = OpportunityHandler.filterBookings_Batch_PartnershipFieldsUpdate(listOppInLot);
            } 
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        database.executeBatch(new Batch_DeflagAccount_PartnerFields());
        
        //If the counter is less than 2, we call the batch again
        if (counter < 2){
            
            counter ++;
            
            if(mapAccountId != null && mapAccountId.size()>0){
                
                Batch_PartnershipFieldsUpdate batchObj = new Batch_PartnershipFieldsUpdate(mapAccountId,counter);
                DataBase.executeBatch(batchObj);
            }
        }
        //If the batch reached 3, we send an email with failed PA Ids, to be filled manually in the label Batch_HotelCountChecked
        else{
            
            String[] toAddresses = new String[] {'joanna.karam@ei-technologies.com'};
                String Subject = 'Batch Error : Batch_PartnershipFieldsUpdate ';
            Utils_Email.sendEmailApex(toAddresses, Subject, mapAccountId);
        }
    }
    
}