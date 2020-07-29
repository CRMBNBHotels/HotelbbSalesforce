/*
* Description: CRMSS-249-250-251-252-253 to count the number of bookings of certain stages on a masterbooking  
               CRMSS-264-284 to fill the confirmation number on a master booking according to its bookings' confirmation number
               CRMSS-292 to fill the hotel name on a master booking according to its bookings' hotel name
               CRMSS-247 to fill the number of nights on a master booking with the sum of nights of its related bookings 
               CRMSS-248 to fill the number of rooms on a master booking with the sum of rooms of its related bookings
* @author: TMA-EIL Cynthia Geagea
* @date: 06/08/2019
* @Test class: AP10_Opportunity_Test 
* @Coverage: 81 %
*/


public without sharing class AP10_Opportunity {
    
    public static void updateMasterBookingStageNameOrConfrmNumb(list<Opportunity> listNewOpp , map<Id,Opportunity> oldMapOpp){
        
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        
        //map to store MBs with StageName Count to update
        map<string,map<string,string>> mapBookingMasterBookings = new map<string,map<string,string>>();
        
        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
        //map to store MBs with Confirmation number to update
        map<string,list<Opportunity>> mapMBlistBookings = new map<string,list<Opportunity>>();
        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
        
        //Added by TMA Ei JK - CRMSS 287  - Start
        //map to store MBs with room Count to update
        List<Opportunity> InsertListOpp = new List<Opportunity>();
        List<Opportunity> DeleteListOpp = new List<Opportunity>();
        List<Opportunity> UpdateListOpp = new List<Opportunity>();
        Map<id,Opportunity> MapOppCalculated = new Map<id,Opportunity>();
        //Added by TMA Ei JK - CRMSS 287  - End
                
        //Added by TMA EI JK CRMSS - 292 Merge Start
        Map<String, list<Opportunity>> MapBookingByMB = new   Map<String, list<Opportunity>>();
        //Added by TMA EI JK CRMSS - 292 Merge End
                
        //Added by NA
        Map<Id, list<Opportunity>> mapMbToBooking = new Map<Id, list<Opportunity>>();
        
        if(listNewOpp != null && listNewOpp.size()>0){
            
            for(Opportunity opp : listNewOpp){
                
                if(opp.RecordTypeId == bookingRTId){
                    
                    //Insert Case
                    if(oldMapOpp == null){
                        
                        if(opp.Master_Booking_FK__c != null && !string.isBlank(opp.Master_Booking_FK__c)){
                            
                            //Added by TMA-EI JK CRMSS-292 Merge Start
                            if(opp.Hotel_Name__c != null){
                                MapBookingByMB.put(opp.Master_Booking_FK__c, new list<opportunity>());
                            }
                            //Added by TMA-EI JK CRMSS-292 Merge End + NAT INSERT AP11
                            //Added by NA
                            if(opp.Number_of_nights__c != null){
                                mapMbToBooking.put(opp.Master_Booking_FK__c, new List<Opportunity>());
                            }
                            //Added by NA
                            
                            //StageName
                            if(opp.StageName != null && !string.isBlank(opp.StageName)){
                                
                                map<string, string> mapToPut = new map<string,string>();
                                mapToPut.put(opp.Master_Booking_FK__c, opp.StageName);
                                mapBookingMasterBookings.put(opp.id, mapToPut);
                            }
                            //Added by TMA-EI JK CRMSS-287 Start
                            if(opp.Chambre__c != null){
                                InsertListOpp.add(opp);
                            }
                            //Added by TMA-EI JK CRMSS-287 End
                            
                            //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
                            //Confirmation Number
                            if(opp.Confirmation_Number__c != null && !string.isBlank(opp.Confirmation_Number__c)){
                                
                                if(!mapMBlistBookings.ContainsKey(opp.Master_Booking_FK__c)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(opp);
                                    mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut  = mapMBlistBookings.get(opp.Master_Booking_FK__c);
                                    listToPut.add(opp);
                                    mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                }
                            }
                            //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
                            
                        }
                    }
                    
                    //Update Case
                    else if(oldMapOpp != null && opp.recordTypeId == bookingRTId){
                        //Added by TMA-EI JK CRMSS-292 Merge Start
                        if((opp.Master_Booking_FK__c != null && opp.Hotel_Name__c != oldMapOpp.get(opp.id).Hotel_Name__c) || (opp.Hotel_Name__c != null && opp.Master_Booking_FK__c != oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                            
                            if(opp.Master_Booking_FK__c != null && !string.isBlank(opp.Master_Booking_FK__c)){
                                MapBookingByMB.put(opp.Master_Booking_FK__c, new list<opportunity>());
                            }
                            if(oldMapOpp.get(opp.id).Master_Booking_FK__c != null && !string.isBlank(oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                                MapBookingByMB.put(oldMapOpp.get(opp.id).Master_Booking_FK__c, new list<opportunity>());// we must take into consideration updating the old master booking also 
                            }
                        }
                        //Added by TMA-EI JK CRMSS-292 Merge End
                        //Added by TMA-EI JK CRMSS-287 Start
                        if((opp.Master_Booking_FK__c != null && opp.Chambre__c != oldMapOpp.get(opp.id).Chambre__c) || (opp.Chambre__c != null && opp.Master_Booking_FK__c != oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                            UpdateListOpp.add(opp);
                        }
                        //Added by TMA-EI JK CRMSS-287 End
                        //StageName
                        if((((opp.Master_Booking_FK__c != null && !string.isBlank(opp.Master_Booking_FK__c)) || (opp.Master_Booking_FK__c == null && oldMapOpp.get(opp.id).Master_Booking_FK__c != null && !string.isBlank(oldMapOpp.get(opp.id).Master_Booking_FK__c))) 
                            && ((opp.StageName != null && !string.isBlank(opp.StageName)) || (opp.StageName == null && oldMapOpp.get(opp.id).StageName != null && !string.isBlank(oldMapOpp.get(opp.id).StageName)))  ) 
                           || (opp.StageName != oldMapOpp.get(opp.id).StageName || opp.Master_Booking_FK__c != oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                               map<string, string> mapToPut = new map<string,string>();
                               if(opp.Master_Booking_FK__c != null && !string.isBlank(opp.Master_Booking_FK__c)){
                                   mapToPut.put(opp.Master_Booking_FK__c, opp.StageName);
                               }
                               if(oldMapOpp.get(opp.id).Master_Booking_FK__c != null && !string.isBlank(oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                                   mapToPut.put(oldMapOpp.get(opp.id).Master_Booking_FK__c, oldMapOpp.get(opp.id).StageName);
                               }
                               mapBookingMasterBookings.put(opp.id, mapToPut);
                           }
                        //Added by NA
                        if((opp.Master_Booking_FK__c != null && oldMapOpp.get(opp.id).Number_of_nights__c != opp.Number_of_nights__c) || (opp.Number_of_nights__c != null && opp.Master_Booking_FK__c != oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                            
                            if(opp.Master_Booking_FK__c != null && !string.isBlank(opp.Master_Booking_FK__c)){
                                
                                mapMbToBooking.put(opp.Master_Booking_FK__c, new List<Opportunity>());   
                            }
                            if(oldMapOpp.get(opp.id).Master_Booking_FK__c != null && !string.isBlank(oldMapOpp.get(opp.id).Master_Booking_FK__c)){// we must take into consideration updating the old master booking also  
                                
                                mapMbToBooking.put(oldMapOpp.get(opp.id).Master_Booking_FK__c, new List<Opportunity>()); 
                            }
                        }
                        //Added by NA
                        
                        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
                        //Confirmation Number: we take into consideration the case of updating the MasterBooking only, since the confirmation number is never modified and never null
                        if(opp.Master_Booking_FK__c != oldMapOpp.get(opp.id).Master_Booking_FK__c && opp.Confirmation_Number__c != null && !string.isBlank(opp.Confirmation_Number__c)){
                            
                            if(opp.Master_Booking_FK__c != null && !string.isBlank(opp.Master_Booking_FK__c)){
                                if(!mapMBlistBookings.ContainsKey(opp.Master_Booking_FK__c)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(opp);
                                    mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut  = mapMBlistBookings.get(opp.Master_Booking_FK__c);
                                    listToPut.add(opp);
                                    mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                } 
                            }
                            
                            if(oldMapOpp.get(opp.id).Master_Booking_FK__c != null && !string.isBlank(oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                                
                                if(!mapMBlistBookings.ContainsKey(oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    //listToPut.add(opp);
                                    mapMBlistBookings.put(oldMapOpp.get(opp.id).Master_Booking_FK__c, listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut  = mapMBlistBookings.get(oldMapOpp.get(opp.id).Master_Booking_FK__c);
                                    //listToPut.add(opp);
                                    mapMBlistBookings.put(oldMapOpp.get(opp.id).Master_Booking_FK__c, listToPut);
                                } 
                            }  
                        } 
                        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
                    } 
                }
            }
        }
        
        //Delete Case
        else if(listNewOpp == null && oldMapOpp != null && oldMapOpp.size()>0){
            
            for(String oppId : oldMapOpp.keySet()){
                
                if(oldMapOpp.get(oppId).recordTypeId == bookingRTId){
                    
                    if(oldMapOpp.get(oppId).Master_Booking_FK__c != null && !string.isBlank(oldMapOpp.get(oppId).Master_Booking_FK__c)){
                        
                        //Added by TMA-EI JK CRMSS-292 Merge Start
                        if(oldMapOpp.get(oppId).Hotel_Name__c != null){
                            MapBookingByMB.put(oldMapOpp.get(oppId).Master_Booking_FK__c, new list<opportunity>());
                        }
                        //Added by TMA-EI JK CRMSS-292 Merge End
                        
                        //Added by NA
                        if(oldMapOpp.get(oppId).Number_of_nights__c != null){
                            
                            mapMbToBooking.put(oldMapOpp.get(oppId).Master_Booking_FK__c, new List<Opportunity>());
                        }
                        //Added by NA
                        
                        //Added by TMA-EI JK CRMSS-287 Start
                        if(oldMapOpp.get(oppId).Chambre__c != null){
                            DeleteListOpp.add(oldMapOpp.get(oppId));
                        }
                        //Added by TMA-EI JK CRMSS-287 End
                        
                        //StageName
                        if(oldMapOpp.get(oppId).StageName != null && !string.isBlank(oldMapOpp.get(oppId).StageName)){
                            
                            map<string, string> mapToPut = new map<string,string>();
                            mapToPut.put(oldMapOpp.get(oppId).Master_Booking_FK__c, oldMapOpp.get(oppId).StageName);
                            mapBookingMasterBookings.put(oppId, mapToPut);
                        }
                        
                        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
                        //Confirmation Number
                        if(oldMapOpp.get(oppId).Confirmation_Number__c != null && !string.isBlank(oldMapOpp.get(oppId).Confirmation_Number__c)){
                            
                            if(!mapMBlistBookings.ContainsKey(oldMapOpp.get(oppId).Master_Booking_FK__c)){
                                
                                list<Opportunity> listToPut = new list<Opportunity>();
                                //listToPut.add(oldMapOpp.get(oppId));
                                mapMBlistBookings.put(oldMapOpp.get(oppId).Master_Booking_FK__c, listToPut);
                            }
                            else{
                                
                                list<Opportunity> listToPut  = mapMBlistBookings.get(oldMapOpp.get(oppId).Master_Booking_FK__c);
                                //listToPut.add(oldMapOpp.get(oppId));
                                mapMBlistBookings.put(oldMapOpp.get(oppId).Master_Booking_FK__c, listToPut);
                            }  
                        }
                        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
                    }
                }
            }
        }
        
        //call method AP13
        if((InsertListOpp != null && InsertListOpp.size()>0) || (DeleteListOpp != null && DeleteListOpp.size()>0) || (UpdateListOpp != null && UpdateListOpp.size()>0)){
            
            MapOppCalculated = Ap13_Opportunity.CalculateRoom(InsertListOpp,DeleteListOpp,UpdateListOpp,oldMapOpp);
        }
        set<string> setMbFromMap = new set<String>();
        
        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
        Set<ID> setMBID = new Set<ID>();
        map<String, Opportunity> mapMBtoUpdate = new map<string, Opportunity>();
        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
        
        list<Opportunity> listMbToUpdate = new list<Opportunity>();
        
        if(mapBookingMasterBookings != null && mapBookingMasterBookings.size()>0){
            
            for(Map<String,String> mapMbId : mapBookingMasterBookings.values()){
                
                for(string mbId : mapMbId.keyset()){
                    
                    setMbFromMap.add(mbId);
                }
            }
        }
        
        map<String, Integer> mapMbCountCancelled = new map<string,Integer>();
        map<String, Integer> mapMbCountError = new map<string,Integer>();
        map<String, Integer> mapMbCountNoShow = new map<string,Integer>();
        map<String, Integer> mapMbCountChecked = new map<string,Integer>();
        map<String, Integer> mapMbCountBooked = new map<string,Integer>();
        
        set<String> setToAvoidDuplicate = new Set<string>();
        
        //Added by TMA-EI JK to resolve Too Many DML
        IF((setMbFromMap != null && setMbFromMap.size()>0) || (mapMBlistBookings != null && mapMBlistBookings.size()>0) || (MapBookingByMB != null && MapBookingByMB.size()>0) || (mapMbToBooking != null && mapMbToBooking.size()>0)){
        
            for(Opportunity book : [select id, Master_Booking_FK__c, StageName, RecordTypeId, Confirmation_Number__c, Master_Booking_FK__r.Confirmation_Number__c,Hotel_Name__c,Master_Booking_FK__r.Hotel_Name_MB__c,Number_of_nights__c
                                from Opportunity 
                                where RecordTypeId =: bookingRTId and 
                                ((StageName!= null and (Master_Booking_FK__c IN : setMbFromMap OR Master_Booking_FK__c IN : mapMBlistBookings.keySet()))or 
                                 (Master_Booking_FK__c IN : MapBookingByMB.keySet() and Hotel_Name__c!= null)
                                 //Added by NA
                                 OR Master_Booking_FK__c IN : mapMbToBooking.keySet()
                                 //Added by NA
                                )]){
                                    
                                    //Added by TMA EI JK CRMSS 292 Merge Start
                                    If(book.Hotel_Name__c != null && MapBookingByMB.containskey(book.Master_Booking_FK__c)){
                                        
                                        list<Opportunity> listToPut  = MapBookingByMB.get(book.Master_Booking_FK__c);
                                        listToPut.add(book);
                                        MapBookingByMB.put(book.Master_Booking_FK__c, listToPut); 
                                    }
                                    //Added by TMA EI JK CRMSS 292 Merge End                                    
                                    
                                    //Added by NA
                                    if(book.Number_of_nights__c != null && mapMbToBooking.containsKey(book.Master_Booking_FK__c)){
                                        
                                        list<Opportunity> listToPut  = mapMbToBooking.get(book.Master_Booking_FK__c);
                                        listToPut.add(book);
                                        mapMbToBooking.put(book.Master_Booking_FK__c, listToPut);
                                    }
                                    //Added by NA
                                    
                                    if(setMbFromMap.contains(book.Master_Booking_FK__c)){
                                        
                                        if(book.StageName!= null  && book.StageName == Label.StageNameBooking_Cancelled){
                                            integer count = 0;
                                            if(!mapMbCountCancelled.ContainsKey(book.Master_Booking_FK__c)){
                                                
                                                count++;
                                                mapMbCountCancelled.put(book.Master_Booking_FK__c, count);
                                            }
                                            else{
                                                
                                                count = mapMbCountCancelled.get(book.Master_Booking_FK__c);
                                                count++;
                                                mapMbCountCancelled.put(book.Master_Booking_FK__c, count);
                                            }
                                            
                                        }
                                        else if(book.StageName!= null && book.StageName == Label.StageNameBooking_Error){
                                            
                                            integer count = 0;
                                            if(!mapMbCountError.ContainsKey(book.Master_Booking_FK__c)){
                                                
                                                count++;
                                                mapMbCountError.put(book.Master_Booking_FK__c, count);
                                            }
                                            else{
                                                
                                                count = mapMbCountError.get(book.Master_Booking_FK__c);
                                                count++;
                                                mapMbCountError.put(book.Master_Booking_FK__c, count);
                                            }
                                            
                                        }
                                        else if(book.StageName!= null && book.StageName == Label.StageNameBooking_NoShow){
                                            
                                            integer count = 0;
                                            if(!mapMbCountNoShow.ContainsKey(book.Master_Booking_FK__c)){
                                                
                                                count++;
                                                mapMbCountNoShow.put(book.Master_Booking_FK__c, count);
                                            }
                                            else{
                                                
                                                count = mapMbCountNoShow.get(book.Master_Booking_FK__c);
                                                count++;
                                                mapMbCountNoShow.put(book.Master_Booking_FK__c, count);
                                            }
                                            
                                        }
                                        else if(book.StageName!= null && book.StageName == Label.StageNameBooking_Checked){
                                            
                                            integer count = 0;
                                            if(!mapMbCountChecked.ContainsKey(book.Master_Booking_FK__c)){
                                                
                                                count++;
                                                mapMbCountChecked.put(book.Master_Booking_FK__c, count);
                                            }
                                            else{
                                                
                                                count = mapMbCountChecked.get(book.Master_Booking_FK__c);
                                                count++;
                                                mapMbCountChecked.put(book.Master_Booking_FK__c, count);
                                            }
                                            
                                        }
                                        else if(book.StageName!= null && book.StageName == Label.StageNameBooking_Booked){
                                            
                                            integer count = 0;
                                            if(!mapMbCountBooked.ContainsKey(book.Master_Booking_FK__c)){
                                                
                                                count++;
                                                mapMbCountBooked.put(book.Master_Booking_FK__c, count);
                                            }
                                            else{
                                                
                                                count = mapMbCountBooked.get(book.Master_Booking_FK__c);
                                                count++;
                                                mapMbCountBooked.put(book.Master_Booking_FK__c, count);
                                            }
                                            
                                        }
                                    }
                                    
                                    //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
                                    //If the MasterBooking's confirmation number is null, then we assign the first booking's confirmation number in the list of mapMBlistBookings to it, since all the bookings' confirmation numbers are the same
                                    if(mapMBlistBookings.containsKey(book.Master_Booking_FK__c)){
                                        
                                        if(book.Master_Booking_FK__r.Confirmation_Number__c == null && string.isBlank(book.Master_Booking_FK__r.Confirmation_Number__c)){
                                            
                                            Opportunity MB = new Opportunity();
                                            MB.id = book.Master_Booking_FK__c;
                                            
                                            if(mapMBlistBookings.get(book.Master_Booking_FK__c) != null && mapMBlistBookings.get(book.Master_Booking_FK__c).size()>0){
                                                
                                                MB.Confirmation_Number__c = mapMBlistBookings.get(book.Master_Booking_FK__c)[0].Confirmation_Number__c;
                                            }
                                            
                                            If(!setMBID.contains(MB.id)){
                                                
                                                mapMBtoUpdate.put(MB.Id, MB);
                                            }
                                            
                                            if(!setMBID.contains(book.Master_Booking_FK__c)){
                                                
                                                setMBID.add(book.Master_Booking_FK__c);
                                            }
                                        }
                                        
                                        //Only in the case where we have a MasterBooking with only one booking attached, if we remove this booking from the MasterBooking, then the confirmation number of the latter must be set to null
                                        else {
                                            
                                            if(!setMBID.contains(book.Master_Booking_FK__c)){
                                                
                                                setMBID.add(book.Master_Booking_FK__c);
                                            }
                                        }
                                    }
                                    //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
                                    
                                }
        }
        
        //Added by TMA EI JK CRMSS 292 Merge Start
         /* if(MapBookingByMB != null && MapBookingByMB.size()>0){
            
          List<Opportunity> ListOppToUpdate  = AP12_Opportunity.fillHotelName(MapBookingByMB);
            Opportunity OppToUpdate = new Opportunity();
            
            for(Opportunity opp:ListOppToUpdate){
                
                OppToUpdate = opp;
                
                if(mapMBtoUpdate.containskey(opp.id)){
                    
                    OppToUpdate = mapMBtoUpdate.get(opp.id);
                    OppToUpdate.Hotel_Name_MB__c = opp.Hotel_Name_MB__c;
                }
                mapMBtoUpdate.put(OppToUpdate.id,OppToUpdate);
            }
        }*/
        //Added by TMA EI JK CRMSS 292 Merge End
        
        //Added by NA
       /*   If(mapMbToBooking != null && mapMbToBooking.size()>0){
            
          List<Opportunity> masterBookings = AP11_Opportunity.updateNumberOfNightsOnMasterBooking(mapMbToBooking);
            Opportunity OppToUpdate = new Opportunity();
            
            if(masterBookings != null && masterBookings.size()>0){
                
                for(Opportunity mbObj : masterBookings){
                    
                    OppToUpdate = mbObj;
                    
                    if(mapMBtoUpdate.containskey(mbObj.Id)){
                        
                        OppToUpdate = mapMBtoUpdate.get(mbObj.Id);
                        OppToUpdate.Number_of_nights_master__c = mbObj.Number_of_nights_master__c;
                    }
                    
                    if(mapMbToBooking.containsKey(mbObj.Id)){
                        
                        if(mapMbToBooking.get(mbObj.Id) != null && mapMbToBooking.get(mbObj.Id).size()>0){
                            
                            OppToUpdate.Confirmation_Number__c = mapMbToBooking.get(mbObj.Id)[0].Confirmation_Number__c;
                            OppToUpdate.Hotel_Name_MB__c = mapMbToBooking.get(mbObj.Id)[0].Hotel_Name__c;
                        }
                    }
                    
                    mapMBtoUpdate.put(OppToUpdate.id,OppToUpdate);
                }        
            }

        }*/
        //Added by NA
        
                      
        //When deleting the last booking holding a certain StageName, we need to make sure that the count is set to zero (the MB of such a booking is not retrieved in the querry above, cz the booking is deleted, and the trigger is after delete)
        for(Map<String,String> mapMbId : mapBookingMasterBookings.values()){
            
            for(string mbId : mapMbId.keyset()){
                
                if(mbId != null && !string.isBlank(mbId)){
                    
                    if(mapMbId.get(mbId) == Label.StageNameBooking_Cancelled && !mapMbCountCancelled.containsKey(mbId)){
                        
                        mapMbCountCancelled.put(mbId, 0);
                    }
                    else if(mapMbId.get(mbId) == Label.StageNameBooking_Error && !mapMbCountError.containsKey(mbId)){
                        
                        mapMbCountError.put(mbId, 0);
                    }
                    else if(mapMbId.get(mbId) == Label.StageNameBooking_NoShow && !mapMbCountNoShow.containsKey(mbId)){
                        
                        mapMbCountNoShow.put(mbId, 0);
                    }
                    else if(mapMbId.get(mbId) == Label.StageNameBooking_Checked && !mapMbCountChecked.containsKey(mbId)){
                        
                        mapMbCountChecked.put(mbId, 0);
                    }
                    else if(mapMbId.get(mbId) == Label.StageNameBooking_Booked && !mapMbCountBooked.containsKey(mbId)){
                        
                        mapMbCountBooked.put(mbId, 0);
                    }
                    
                }
            }
            
        }
        
        for(String mbId : setMbFromMap){
            
            if(mbId != null && !string.isBlank(mbId)){
                
                Opportunity mbOpp = new Opportunity();
                mbOpp.id = mbId;
                
                //We need to check whether the map to update contains this id, if so we need to update the Confirmation number field since we are creating a new Opp with the same id, so we need to avoid that the data in this fields gets earased
                if(mapMBtoUpdate.containsKey(mbId)){
                    
                    mbOpp.Confirmation_Number__c = mapMBtoUpdate.get(mbId).Confirmation_Number__c;
                    mbOpp.Hotel_Name_MB__c = mapMBtoUpdate.get(mbId).Hotel_Name_MB__c; // CRMSS - 292
                    mbOpp.Number_of_nights_master__c = mapMBtoUpdate.get(mbId).Number_of_nights_master__c;
                }
                
                if(mapMbCountCancelled.containsKey(mbId)){
                    
                    mbOpp.Bookings_Cancelled_Count__c = mapMbCountCancelled.get(mbId);
                }
                
                if(mapMbCountError.containsKey(mbId)){
                    
                    mbOpp.Bookings_Error_Count__c = mapMbCountError.get(mbId);
                }
                
                if(mapMbCountNoShow.containsKey(mbId)){
                    
                    mbOpp.Bookings_No_Show_Count__c = mapMbCountNoShow.get(mbId);
                }
                
                if(mapMbCountChecked.containsKey(mbId)){
                    
                    mbOpp.Bookings_Checked_Count__c = mapMbCountChecked.get(mbId);
                }
                
                if(mapMbCountBooked.containsKey(mbId)){
                    
                    mbOpp.Bookings_Booked_Count__c = mapMbCountBooked.get(mbId);
                }
                
                mapMBtoUpdate.put(mbOpp.Id, mbOpp);
            } 
        }
        
        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - Start
        //When deleting / updating the last booking on a master booking, we need to empty its confirmation number
        for(Id MBID : mapMBlistBookings.keySet()){
            
            if(!setMBID.contains(MBID)){
                
                Opportunity MB = new Opportunity();
                MB.id = MBID;
                
                //We need to check whether the map to update contains this id, if so we need to update the Counts fields since we are creating a new Opp with the same id, so we need to avoid that the data in these fields gets earased
                if(mapMBtoUpdate.containskey(MBID)){
                    
                    MB.Bookings_Cancelled_Count__c = mapMBtoUpdate.get(MBID).Bookings_Cancelled_Count__c;
                    MB.Bookings_Error_Count__c = mapMBtoUpdate.get(MBID).Bookings_Error_Count__c;
                    MB.Bookings_No_Show_Count__c = mapMBtoUpdate.get(MBID).Bookings_No_Show_Count__c;
                    MB.Bookings_Checked_Count__c = mapMBtoUpdate.get(MBID).Bookings_Checked_Count__c;
                    MB.Bookings_Booked_Count__c = mapMBtoUpdate.get(MBID).Bookings_Booked_Count__c;
                    MB.Hotel_Name_MB__c = mapMBtoUpdate.get(MBID).Hotel_Name_MB__c;
                    MB.Number_of_nights_master__c = mapMBtoUpdate.get(MBID).Number_of_nights_master__c;
                }
                
                MB.Confirmation_Number__c = '';
                
                mapMBtoUpdate.put(MB.Id, MB);
            }
        }
        
        for(Opportunity opp : MapOppCalculated.values()){
            
            Opportunity oppToUpdate = new Opportunity();
            
            if(mapMBtoUpdate.containskey(opp.id)){
                
                oppToUpdate = mapMBtoUpdate.get(opp.id);
                oppToUpdate.Rooms__c = opp.Rooms__c;
            }
            else{
                
                oppToUpdate = opp;
            }
            mapMBtoUpdate.put(opp.Id, oppToUpdate);
        }
        update mapMBtoUpdate.values();
        //Added by TMA Cynthia Geagea - CRMSS 264 - 284 - 12/09/2019 - End
        
    }
}