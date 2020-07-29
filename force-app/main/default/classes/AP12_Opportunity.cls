/*
* Description: Class to update the field Hotel_Name_MB__c on MB based on Hotel_Name__c on its Bookings, and Confirmation_Number__c on MB base on Confrimation_number__c on its bookings
               CRMSS - 398
* @author: TMA-EIL CG
* @date: 12/12/2019
* @Test class: Batch_UpdateMB_ConfNb_HotelName_Test 
* @Coverage:  84% 
*/

public without sharing class AP12_Opportunity {
   
    //This method fills the hotel name of a masterbooking according to its related bookings' hotels, called by updateMasterBooking
    public static List<opportunity> getHotelName(Map<String, list<Opportunity>> mapMBlistBookings){
        
        //List to return masterbookings to update
        list<Opportunity> listMBsToUpdate = new List<Opportunity>();
        
        //Loop over masterbookings in the map
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(string mbId : mapMBlistBookings.keySet()){
                
                Opportunity masterBook = new Opportunity();
                masterBook.Id = mbId;
                
                if(mapMBlistBookings.get(mbId) != null && mapMBlistBookings.get(mbId).size()>0){
                    
                    masterBook.Hotel_Name_MB__c = mapMBlistBookings.get(mbId)[0].Hotel_Name__c; 
                }
                else{ //If the masterbooking in the map has an empty list of bookings, it means it has no bookings related to it, so the hotel name should be null
                    
                    masterBook.Hotel_Name_MB__c = '';
                }
                
                //Add the masterbooking to the list to update
                listMBsToUpdate.add(masterBook);
            }
        }
        
        return listMBsToUpdate;
    }
    
    //This methof fills the confirmation number of a masterbooking according to its related booking's confirmation numbers, called by updateMasterBooking
    public static List<Opportunity> getConfirmationNb (Map<String, list<Opportunity>> mapMBlistBookings){
        
        //List to return masterbookings to update
        List<opportunity> listMBsToUpdate = new List<opportunity>();
        
        //Loop over masterbookings in the map 
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(string mbId : mapMBlistBookings.keySet()){
                
                Opportunity masterBook = new Opportunity();
                masterBook.Id = mbId;
                
                if(mapMBlistBookings.get(mbId) != null && mapMBlistBookings.get(mbId).size()>0){
                    
                    masterBook.Confirmation_Number__c = mapMBlistBookings.get(mbId)[0].Confirmation_Number__c; 
                }
                else{//If the masterbooking in the map has an empty list of bookings, it means it has no bookings related to it, so the confirmation number should be null
                    
                    masterBook.Confirmation_Number__c = '';
                }
                
                //Add the masterbooking to the list to update
                listMBsToUpdate.add(masterBook);
            }
        }
        
        return listMBsToUpdate;
    }
    
    //This method calls the above methods fillHotelName and fillConfirmationNb in order to update the masterbookings, called by OpportunityHandler 
    public static Map<String,String> updateMasterBooking(Map<String, list<Opportunity>> mapMBlistBookings){
        
        Database.SaveResult[] srListMB;//For dynamic Update
        Map<String,String> mapMBIdErrors = new Map<String,String>();
        
        map<string,opportunity> mapMBsToUpdate = new map<string, opportunity>();//map to retrieve all masterbookings to update
        
        list<opportunity> listMBwithConNb = new list<opportunity>();//list to be filled with fillConfirmationNb method
        list<opportunity> listMBwithHotelName = new list<Opportunity>();//list to be filled with fillHotelName method
        
        map<string, list<opportunity>> mapMBlistBookingsConfNb = new map<string, list<opportunity>>();//map to be given as a parameter to fillConfirmationNb
        map<string, list<opportunity>> mapMBlistBookingsHotelName = new map<string, list<opportunity>>();//map to be given as a parameter to fillHotelName
        
        //Fill the maps with convenient Masterbookings
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(string mbId : mapMBlistBookings.keyset()){
                
                if(mapMBlistBookings.get(mbId) != null && mapMBlistBookings.get(mbId).size()>0){
                    
                    for(Opportunity book : mapMBlistBookings.get(mbId)){
                        
                        //fill the map mapMBlistBookingsConfNb used to call getConfirmationNb
                        if(book.Confirmation_Number__c != null && book.Confirmation_Number__c != '' && string.isNotBlank(book.Confirmation_Number__c)){
                            
                            if(!book.IsDeleted){
                                
                                if(!mapMBlistBookingsConfNb.containsKey(mbId)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(book);
                                    mapMBlistBookingsConfNb.put(mbId,listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut = mapMBlistBookingsConfNb.get(mbId);
                                    listToPut.add(book);
                                    mapMBlistBookingsConfNb.put(mbId,listToPut);
                                }
                                
                            }
                            else{
                                
                                if(!mapMBlistBookingsConfNb.containsKey(mbId)){
                                   
                                    mapMBlistBookingsConfNb.put(mbId, new list<Opportunity>());
                                }
                                else{
                                    
                                    mapMBlistBookingsConfNb.put(mbId, mapMBlistBookingsConfNb.get(mbId));
                                } 
                            }
                        }
                        
                        
                        //fill the map mapMBlistBookingsHotelName used to call getHotelName
                        if(book.Hotel_Name__c != null && book.Hotel_Name__c != '' && string.isNotBlank(book.Hotel_Name__c)){
                            
                            if(!book.IsDeleted){
                                
                                if(!mapMBlistBookingsHotelName.containsKey(mbId)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(book);
                                    mapMBlistBookingsHotelName.put(mbId,listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut = mapMBlistBookingsHotelName.get(mbId);
                                    listToPut.add(book);
                                    mapMBlistBookingsHotelName.put(mbId,listToPut);
                                }
                            }
                            else{
                                
                                if(!mapMBlistBookingsHotelName.containsKey(mbId)){
                                   
                                    mapMBlistBookingsHotelName.put(mbId, new list<Opportunity>());
                                }
                                else{
                                    
                                    mapMBlistBookingsHotelName.put(mbId, mapMBlistBookingsHotelName.get(mbId));
                                }
                            }
                        } 
                    }  
                }
            } 
        }
        
        //get the masterbooking' hotel names calculated
        if(mapMBlistBookingsHotelName != null && mapMBlistBookingsHotelName.size()>0){
            
            listMBwithHotelName = getHotelName(mapMBlistBookingsHotelName);
            
            if(listMBwithHotelName != null && listMBwithHotelName.size()>0){
            
                for(Opportunity mbOpp : listMBwithHotelName){
                    
                    mapMBsToUpdate.put(mbOpp.Id, mbOpp);
                }
            }
        }
        
        //get the masterbookings' confirmation numbers calculated
        if(mapMBlistBookingsConfNb != null && mapMBlistBookingsConfNb.size()>0){
            
            listMBwithConNb = getConfirmationNb(mapMBlistBookingsConfNb);
            
            if(listMBwithConNb != null && listMBwithConNb.size()>0){
                
                for(Opportunity mbOpp : listMBwithConNb){
                    
                    if(!mapMBsToUpdate.containsKey(mbOpp.Id)){
                        
                        mapMBsToUpdate.put(mbOpp.Id, mbOpp);
                    }
                    else{
                        
                        mbOpp.Hotel_Name_MB__c = mapMBsToUpdate.get(mbOpp.Id).Hotel_Name_MB__c;
                        mapMBsToUpdate.put(mbOpp.Id, mbOpp);
                    }
                }
            }
        }
        
        //Update the masterbookings
        if(mapMBsToUpdate != null && mapMBsToUpdate.size()>0){
            
            try{
                
                //if(Limits.getDMLStatements() < Limits.getLimitDmlStatements()){
                    
                    srListMB = database.update(mapMBsToUpdate.values(), false);
                    
                    //Loop over updated masterbookings, to catch errors encountered and return them to the batch
                    for(Integer i=0; i < (mapMBsToUpdate.values()).size(); i++){
                        
                        Database.SaveResult sr = srListMB[i];
                        
                        Opportunity MBook = (mapMBsToUpdate.values())[i];
                        
                        if (!sr.isSuccess()){
                            
                            Database.Error error = sr.getErrors().get(0);
                            String errorMsg = error.getMessage();
                            
                            mapMBIdErrors.put(MBook.Id, errorMsg);
                        } 
                    }
                //}
                
            }
            
            catch(exception e){
                
                system.debug('The following error occured while updating Masterbookings: '+ e.getMessage());
            } 
        }
        
        return mapMBIdErrors;
    }
}