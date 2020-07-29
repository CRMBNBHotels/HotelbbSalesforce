/*
* Description: CRMSS - 399 Batch to update the number of nights, rooms and stage counts of a masterbooking according to its related bookings 
* @author: TMA-EIL CG
* @date: 20/12/2019
* @Test: BatchUpdateMBNightsRoomsStageCount_Test
* @Coverage: 89%
*/

Global without sharing class Batch_UpdateMB_Nights_Rooms_StageCount implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String,String> mapMBId = new Map<String,String>();//this map will be filled in AP12_Opportunity, and used in the finish part to call the batch again
    global Integer Counter;//When this counter reaches 2, an email with failed Ids after 3 update retries will be sent
    
    //Defining the constructor of the batch, allowing to run the batch with the global variables above
    global Batch_UpdateMB_Nights_Rooms_StageCount(map<String, String> mapMBId, integer counter) {
        
        this.Counter = counter;
        this.mapMBId= new Map<String,String>();
        
        if(mapMBId != null && mapMBId.size()>0){
            
            this.mapMBId= mapMBId;
        }  
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //This strinbg will be filled manually with failed IDs, using the label BatchUpdateMBIds_ConfNb_HotelName
        String StaticListID = Label.BatchUpdateMBIds_Nights_Rooms_StageCount;system.debug('### cg StaticListID'+StaticListID);
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            
            liststaticId = StaticListID.split(',');
        }
        
        string queryModifBooks;
        string queryMBsBooks;
        set<string> setMBIds = new set<string>();
        
        //Query on opportunities of record type bookings to retrieve all data to be used
        
        //First we query on all data in SF meeting the conditions we need
        if((mapMBId == null || mapMBId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            
            queryModifBooks = 'select id , RecordtypeId, Master_Booking_FK__c, StageName, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c, LastModifiedDate, IsDeleted, Master_Booking_FK__r.TechIsNotFirst_01__c from opportunity '+System.Label.BatchUpdateMB_Nights_Rooms_StageCount_WhereClause+' ALL ROWS';
        }
        //Then we query on Bookings related to MBs that failed to update and are saved in mapMBId
        else if(mapMBId != null && mapMBId.size()>0){
            
            set<string> setMBId = mapMBId.keyset();
            queryModifBooks = 'select id , RecordtypeId, Master_Booking_FK__c, StageName, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c, LastModifiedDate, IsDeleted, Master_Booking_FK__r.TechIsNotFirst_01__c from Opportunity where Master_Booking_FK__c IN: setMBId All ROWS';
        }
        //At last we query on Bookings related to MBs that failed to update and are saved in the label BatchUpdateMBIds_ConfNb_HotelName
        else if(liststaticId != null && liststaticId.size() > 0){
            
            queryModifBooks = 'select id , RecordtypeId, Master_Booking_FK__c, StageName, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c, LastModifiedDate, IsDeleted, Master_Booking_FK__r.TechIsNotFirst_01__c from Opportunity where Master_Booking_FK__c IN: liststaticId All ROWS';
        }
        
        if (!string.isBlank(queryModifBooks)){
            List<Opportunity> lstBooks = Database.query(queryModifBooks);
            
            for(Opportunity book: lstBooks){
                
                setMBIds.add(book.Master_Booking_FK__c);
            }
        }
        
        if(setMBIds != null && setMBIds.size()>0){
            
            queryMBsBooks = 'select id , RecordtypeId, Master_Booking_FK__c, StageName, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c, LastModifiedDate, IsDeleted, Master_Booking_FK__r.TechIsNotFirst_01__c from Opportunity where Master_Booking_FK__c IN: setMBIds All ROWS';

        }
        return Database.getQueryLocator(queryMBsBooks);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
        
        list<Opportunity> listOppInLot = new list<opportunity>();
        List<Database.SaveResult> srListMB = new list<Database.SaveResult>();
        
        if(listBookings != null && listBookings.size()>0){
            
            //if(Limits.getQueries() < Limits.getLimitQueries()){
                
                listOppInLot = [select id , RecordtypeId, Master_Booking_FK__c, StageName, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c, LastModifiedDate, IsDeleted, Master_Booking_FK__r.TechIsNotFirst_01__c
                                from Opportunity 
                                where Id IN: listBookings All ROWS];
            //} 
        }
        
        //The OpportunityHandler returns the mapMBId filled with failed MB Ids
        if(listOppInLot != null && listOppInLot.size()>0){
            
            mapMBId = OpportunityHandler.filterBookingsBatch_UpdateMB_Nights_Rooms_StageCount(listOppInLot);system.debug('### cg mapMBId'+mapMBId);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        //deflag all updated masterbookings
        database.executeBatch(new Batch_DeflagMB_01());
        
        //If the counter is less than 2, we call the batch again
        if (counter < 2){
            
            counter ++;
            
            if(mapMBId != null && mapMBId.size()>0){
                
                Batch_UpdateMB_Nights_Rooms_StageCount batchObj = new Batch_UpdateMB_Nights_Rooms_StageCount(mapMBId,counter);
                DataBase.executeBatch(batchObj);
            }
        }
        //If the batch reached 3, we send an email with failed MB Ids, to be filled manually in the label BatchUpdateMBIds_ConfNb_HotelName
        else{

            String[] toAddresses = new String[] {'cynthia.geagea@ei-technologies.com'};
            String Subject = 'Batch Error : Batch_UpdateMB_Nights_Rooms_StageCount ';
            
            //if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){
                
                Utils_Email.sendEmailApex(toAddresses, Subject, mapMBId);
            //}
            
        }
    }

}