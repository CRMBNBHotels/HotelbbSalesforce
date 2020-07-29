/*
* Description: Batch Reprise to fill the field opco of bookings CRMSS-520
* @author: TMA-EIL CG
* @date: 16/03/2020
* @Test: BatchReprise_BookingOpco_Test
* @Coverage: 100%
*/

global without sharing class BatchReprise_BookingOpco implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //select bookings that have a hotel country but their opco__c field is null
        string query = 'select id, recordTypeId, recordType.DeveloperName, opco__c, HotelCountry__c from opportunity where recordType.DeveloperName = \'Booking\' and opco__c = null and HotelCountry__c != null';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<opportunity> listBookings){
        
        list<opportunity> listToUpdate = new list<opportunity>();
        
        if(listBookings != null && listBookings.size()>0){
            
            for(opportunity book : listBookings){
                
                //fill opco__c with the hotelcountry__c of the booking
                book.opco__c = book.HotelCountry__c;
                
                listToUpdate.add(book);
            }
            
            if(listToUpdate != null && listToUpdate.size()>0){
                
                //update the bookings
                database.update(listToUpdate, false);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}