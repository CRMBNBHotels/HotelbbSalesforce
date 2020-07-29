/*
* Description: Class to update the fields Number_of_nights_master__c, Rooms__c, Bookings_Booked_Count__c, Bookings_Checked_Count__c, Bookings_cancelled_Count__c, Bookings_Error_Count__c, Bookings_NoShow_Count__c on a 
masterbooking based on its related bookings
CRMSS - 399  
* @author: TMA-EIL CG
* @date: 19/12/2019
* @Test class: BatchUpdateMBNightsRoomsStageCount_Test
* @Coverage: 82 %
*/

public without sharing class AP11_Opportunity {
    public static Map<String,Boolean> mapMBFlag = new Map<String,Boolean>();
    
    //This method fills the number of nights and the rooms of a masterbooking according to its related bookings, called by updateMasterBooking
    public static list<opportunity> getNightsAndRooms(Map<String, list<Opportunity>> mapMBlistBookings){
        system.debug('### cg mapMBlistBookings nights'+mapMBlistBookings);
        //List to return masterbookings to update
        list<opportunity> listMBsToUpdate = new list<opportunity>();
        
        //Loop over masterbookings in the map
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(string mbId : mapMBlistBookings.keyset()){
                
                Opportunity masterBook = new Opportunity();
                masterBook.Id = mbId;
                
                Decimal sumNights = 0;//sum of nights on the masterbooking
                Decimal sumChambres = 0;//sum of rooms on the masterbooking
                
                if(mapMBlistBookings.get(mbId) != null && mapMBlistBookings.get(mbId).size()>0){
                    
                    for(Opportunity book : mapMBlistBookings.get(mbId)){
                        system.debug('### entered: ' + book.Master_Booking_FK__r.TechIsNotFirst_01__c);
                        //if the MBs are flagged, that means the batch hasn't finished running yet, so we need to add up the numbers in the calculations
                        if(book.Master_Booking_FK__r.TechIsNotFirst_01__c){
                            system.debug('### entered');
                            //We need to check these conditions in the first place, in order to not erase existing data on the fields in question
                            if(book.Master_Booking_FK__r.Number_of_nights_master__c != null && book.Master_Booking_FK__r.Number_of_nights_master__c != 0 && sumNights == 0){
                                
                                sumNights = book.Master_Booking_FK__r.Number_of_nights_master__c;
                            }
                            if(book.Master_Booking_FK__r.Rooms__c != null && book.Master_Booking_FK__r.Rooms__c != 0 && sumChambres == 0){
                                
                                sumChambres = book.Master_Booking_FK__r.Rooms__c;
                            }
                            
                            //Check if the number of nights of the booking is not null, then add it to the sumNights
                            if(book.Number_of_nights__c != null){
                                sumNights+= book.Number_of_nights__c;
                            }
                            
                            //Check if the number of rooms of the booking is not null, then add it to the sumChambres
                            if(book.Chambre__c != null){
                                
                                sumChambres+= book.Chambre__c;
                            }
                        }
                        //else if the MBs are not flagged, that means the batch is running all over again from the beginning, that means we have to do the calculations from zero
                        else{
                            system.debug('### cg tech nights false');
                            if(book.Number_of_nights__c != null){
                                
                                sumNights+= book.Number_of_nights__c;
                            }
                            
                            if(book.Chambre__c != null){
                                
                                sumChambres+= book.Chambre__c;
                            }
                        }
                    }
                    masterBook.Number_of_nights_master__c = sumNights;
                    masterBook.Rooms__c = sumChambres;
                    masterBook.TechIsNotFirst_01__c = true;
                    
                    //Add the masterbooking to the list to update
                    listMBsToUpdate.add(masterBook);
                }
                if(mapMBFlag != null && mapMBFlag.size() > 0 && mapMBFlag.containsKey(masterBook.id) && mapMBFlag.get(masterBook.id) == false){
                    masterBook.Number_of_nights_master__c = sumNights;
                    masterBook.Rooms__c = sumChambres;
                    masterBook.TechIsNotFirst_01__c = true;
                    
                    //Add the masterbooking to the list to update
                    listMBsToUpdate.add(masterBook);
                }
            }
        }
        
        return listMBsToUpdate;
    }
    
    //This method fills the number of StageName counts of a masterbooking according to its related bookings, called by updateMasterBooking
    public static list<opportunity> getStageCounts(Map<String, list<Opportunity>> mapMBlistBookings){
        system.debug('### cg mapMBlistBookings stage'+mapMBlistBookings);
        //List to return masterbookings to update
        list<opportunity> listMBsToUpdate = new list<opportunity>();
        
        //Loop over masterbookings in the map
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(string mbId : mapMBlistBookings.keyset()){
                
                Opportunity masterBook = new Opportunity();
                masterBook.Id = mbId;
                
                Decimal countBooked = 0;//sum of booked bookings on the masterbooking
                Decimal countChecked = 0;//sum of checked bookings on the masterbooking
                Decimal countCancelled = 0;//sum of cancelled bookings on the masterbooking
                Decimal countError = 0;//sum of error bookings on the masterbooking
                Decimal countNoShow = 0;//sum of no show bookings on the masterbooking
                
                if(mapMBlistBookings.get(mbId) != null && mapMBlistBookings.get(mbId).size()>0){
                    
                    for(Opportunity book : mapMBlistBookings.get(mbId)){
                        system.debug('### for book : mapMBlistBookings.get(mbId) ' + book );
                        //if the MBs are flagged, that means the batch hasn't finished running yet, so we need to add up the numbers in the calculations
                        if(book.Master_Booking_FK__r.TechIsNotFirst_01__c){
                            system.debug('### cg tech stage true' + book.StageName);
                            //We need to check these conditions in the first place, in order to not erase existing data on the fields in question
                            if(book.Master_Booking_FK__r.Bookings_Booked_Count__c != null && book.Master_Booking_FK__r.Bookings_Booked_Count__c != 0 && countBooked == 0){
                                
                                countBooked = book.Master_Booking_FK__r.Bookings_Booked_Count__c;
                            }
                            if(book.Master_Booking_FK__r.Bookings_Checked_Count__c != null && book.Master_Booking_FK__r.Bookings_Checked_Count__c != 0  && countChecked == 0){
                                
                                countChecked = book.Master_Booking_FK__r.Bookings_Checked_Count__c;
                            }
                            if(book.Master_Booking_FK__r.Bookings_Cancelled_Count__c != null && book.Master_Booking_FK__r.Bookings_Cancelled_Count__c != 0  && countCancelled == 0){
                                
                                countCancelled = book.Master_Booking_FK__r.Bookings_Cancelled_Count__c;
                            }
                            if(book.Master_Booking_FK__r.Bookings_Error_Count__c != null && book.Master_Booking_FK__r.Bookings_Error_Count__c != 0  && countError == 0){
                                
                                countError = book.Master_Booking_FK__r.Bookings_Error_Count__c;
                            }
                            if(book.Master_Booking_FK__r.Bookings_No_Show_Count__c != null && book.Master_Booking_FK__r.Bookings_No_Show_Count__c != 0  && countNoShow == 0){
                                
                                countNoShow = book.Master_Booking_FK__r.Bookings_No_Show_Count__c;
                            }
                            
                            //Then we proceed with the calculation
                            if(book.StageName == 'Booked'){
                                
                                countBooked++;
                            }
                            
                            else if(book.StageName == 'Cancelled'){
                                
                                countCancelled++;        }
                            
                            else if(book.StageName == 'Checked'){
                                
                                countChecked++;
                            }
                            
                            else if(book.StageName == 'Error'){
                                
                                countError++;
                            }
                            
                            else if(book.StageName == 'No Show'){
                                
                                countNoShow++;
                            }
                            
                            system.debug('countBooked not first ' + countBooked);
                            system.debug('countCancelled not first ' + countCancelled);
                            system.debug('countChecked not first ' + countChecked);
                            system.debug('countError not first ' + countError);
                            system.debug('countNoShow not first ' + countNoShow);
                        }
                        //else if the MBs are not flagged, that means the batch is running all over again from the beginning, that means we have to do the calculations from zero
                        else{
                            system.debug('### cg tech stage false' + book.StageName);
                            
                            if(book.StageName == 'Booked'){
                                
                                countBooked++;
                            }
                            else if(book.StageName == 'Cancelled'){
                                
                                countCancelled++;
                            }
                            else if(book.StageName == 'Checked'){
                                
                                countChecked++;
                            }
                            else if(book.StageName == 'Error'){
                                
                                countError++;
                            }
                            else if(book.StageName == 'No Show'){
                                
                                countNoShow++;
                            } 
                            
                            system.debug('countBooked ' + countBooked);
                            system.debug('countCancelled ' + countCancelled);
                            system.debug('countChecked ' + countChecked);
                            system.debug('countError ' + countError);
                            system.debug('countNoShow ' + countNoShow);
                        }
                    }
                    masterBook.Bookings_Booked_Count__c = countBooked;
                    masterBook.Bookings_Cancelled_Count__c = countCancelled;
                    masterBook.Bookings_Checked_Count__c = countChecked;
                    masterBook.Bookings_Error_Count__c = countError;
                    masterBook.Bookings_No_Show_Count__c = countNoShow;
                    masterBook.TechIsNotFirst_01__c = true;
                    //add the masterbooking to the list to update
                    listMBsToUpdate.add(masterBook);
                }
                if(mapMBFlag != null && mapMBFlag.size() > 0 && mapMBFlag.containsKey(masterBook.id) && mapMBFlag.get(masterBook.id) == false){
                    masterBook.Bookings_Booked_Count__c = countBooked;
                    masterBook.Bookings_Cancelled_Count__c = countCancelled;
                    masterBook.Bookings_Checked_Count__c = countChecked;
                    masterBook.Bookings_Error_Count__c = countError;
                    masterBook.Bookings_No_Show_Count__c = countNoShow;
                    masterBook.TechIsNotFirst_01__c = true;
                    system.debug('##### set values ' + masterBook);
                    //add the masterbooking to the list to update
                    listMBsToUpdate.add(masterBook);
                }
            }
        }
        
        return listMBsToUpdate;
    }
    
    //This method calls the above methods fillHotelName and fillConfirmationNb in order to update the masterbookings, called by OpportunityHandler 
    public static Map<String,String> updateMasterBooking(Map<String, list<Opportunity>> mapMBlistBookings){
        
        Database.SaveResult[] srListMB;//For dynamic Update
        Map<String,String> mapMBIdErrors = new Map<String,String>();
        
        map<string,opportunity> mapMBsToUpdate = new map<string, opportunity>();//map to retrieve all masterbookings to update
        
        list<opportunity> listMBwithNightsOrCham = new list<opportunity>();//list to be filled with fillConfirmationNb method
        list<opportunity> listMBwithStage = new list<Opportunity>();//list to be filled with fillHotelName method
        
        map<string, list<opportunity>> mapMBlistBookingsNightsOrCham = new map<string, list<opportunity>>();//map to be given as a parameter to fillConfirmationNb
        map<string, list<opportunity>> mapMBlistBookingsStage = new map<string, list<opportunity>>();//map to be given as a parameter to fillHotelName
        
        //Fill the maps with convenient Masterbookings
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(string mbId : mapMBlistBookings.keyset()){
                
                if(mapMBlistBookings.get(mbId) != null && mapMBlistBookings.get(mbId).size()>0){
                    
                    for(Opportunity book : mapMBlistBookings.get(mbId)){
                        
                        //fill the map mapMBlistBookingsNightsOrCham used to call getNightsAndRooms
                        if((book.Number_of_nights__c != null && book.Number_of_nights__c != 0) || (book.Chambre__c != null && book.Chambre__c != 0)){
                            
                            if(!book.IsDeleted){
                                
                                if(!mapMBlistBookingsNightsOrCham.containsKey(mbId)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(book);
                                    mapMBlistBookingsNightsOrCham.put(mbId,listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut = mapMBlistBookingsNightsOrCham.get(mbId);
                                    listToPut.add(book);
                                    mapMBlistBookingsNightsOrCham.put(mbId,listToPut);
                                }
                                system.debug('### cg mapMBlistBookingsNightsOrCham not deleted'+mapMBlistBookingsNightsOrCham);
                            }
                            else{
                                
                                if(!mapMBlistBookingsNightsOrCham.containsKey(mbId)){
                                    
                                    mapMBlistBookingsNightsOrCham.put(mbId, new list<Opportunity>());
                                }
                                else{
                                    
                                    mapMBlistBookingsNightsOrCham.put(mbId, mapMBlistBookingsNightsOrCham.get(mbId));
                                } system.debug('### cg mapMBlistBookingsNightsOrCham  deleted'+mapMBlistBookingsNightsOrCham);
                            }
                        }
                        
                        //fill the map mapMBlistBookingsStage used to call getStageCounts
                        if(book.StageName != null && book.StageName != '' && string.isNotBlank(book.StageName)){
                            
                            if(!book.IsDeleted){
                                
                                if(!mapMBlistBookingsStage.containsKey(mbId)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(book);
                                    mapMBlistBookingsStage.put(mbId,listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut = mapMBlistBookingsStage.get(mbId);
                                    listToPut.add(book);
                                    mapMBlistBookingsStage.put(mbId,listToPut);
                                }
                                system.debug('### cg mapMBlistBookingsStage not deleted'+mapMBlistBookingsStage);
                            }
                            else{
                                
                                if(!mapMBlistBookingsStage.containsKey(mbId)){
                                    
                                    mapMBlistBookingsStage.put(mbId, new list<Opportunity>());
                                }
                                else{
                                    
                                    mapMBlistBookingsStage.put(mbId, mapMBlistBookingsStage.get(mbId));
                                } system.debug('### cg mapMBlistBookingsStage deleted'+mapMBlistBookingsStage);
                            }
                        }
                    }
                }
            }
        }
        
        //get the masterbooking' number of nights and rooms calculated
        if(mapMBlistBookingsNightsOrCham != null && mapMBlistBookingsNightsOrCham.size()>0){
            
            listMBwithNightsOrCham = getNightsAndRooms(mapMBlistBookingsNightsOrCham);
            
            if(listMBwithNightsOrCham != null && listMBwithNightsOrCham.size()>0){
                
                for(Opportunity mbOpp : listMBwithNightsOrCham){
                    
                    mapMBsToUpdate.put(mbOpp.Id, mbOpp);
                }
            }
        }
        
        //get the masterbooking' stage counts calculated
        if(mapMBlistBookingsStage != null && mapMBlistBookingsStage.size()>0){
            
            listMBwithStage = getStageCounts(mapMBlistBookingsStage);
            
            if(listMBwithStage != null && listMBwithStage.size()>0){
                
                for(Opportunity mbOpp : listMBwithStage){
                    
                    if(!mapMBsToUpdate.containsKey(mbOpp.Id)){
                        
                        mapMBsToUpdate.put(mbOpp.Id, mbOpp);
                    }
                    else{
                        
                        mbOpp.Number_of_nights_master__c = mapMBsToUpdate.get(mbOpp.Id).Number_of_nights_master__c;
                        mbOpp.Rooms__c = mapMBsToUpdate.get(mbOpp.Id).Rooms__c;
                        mapMBsToUpdate.put(mbOpp.Id, mbOpp);
                    }
                }
            }
        }
        system.debug('### mapMBsToUpdate ' +  mapMBsToUpdate);
        
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