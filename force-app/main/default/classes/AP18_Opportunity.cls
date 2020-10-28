/**
* @author TMA-EIL CG
* @date 11/03/2020
* @description Fill the field opco of the masterbookings on insert and update CRMSS-474
* @test class : AP18_Opportunity_test
* @coverage: 100 %
*/

public without sharing class AP18_Opportunity {
    
    //method to fill th field opco of a masterbooking on after insert of a booking
    public static void fillMBOpco(list<opportunity> listNewOpp){

        Id bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        Id masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        
        map<string, list<opportunity>> mapBookIdMBId = new map<string, list<opportunity>>();//map each masterbooking with its related bookings
        list<opportunity> listMbToUpdate = new list<opportunity>();//list to strore masterbookings to update
        
        if(listNewOpp != null && listNewOpp.size()>0){
            
            for(opportunity opp : listNewOpp){
                
                //retrieve each booking's masterbooking 
                if(opp.RecordTypeId == bookingRTId && opp.HotelCountry__c != null && string.isNotBlank(opp.HotelCountry__c) && opp.Master_Booking_FK__c != null && string.isNotBlank(opp.Master_Booking_FK__c)){
                    
                    if(!mapBookIdMBId.containsKey(opp.Master_Booking_FK__c)){
                        
                        list<opportunity> listToPut = new list<opportunity>();
                        listToPut.add(opp);
                        
                        mapBookIdMBId.put(opp.Master_Booking_FK__c, listToPut);
                    }
                    else{
                        
                        list<opportunity> listToPut = mapBookIdMBId.get(opp.Master_Booking_FK__c);
                        listToPut.add(opp);
                        
                        mapBookIdMBId.put(opp.Master_Booking_FK__c, listToPut);
                    }
                    
                }
            }
            
            if(mapBookIdMBId != null && mapBookIdMBId.size()>0){
                
                for(opportunity mbOpp : [select id, RecordTypeId, opco__c from opportunity where RecordTypeId =: masterBookingRTId AND Id IN: mapBookIdMBId.KeySet()]){
                    
                    string opco = '';
                    
                    if(mapBookIdMBId.get(mbOpp.Id) != null && mapBookIdMBId.get(mbOpp.Id).size()>0){
                        
                        for(opportunity book : mapBookIdMBId.get(mbOpp.Id)){
                            
                            //concatenate the bookings' hotel countries
                            opco = opco + book.HotelCountry__c + ',';
                        }
                    }
                    
                    if(mbOpp.opco__c == null){
                        
                        mbOpp.opco__c = '';
                    }
                    
                    //concatenate the masterbooking's opco with the above string
                    mbOpp.opco__c = mbOpp.opco__c + opco ;
                    
                    listMbToUpdate.add(mbOpp);
                }
                
                if(listMbToUpdate != null && listMbToUpdate.size()>0){
                    
                    //update the masterbookings
                    database.update(listMbToUpdate, false);
                }
            }
        }
    }
}