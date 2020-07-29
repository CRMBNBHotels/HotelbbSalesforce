/*
* Description: Batch Reprise to fill the field opco of masterbookings CRMSS-520
* @author: TMA-EIL CG
* @date: 16/03/2020
* @Test: BatchReprise_MasterBookingOpco_Test
* @Coverage: 100%
*/

global without sharing class BatchReprise_MasterBookingOpco implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //select bookings that have a hotel country and are linked to a masterbooking
        string query = 'select id, recordTypeId, RecordType.DeveloperName, Master_Booking_FK__c, HotelCountry__c, Master_Booking_FK__r.opco__c from opportunity where RecordType.DeveloperName = \'Booking\' and HotelCountry__c != null and Master_Booking_FK__c != null';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<opportunity> listBookings){
        
        map<string, list<opportunity>> mapMBIdListBooks = new map<string, list<opportunity>>();//map each masterbooking with a list of its related bookings
        list<Opportunity> listToUpdate = new list<opportunity>();//list to store masterbookings to update
        
        if(listBookings != null && listBookings.size()>0){
            
            for(opportunity book : listBookings){
                
                //retrieve each booking's masterbooking 
                if(!mapMBIdListBooks.containsKey(book.Master_Booking_FK__c)){
                    
                    list<opportunity> listToPut = new list<opportunity>();
                    listToPut.add(book);
                    
                    mapMBIdListBooks.put(book.Master_Booking_FK__c, listToPut);
                }
                else{
                    
                    list<opportunity> listToPut = mapMBIdListBooks.get(book.Master_Booking_FK__c);
                    listToPut.add(book);
                    
                    mapMBIdListBooks.put(book.Master_Booking_FK__c, listToPut);
                }
            }
            
            if(mapMBIdListBooks != null && mapMBIdListBooks.size()>0){
                
                for(string mbOppId : mapMBIdListBooks.keySet()){
                    
                    if(mapMBIdListBooks.get(mbOppId) != null && mapMBIdListBooks.get(mbOppId).size()>0){
                        
                        string opco;
                        
                        opportunity mbOpp = new opportunity(Id = mbOppId);
                        
                        for(opportunity book : mapMBIdListBooks.get(mbOppId)){
                            
                            if(book.Master_Booking_FK__r.opco__c == null){
                                
                                book.Master_Booking_FK__r.opco__c = '';
                            }
                            
                            //concatenate the bookings' hotel countries
                            book.Master_Booking_FK__r.opco__c = book.Master_Booking_FK__r.opco__c + book.HotelCountry__c + ','; 
                            opco = book.Master_Booking_FK__r.opco__c;
                        }
                        
                        //assign the concatenated valiue to the masterbooking's opco
                        mbOpp.opco__c = opco;
                        
                        listToUpdate.add(mbOpp);
                    }
                }
                
                if(listToUpdate != null && listToUpdate.size()>0){
                    
                    //update the masterbookings
                    database.update(listToUpdate, false);
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}