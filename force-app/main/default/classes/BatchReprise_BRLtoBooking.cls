/*
* Description: Batch to calculate data on a booking according to its related booking room lines CRMSS-400
* @author: TMA-EIL JK
* @date: 21/11/2019
* @Test: BatchReprise_BRLtoBooking_Test
* @Coverage: 93%
*/

Global without sharing class BatchReprise_BRLtoBooking implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String,String> mapbookingId = new Map<String,String>();//this map will be filled in AP02_BookingRoomLine, and used in the finish part to call the batch again
    global Integer Counter;// counter is the number of time the batch has been called 
    global List<Id> lstBookingsId = new List<Id>();//list of booking ID from the BRL list
    global BatchReprise_BRLtoBooking( Map<String,String> mapbookingId,integer counter){
        
        this.Counter = counter;
        this.mapbookingId= new Map<String,String>();
        
        if(mapbookingId != null && mapbookingId.size()>0){
            
            this.mapbookingId= mapbookingId;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        //This strinbg will be filled manually with failed IDs, using the label BatchRepBRLtoBooking_Ids
        String StaticListID = Label.BatchRepBRLtoBooking_Ids;
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            
            liststaticId = StaticListID.split(',');
        }
        
        string query;
        //We query all (even the deleted ones) the booking room lines that are attached to a booking and last modified date >=yesterday //modified by JKA CRMSS-400
        //First we query on all data in SF meeting the conditions we need
        if((mapbookingId == null || mapbookingId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            
           // query = 'select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c, Tech_Booking_Breakfasts__c, TechBookingChambre__c,IsDeleted from Booking_Room_Line__c '+System.Label.BatchReprise_BRLtoBooking_01+' AND  Booking_FK__c!= \''+System.Label.BatchRepBRLtoBookingGenericID+'\' ALL ROWS';
             //tkt CRMSS-485  We query all  the booking room lines (without the deleted ones) that are attached to a booking and their created date = today
            query = 'select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c from Booking_Room_Line__c '+System.Label.BatchReprise_BRLtoBooking_02+' AND  Booking_FK__c!= \''+System.Label.BatchRepBRLtoBookingGenericID+'\'';
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+query);
        }
         //Then we query on BRL related to bookings that failed to update and are saved in mapbookingId
        else if(mapbookingId != null && mapbookingId.size()>0){
            
            set<string> setBookingId = mapbookingId.keyset();
            
           // query= 'select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c, Tech_Booking_Breakfasts__c, TechBookingChambre__c,IsDeleted from Booking_Room_Line__c where Booking_FK__c in :setBookingId and Room_code__c != null and Quantity__c >= 1 and LastModifiedDate >= YESTERDAY ALL ROWS';
             //tkt CRMSS-485
           query= 'select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c from Booking_Room_Line__c where Booking_FK__c in :setBookingId and Room_code__c != null and Quantity__c >= 1 and CreatedDate= TODAY';
        }
        //At last we query on BRL related to Bookings that failed to update and are saved in the label BatchRepBRLtoBooking_Ids
        else if(liststaticId != null && liststaticId.size() > 0){
            
            //query= 'select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c, Tech_Booking_Breakfasts__c, TechBookingChambre__c,IsDeleted from Booking_Room_Line__c where Booking_FK__c in :liststaticId and Room_code__c != null and Quantity__c >= 1 and LastModifiedDate >= YESTERDAY ALL ROWS';
            //tkt CRMSS-485
            query= 'select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__cfrom Booking_Room_Line__c where Booking_FK__c in :liststaticId and Room_code__c != null and Quantity__c >= 1 and CreatedDate= TODAY';
        }
        
      	
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Booking_Room_Line__c> listBRLs){
        
        
        //if we have a result from the query we will fill list of booking ID from the BRL list in lstBookingsId
                    
            for(Booking_Room_Line__c brl: listBRLs){
                
                lstBookingsId.add(brl.Booking_FK__c);
            }
        
        
        if(lstBookingsId!=null && lstBookingsId.size()>0){
            
            list<Booking_Room_Line__c> listBRLinLot = new list<Booking_Room_Line__c>([select id, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c
                                                                                      // tkt 485, Tech_Booking_Breakfasts__c, TechBookingChambre__c,IsDeleted 
                                                                                     from Booking_Room_Line__c 
                                                                                     where Booking_FK__c in : lstBookingsId// ALL ROWS
                                                                                     ]);
            listBRLs.addAll(listBRLinLot);
        }
        
        if(listBRLs!=null && listBRLs.size()>0){
            
            if(Limits.getQueries() < Limits.getLimitQueries()){
                list<Booking_Room_Line__c> listBRLinLot = new list<Booking_Room_Line__c>([select id,IsDeleted, Room_code__c, Quantity__c, Booking_FK__c, Booking_FK__r.Chambre__c, Booking_FK__r.Breakfasts__c
                                                                                         // tkt 485 ,Tech_Booking_Breakfasts__c, TechBookingChambre__c 
                                                                                          from Booking_Room_Line__c
                                                                                          where Booking_FK__c != null and Id IN: listBRLs// ALL ROWS
                                                                                         ]);
                  //The BookingRoomLineHandler returns the mapbookingId filled with failed booking Ids
             
                if(listBRLinLot != null && listBRLinLot.size()>0){
                    
                    mapbookingId = BookingRoomLineHandler.FilterBookingRoomLine(listBRLinLot);
                } 
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        //If the counter is less than 2, we call the batch again
        if (counter < 2){
            
            counter ++;
            
            if(mapbookingId != null && mapbookingId.size()>0){
                
                BatchReprise_BRLtoBooking batchObj = new BatchReprise_BRLtoBooking(mapbookingId,counter);
                DataBase.executeBatch(batchObj);
            }
        }
        //If the batch reached 3, we send an email with failed booking Ids, to be filled manually in the label BatchRepBRLtoBooking_Ids
        else{
            
           String[] toAddresses = new String[] {Label.BatchRepBRLtoBookingEmail};
            String Subject = 'Batch Error : BatchReprise_BRLtoBooking ';
            
            if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){
                system.debug('########$$$$'+mapbookingId);
                Utils_Email.sendEmailApex(toAddresses, Subject, mapbookingId);
            }
        }
    }
    
}