/**
* @description webservice used by BBUS to insert/modify BookingInfo : Master Booking - Booking - Person Account - Booking Room Lines
* @author TMA Cynthia Geagea
* @date 20/09/2019
* @Test: WS02_BookingInfo_Test
* @Coverage: 80%
*/

global without sharing class WS02_BookingInfo {
    
    static Map<String, Map<String, Booking_Room_Line__c>> mapBookingRoomLinesByExternalId = new  Map<String, Map<String, Booking_Room_Line__c>>();
    static Map<String, Booking_Room_Line__c> mapBRToUpdate = new Map<String, Booking_Room_Line__c>();
    
    //Added by Cynthia Geagea ACT-795 30/10/2019 Start
    static Map<String, list<PersonAccount>> mapBookingIdListPA = new Map<String, list<PersonAccount>>();
    //Added by Cynthia Geagea ACT-795 30/10/2019 End
    
    //maps used for the CRMSS-160 demand, in order to use for matchGuestAccount method
    static Map<String,String> mapEmailSFID = new Map<String,String>();
    static Map<String,String> mapExtIDSFID = new Map<String,String>();
    
    //Add for logs Start
    Static boolean FromBookingInfo = false;
    //Add for logs End
    
    webservice static List<BookingInfoUpsertResponse> doUpsertBookingInfos(BookingInfos BookingInfos ) {
        UtilsBypass.addSkipApexClass('Account_Handle', 'CPU Time');
        FromBookingInfo = true;
        
        /*Commented by TMA-EIL CRMSS-579 16/04/2020 
        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
        //
        //Add for logs Start
        Log__c log = new Log__c();
        log.WSName__c = 'Booking Info';
        if(Json.serialize(BookingInfos).length()>131072){
            log.JsonMessage__c = Json.serialize(BookingInfos).substring(0,131072);
        }else{
            log.JsonMessage__c = Json.serialize(BookingInfos);
        }
        system.debug('Limits.getDmlStatements() 1 ## ' + Limits.getDmlStatements());
        
        insert log;
        Attachment  doc = new Attachment ();
        doc.Name = 'JsonLog';  
        doc.Body = Blob.valueOf(Json.serialize(BookingInfos));
        doc.ContentType = 'text/plain';
        doc.ParentId = log.id;
        insert doc;        
        //Add for logs End
        //Added by Cynthia Geagea ACT-795 30/10/2019 End
        */
        
        System.debug('##### doUpsertBookingInfos ' + BookingInfos);
        Integer rowIndex = 0; //This index will be returned to BBUS to count the number of responses sent back to them 
        String strMasterExternalId; //This is the Master Booking's external id that will be sent back to BBUS
        
        Map<Integer, BookingInfoUpsertResponse> mapIndexListResponses = new Map<Integer, BookingInfoUpsertResponse>(); //In this map we will store all responses to send back to BBUS
        
        BookingInfo.MasterBookingWrapper masterBookingWrap;
        List<BookingInfo.BookingWrapper> listBookingWrap;
        MasterBooking masterBooking;
        
        // Each one of these lists is used to retrieve data sent in the BookingInfo 
        //Added by TMA-JK - CRMSS-173 Start
        list<BookingRoomLine> listBookingRoomLinesParent = new list<BookingRoomLine>(); 
        //Added by TMA-JK - CRMSS-173 End
        list<BookingRoomLine> listBookingRoomLines = new list<BookingRoomLine>(); 
        list<Booking> listBookings = new list<Booking>();
        list<MasterBooking> listMasterBookings = new list<MasterBooking>();	
        list<PersonAccount> listGuestAccounts = new list<PersonAccount>();
        
        map<String, String> mapObjIdMbId = new map<string, string>(); // used to map every object's extID with the MB's ExtId attached to it
        map<String, Integer> mapMBExtIdRowIndex = new map<String, Integer>(); //used store each MB extID with a row Index, to be able to sort the responses before sending them back to BBUS
        
        //Sets used to check for exixting BRLs in SF that are being sent also by the WS
        set<String> setExistingBookingsExtId = new set<String>();
        set<string> setBookingRLFmWS = new set<string>();
        
        //Sets used for the CRMSS-160 demand, in order to use for matchGuestAccount method
        set<String> setPersonAccountEmail = new set<String>();
        set<String> setPersonAccountExtID = new set<String>();
        
        // Each one of these lists is used to store the response of each doUpsert function
        List<UpsertResponse> listMBResponses = new List<UpsertResponse>();
        List<UpsertResponse> listBResponses = new List<UpsertResponse>();
        List<UpsertResponse> listBRLResponses = new List<UpsertResponse>();
        List<UpsertResponse> listPAResponses = new List<UpsertResponse>();
        
        for(BookingInfo bookinginfo : BookingInfos.BookingInfo){
            system.debug('### cg bookinginfo'+bookinginfo);
            masterBookingWrap = bookinginfo.MasterBookingWrapper;
            listBookingWrap = masterBookingWrap.BookingWrapper;
            masterBooking = masterBookingWrap.MasterBooking;
            
            if(listBookingWrap != null && listBookingWrap.size() > 0){
                
                //For each booking in the bookingInfo, we will retrieve the Booking's external Id and the Booking room line's external id 
                for(BookingInfo.BookingWrapper bookingWrap : listBookingWrap){
                    
                    string masterBookId;
                    
                    if(masterBooking != null && masterBooking.ExternalId != null){
                        
                        masterBookId = masterBooking.ExternalId;
                    }
                    
                    if(bookingWrap.Booking != null && bookingWrap.Booking.ExternalId != null){
                        
                        String BookID = bookingWrap.Booking.ExternalId;
                        
                        if(masterBookId != null && !string.isBlank(masterBookId)){
                            
                            bookingWrap.Booking.MasterBooking = masterBookId;
                        }
                        
                        listBookings.add(bookingWrap.Booking);
                        setExistingBookingsExtId.add(bookingWrap.Booking.ExternalId);
                        
                        if(!mapObjIdMbId.containsKey(bookingWrap.Booking.ExternalId)){
                            
                            mapObjIdMbId.put(bookingWrap.Booking.ExternalId, masterBooking.ExternalId);
                        }
                        
                        if(bookingWrap.BookingRoomLines != null){
                            
                            for(BookingRoomLine bookingrl : bookingWrap.BookingRoomLines) {
                                
                                if(bookingrl.ExternalId != null){
                                    
                                    bookingrl.booking = BookID;
                                    //Added by TMA-JK - CRMSS-173 Start
                                    if(bookingrl.RoomLineParent == null || String.isEmpty(bookingrl.RoomLineParent)){
                                        listBookingRoomLinesParent.add(bookingrl);
                                    }
                                    //Added by TMA-JK - CRMSS-173 End
                                    else{
                                        listBookingRoomLines.add(bookingrl); 
                                    }
                                    
                                    
                                    setBookingRLFmWS.add(bookingrl.ExternalId);
                                    
                                    if(!mapObjIdMbId.containsKey(bookingrl.ExternalId)){
                                        
                                        mapObjIdMbId.put(bookingrl.ExternalId, masterBooking.ExternalId);
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    //here we are retrieving each guest Account's extrenal id
                    if(bookingWrap.GuestAccount1 != null && bookingWrap.GuestAccount1.ExternalId != null){
                        
                        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
                        if(bookingWrap.Booking != null && bookingWrap.Booking.ExternalId != null){
                            
                            if(!mapBookingIdListPA.containsKey(bookingWrap.Booking.ExternalId)){
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut.add(bookingWrap.GuestAccount1);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                            else{
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut = mapBookingIdListPA.get(bookingWrap.Booking.ExternalId);
                                listPAtoPut.add(bookingWrap.GuestAccount1);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                        }
                        system.debug('### cg mapBookingIdListPA'+mapBookingIdListPA);
                        //Added by Cynthia Geagea ACT-795 30/10/2019 End
                        
                        listGuestAccounts.add(bookingWrap.GuestAccount1);
                        
                        if(!mapObjIdMbId.containsKey(bookingWrap.GuestAccount1.ExternalId)){
                            
                            mapObjIdMbId.put(bookingWrap.GuestAccount1.ExternalId, masterBooking.ExternalId);
                        }
                        
                        //These 2 sets will be used as parameters for the method matchGuestAccounts
                        setPersonAccountEmail.add(bookingWrap.GuestAccount1.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrap.GuestAccount1.ExternalId);
                        
                    }
                    
                    if(bookingWrap.GuestAccount2 != null && bookingWrap.GuestAccount2.ExternalId != null){
                        
                        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
                        if(bookingWrap.Booking != null && bookingWrap.Booking.ExternalId != null){
                            
                            if(!mapBookingIdListPA.containsKey(bookingWrap.Booking.ExternalId)){
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut.add(bookingWrap.GuestAccount2);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                            else{
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut = mapBookingIdListPA.get(bookingWrap.Booking.ExternalId);
                                listPAtoPut.add(bookingWrap.GuestAccount2);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                        }
                        system.debug('### cg mapBookingIdListPA'+mapBookingIdListPA);
                        //Added by Cynthia Geagea ACT-795 30/10/2019 End
                        
                        listGuestAccounts.add(bookingWrap.GuestAccount2);
                        
                        if(!mapObjIdMbId.containsKey(bookingWrap.GuestAccount2.ExternalId)){
                            
                            mapObjIdMbId.put(bookingWrap.GuestAccount2.ExternalId, masterBooking.ExternalId);
                        }
                        
                        setPersonAccountEmail.add(bookingWrap.GuestAccount2.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrap.GuestAccount2.ExternalId);
                        
                    }
                    
                    if(bookingWrap.GuestAccount3 != null && bookingWrap.GuestAccount3.ExternalId != null){
                        
                        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
                        if(bookingWrap.Booking != null && bookingWrap.Booking.ExternalId != null){
                            
                            if(!mapBookingIdListPA.containsKey(bookingWrap.Booking.ExternalId)){
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut.add(bookingWrap.GuestAccount3);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                            else{
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut = mapBookingIdListPA.get(bookingWrap.Booking.ExternalId);
                                listPAtoPut.add(bookingWrap.GuestAccount3);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                        }
                        system.debug('### cg mapBookingIdListPA'+mapBookingIdListPA);
                        //Added by Cynthia Geagea ACT-795 30/10/2019 End
                        
                        listGuestAccounts.add(bookingWrap.GuestAccount3);
                        
                        if(!mapObjIdMbId.containsKey(bookingWrap.GuestAccount3.ExternalId)){
                            
                            mapObjIdMbId.put(bookingWrap.GuestAccount3.ExternalId, masterBooking.ExternalId);
                        }
                        
                        setPersonAccountEmail.add(bookingWrap.GuestAccount3.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrap.GuestAccount3.ExternalId);
                        
                    }
                    
                    if(bookingWrap.GuestAccount4 != null && bookingWrap.GuestAccount4.ExternalId != null){
                        
                        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
                        if(bookingWrap.Booking != null && bookingWrap.Booking.ExternalId != null){
                            
                            if(!mapBookingIdListPA.containsKey(bookingWrap.Booking.ExternalId)){
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut.add(bookingWrap.GuestAccount4);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                            else{
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut = mapBookingIdListPA.get(bookingWrap.Booking.ExternalId);
                                listPAtoPut.add(bookingWrap.GuestAccount4);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                        }
                        system.debug('### cg mapBookingIdListPA'+mapBookingIdListPA);
                        //Added by Cynthia Geagea ACT-795 30/10/2019 End
                        
                        listGuestAccounts.add(bookingWrap.GuestAccount4);
                        
                        if(!mapObjIdMbId.containsKey(bookingWrap.GuestAccount4.ExternalId)){
                            
                            mapObjIdMbId.put(bookingWrap.GuestAccount4.ExternalId, masterBooking.ExternalId);
                        }
                        
                        setPersonAccountEmail.add(bookingWrap.GuestAccount4.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrap.GuestAccount4.ExternalId);
                        
                    }
                    
                    if(bookingWrap.GuestAccount5 != null && bookingWrap.GuestAccount5.ExternalId != null){
                        
                        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
                        if(bookingWrap.Booking != null && bookingWrap.Booking.ExternalId != null){
                            
                            if(!mapBookingIdListPA.containsKey(bookingWrap.Booking.ExternalId)){
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut.add(bookingWrap.GuestAccount5);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                            else{
                                
                                list<PersonAccount> listPAtoPut = new list<PersonAccount>();
                                listPAtoPut = mapBookingIdListPA.get(bookingWrap.Booking.ExternalId);
                                listPAtoPut.add(bookingWrap.GuestAccount5);
                                
                                mapBookingIdListPA.put(bookingWrap.Booking.ExternalId,listPAtoPut);
                            }
                        }
                        system.debug('### cg mapBookingIdListPA'+mapBookingIdListPA);
                        //Added by Cynthia Geagea ACT-795 30/10/2019 End
                        
                        listGuestAccounts.add(bookingWrap.GuestAccount5);
                        
                        if(!mapObjIdMbId.containsKey(bookingWrap.GuestAccount5.ExternalId)){
                            
                            mapObjIdMbId.put(bookingWrap.GuestAccount5.ExternalId, masterBooking.ExternalId);
                        }
                        
                        setPersonAccountEmail.add(bookingWrap.GuestAccount5.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrap.GuestAccount5.ExternalId);
                        
                    }
                }
            }
            
            // Here we are retrieving the master booking's external id that is sent in the bookingInfo
            if(masterBooking != null && masterBooking.ExternalId != null){
                
                listMasterBookings.add(masterBooking);
                
                //To be used later to sort responses 
                mapMBExtIdRowIndex.put(masterBooking.ExternalId,rowIndex);
                rowIndex++;
            }
            
        }
        
        system.debug('### cg listBookings'+listBookings);
        
        if(setExistingBookingsExtId != null && setExistingBookingsExtId.size()>0){
            
            for (Booking_Room_Line__c BRL : [select id, Externalid__c,Obsolete__c
                                             from Booking_Room_Line__c 
                                             where Booking_FK__r.ExternalId__c in :setExistingBookingsExtId]){
                                                 
                                                 if(!setBookingRLFmWS.contains(BRL.Externalid__c)){
                                                     
                                                     mapBRToUpdate.put(BRL.ExternalId__c, BRL);
                                                 }
                                             }
        } 
        
        //This method makes sure to match the guest accounts existing in salesforce with the ones sent in the bookingInfo from BBUS, to avoid duplicates or errors
        matchGuestAccounts(setPersonAccountEmail,setPersonAccountExtID,mapEmailSFID,mapExtIDSFID);  
        
        //The upsert functions are called in this order:  PA, MB, B, BRL
        //First we loop over the reponses' lists to catch errors
        PersonAccounts personaccs = new PersonAccounts();
        personaccs.PersonAccount = listGuestAccounts;
        listPAResponses = doUpsertPersonAccounts(personaccs); //the method calls returns a list of responses shpwing succes or error for the PAs that we tried to upsert 
        
        for(UpsertResponse resppa : listPAResponses){
            
            //First we retrieve the master booking's external Id, to which the PA is related in the Booking Info object
            system.debug('### mapObjIdMbId' + mapObjIdMbId);
            system.debug('### resppa' + resppa);
            if(resppa != null && mapObjIdMbId.containsKey(resppa.ExternalId)){
                
                strMasterExternalId = mapObjIdMbId.get(resppa.ExternalId);
            }
            
            //If the response is an error, we have to make sure that there are no other errors on the same MB External Id already stored in the list that will be sent back to BBUS. If no errors already, we store the error encountered, else we skip this error
            if(resppa!= null && !resppa.Success && resppa.Error != null && !string.isBlank(resppa.Error)){
                
                boolean checkDuplicateErrPa = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId && !bookInfoUpsResp.Success){
                        
                        checkDuplicateErrPa = true;
                        break;
                    }
                }
                
                if(!checkDuplicateErrPa){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(false, strMasterExternalId, resppa.Error, rowIndex, 'PersonAccount', false));
                }
                
            }system.debug('### cg mapIndexListResponses in pa err'+mapIndexListResponses);
        }
        
        MasterBookings masterbooks = new Masterbookings();
        masterbooks.MasterBooking = listMasterBookings;
        listMBResponses = doUpsertMasterBookings(masterbooks);
        
        for(UpsertResponse respMb : listMBResponses){
            
            //First we retrieve the master booking's external Id
            strMasterExternalId = respMb.ExternalId;
            
            //If the response is an error, we have to make sure that there are no other errors on the same MB External Id already stored in the list that will be sent back to BBUS. If no errors already, we store the error encountered, else we skip this error
            if(!respMb.Success && respMb.Error != null && !string.isBlank(respMb.Error)){
                
                boolean checkDuplicateErrMb = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId && !bookInfoUpsResp.Success){
                        
                        checkDuplicateErrMb = true;
                        break;
                    }
                }
                
                if(!checkDuplicateErrMb){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(false, strMasterExternalId, respMb.Error, rowIndex, 'Master Booking', false));
                }
                
            }system.debug('### cg mapIndexListResponses in mb err'+mapIndexListResponses);
        }
        
        Bookings books = new Bookings();
        books.Booking = listBookings;
        listBResponses = doUpsertBookings(books);
        
        for(UpsertResponse respb : listBResponses){
            
            //First we retrieve the master booking's external Id, to which the Booking is related in the Booking Info object
            if(mapObjIdMbId.containsKey(respb.ExternalId)){
                
                strMasterExternalId = mapObjIdMbId.get(respb.ExternalId);
            }
            
            //If the response is an error, we have to make sure that there are no other errors on the same MB External Id already stored in the list that will be sent back to BBUS. If no errors already, we store the error encountered, else we skip this error
            if(!respb.Success && respb.Error != null && !string.isBlank(respb.Error)){
                
                boolean checkDuplicateErrB = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId && !bookInfoUpsResp.Success){
                        
                        checkDuplicateErrB = true;
                        break;
                    }
                }
                
                if(!checkDuplicateErrB){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(false, strMasterExternalId, respb.Error, rowIndex, 'Booking', false));
                }
                
            }system.debug('### cg mapIndexListResponses in b err'+mapIndexListResponses);
        }
        //Added by TMA-JK - CRMSS-173 Start
        BookingRoomLines bookRLPs = new BookingRoomLines();
        bookRLPs.BookingRoomLine =listBookingRoomLinesParent ;
        listBRLResponses = doUpsertBookingRoomLines(bookRLPs);
        //Added by TMA-JK - CRMSS-173 End
        BookingRoomLines bookRLs = new BookingRoomLines();
        bookRLs.BookingRoomLine = listBookingRoomLines;
        listBRLResponses = doUpsertBookingRoomLines(bookRLs);

        
        for(UpsertResponse respbrl : listBRLResponses){
            
            //First we retrieve the master booking's external Id, to which the Booking Room Line is related in the Booking Info object
            if(mapObjIdMbId.containsKey(respbrl.ExternalId)){
                
                strMasterExternalId = mapObjIdMbId.get(respbrl.ExternalId);
            }
            
            //If the response is an error, we have to make sure that there are no other errors on the same MB External Id already stored in the list that will be sent back to BBUS. If no errors already, we store the error encountered, else we skip this error
            if(!respbrl.Success && respbrl.Error != null && !string.isBlank(respbrl.Error)){
                
                boolean checkDuplicateErrBRL = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId && !bookInfoUpsResp.Success){
                        
                        checkDuplicateErrBRL = true;
                        break;
                    }
                }
                
                if(!checkDuplicateErrBRL){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(false, strMasterExternalId, respbrl.Error, rowIndex, 'Booking Room Line', false));
                }
                
            }system.debug('### cg mapIndexListResponses in brl err'+mapIndexListResponses);
        }
        
        //After catching all errors encountered above, we loop again over the responses' list to gather success responses and return them in case no error was encountered on each of their MB's External Ids
        for(UpsertResponse resppa : listPAResponses){
            
            //First we retrieve the master booking's external Id, to which the PA is related in the Booking Info object
            if(resppa!= null && mapObjIdMbId.containsKey(resppa.ExternalId)){
                
                strMasterExternalId = mapObjIdMbId.get(resppa.ExternalId);
            }
            
            //If the response is a success, we need to verify that there no errors encountered on the same MB External Id, and make sure that in case of no errors at all, the success response is returned once for each MB's External ID
            if(resppa!= null && resppa.Success){
                
                boolean checkDuplicateSuccPa = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId){
                        
                        checkDuplicateSuccPa = true;
                        break;
                    }
                }
                
                if(!checkDuplicateSuccPa){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(true, strMasterExternalId, null, rowIndex, null, false));
                }
            }system.debug('### cg mapIndexListResponses in pa succ'+mapIndexListResponses);
        }
        
        for(UpsertResponse respMb : listMBResponses){
            
            //First we retrieve the master booking's external Id
            strMasterExternalId = respMb.ExternalId;
            
            //If the response is a success, we need to verify that there no errors encountered on the same MB External Id, and make sure that in case of no errors at all, the success response is returned once for each MB's External ID
            
            if(respMb.Success){
                
                boolean checkDuplicateSuccMb = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId){
                        
                        checkDuplicateSuccMb = true;
                        break;
                    }
                }
                
                if(!checkDuplicateSuccMb){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(true, strMasterExternalId, null, rowIndex, null, false));
                }
            }system.debug('### cg mapIndexListResponses in mb succ'+mapIndexListResponses);
        }
        
        for(UpsertResponse respb : listBResponses){
            
            //First we retrieve the master booking's external Id, to which the Booking is related in the Booking Info object
            if(mapObjIdMbId.containsKey(respb.ExternalId)){
                
                strMasterExternalId = mapObjIdMbId.get(respb.ExternalId);
            }
            //If the response is a success, we need to verify that there no errors encountered on the same MB External Id, and make sure that in case of no errors at all, the success response is returned once for each MB's External ID
            
            if(respb.Success){
                
                boolean checkDuplicateSuccB = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId){
                        
                        checkDuplicateSuccB = true;
                        break;
                    }
                }
                
                if(!checkDuplicateSuccB){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(true, strMasterExternalId, null, rowIndex, null, false));
                }
            }system.debug('### cg mapIndexListResponses in b succ'+mapIndexListResponses);
        }
        
        for(UpsertResponse respbrl : listBRLResponses){
            
            //First we retrieve the master booking's external Id, to which the Booking room Line is related in the Booking Info object
            if(mapObjIdMbId.containsKey(respbrl.ExternalId)){
                
                strMasterExternalId = mapObjIdMbId.get(respbrl.ExternalId);
            }
            
            //If the response is a success, we need to verify that there no errors encountered on the same MB External Id, and make sure that in case of no errors at all, the success response is returned once for each MB's External ID
            if(respbrl.Success){
                
                boolean checkDuplicateSuccBRL = false;
                
                for(BookingInfoUpsertResponse bookInfoUpsResp : mapIndexListResponses.values()){
                    
                    if(bookInfoUpsResp.MasterBookingExternalId == strMasterExternalId){
                        
                        checkDuplicateSuccBRL = true;
                        break;
                    }
                }
                
                if(!checkDuplicateSuccBRL){
                    
                    rowIndex = mapMBExtIdRowIndex.get(strMasterExternalId);
                    mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(true, strMasterExternalId, null, rowIndex, null, false));
                }
            }system.debug('### cg mapIndexListResponses in brl succ'+mapIndexListResponses);
        }
        
        //We need to sort the list to be returned, according to the rowIndex
        list<Integer> rowIndexList = new list<Integer>();
        rowIndexList.addAll(mapIndexListResponses.keySet());
        rowIndexList.sort();
        
        map<Integer,BookingInfoUpsertResponse> mapIndexListResponsesSorted = new map<Integer,BookingInfoUpsertResponse>();//This is the sorted map which values are returned to BBUS
        
        for(Integer rowInd : rowIndexList){
            
            mapIndexListResponsesSorted.put(rowInd, mapIndexListResponses.get(rowInd));
        }
        
        //finally we return a list of all error or succes responses back to BBUS. Each MB will have only one returned response: an error, or a success in case there are no errors at all
        System.debug('##### mapIndexListResponsesSorted ' + mapIndexListResponsesSorted.values());
        return mapIndexListResponsesSorted.values();
        
    }
    
    
    webservice static List<UpsertResponse> doUpsertBookingRoomLines(BookingRoomLines BookingRoomLines) {
        Map<Integer, UpsertResponse> mapResponses = new Map<Integer, UpsertResponse>();
        List<BookingRoomLine> listBookingRoomLines = BookingRoomLines.BookingRoomLine;
        Map<String, Booking_Room_Line__c> mapExternalBookingRoomLinesToTreat = new Map<String, Booking_Room_Line__c>();
        Map<String, Integer> mapBookingRoomLineRowIndex = new Map<String, Integer>();        
        Integer rowIndex = 0;
        Integer existingIndex = 0;
        set<string> setBookingIds= new set<string> ();
        String bookingExt;
        for(BookingRoomLine roomLine : listBookingRoomLines)  {
            bookingExt = roomLine.booking;
            try {
                if(String.isNotBlank(roomLine.ExternalId)) { 
                    if(mapExternalBookingRoomLinesToTreat.containsKey(roomLine.ExternalId)) {
                        existingIndex = mapBookingRoomLineRowIndex.get(roomLine.ExternalId); 
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + roomLine.ExternalId));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified : ' + roomLine.ExternalId));
                        mapExternalBookingRoomLinesToTreat.remove(roomLine.ExternalId);
                    } else {    
                        mapBookingRoomLineRowIndex.put(roomLine.ExternalId, rowIndex);
                        mapExternalBookingRoomLinesToTreat.put(roomLine.ExternalId, roomLine.mapSFFields());
                        mapResponses.put(rowIndex, null); 
                    }
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified'));
                }
            }catch(Exception ex) {
                mapResponses.put(rowIndex, new UpsertResponse(false,roomLine.ExternalId , rowIndex, ex.getMessage()));
            }finally {
                rowIndex ++;    
            }
        }
        
        
        // jul start 
        if(mapBRToUpdate != null && mapBRToUpdate.size() > 0 )
        { 
            for(Booking_Room_Line__c BRL : mapBRToUpdate.values()) {
                BRL.Obsolete__c = True; 
                BRL.Booking_FK__c = Label.Booking_GenericID;
                mapExternalBookingRoomLinesToTreat.put(BRL.ExternalId__c,BRL);
            }
        }
        mapBRToUpdate.clear();
        // jul end
        doUpsertRecords(mapExternalBookingRoomLinesToTreat.values(), 'Booking_Room_Line__c', mapResponses, mapBookingRoomLineRowIndex);
        
        return mapResponses.values();
    } 
    
    webservice static List<UpsertResponse> doUpsertMasterBookings(MasterBookings MasterBookings) {
        Map<Integer, UpsertResponse> mapResponses = new Map<Integer, UpsertResponse>();
        List<MasterBooking> listMasterBookings = MasterBookings.MasterBooking;
        Map<String, Opportunity> mapExternalMasterBookingsToTreat = new Map<String, Opportunity>();
        Map<String, Integer> mapMasterRowIndex = new Map<String, Integer>();        
        Integer rowIndex = 0;
        Integer existingIndex = 0;
        for(MasterBooking masterBooking : listMasterBookings) {//system.debug('masterBooking.ExternalId '+masterBooking.ExternalId); system.debug('rowIndex '+rowIndex);
            try {
                if(String.isNotBlank(masterBooking.ExternalId)) {
                    if(mapExternalMasterBookingsToTreat.containsKey(masterBooking.ExternalId)) {
                        existingIndex = mapMasterRowIndex.get(masterBooking.ExternalId);
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + masterBooking.ExternalId));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + masterBooking.ExternalId));
                        mapExternalMasterBookingsToTreat.remove(masterBooking.ExternalId);
                    } else {
                        mapMasterRowIndex.put(masterBooking.ExternalId, rowIndex);
                        mapExternalMasterBookingsToTreat.put(masterBooking.ExternalId, masterBooking.mapSFFields());
                        mapResponses.put(rowIndex, null);
                    }
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified'));
                }
            }catch(Exception ex) {
                mapResponses.put(rowIndex, new UpsertResponse(false,masterBooking.ExternalId , rowIndex, ex.getMessage()));
            }finally {
                rowIndex ++;    
            }
        }        
        doUpsertRecords(mapExternalMasterBookingsToTreat.values(), 'Opportunity', mapResponses, mapMasterRowIndex);        
        return mapResponses.values();
    }
    
    webservice static List<UpsertResponse> doUpsertBookings(Bookings Bookings) {
        system.debug('### cg Bookings' + Bookings);
        Map<Integer, UpsertResponse> mapResponses = new Map<Integer, UpsertResponse>();
        List<Booking> listBookings = Bookings.Booking;
        Map<String, Opportunity> mapExternalBookingsToTreat = new Map<String, Opportunity>();
        Map<String, Integer> mapBookingRowIndex = new Map<String, Integer>();        
        Integer rowIndex = 0;
        Integer existingIndex = 0;
        for(Booking booking : listBookings) {
            try {
                if(String.isNotBlank(booking.ExternalId)) {
                    if(mapExternalBookingsToTreat.containsKey(booking.ExternalId)) {
                        existingIndex = mapBookingRowIndex.get(booking.ExternalId);
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + booking.ExternalId));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + booking.ExternalId));
                        mapExternalBookingsToTreat.remove(booking.ExternalId);
                    } else {
                        mapBookingRowIndex.put(booking.ExternalId, rowIndex);
                        mapExternalBookingsToTreat.put(booking.ExternalId, booking.mapSFFields());
                        mapResponses.put(rowIndex, null); 
                    }
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified')); 
                }
            }catch(Exception ex) {
                mapResponses.put(rowIndex, new UpsertResponse(false,booking.ExternalId , rowIndex, ex.getMessage()));
            }finally {
                rowIndex ++;    
            }
        }
        system.debug('### cg mapExternalBookingsToTreat.values()' + mapExternalBookingsToTreat.values());
        doUpsertRecords(mapExternalBookingsToTreat.values(), 'Opportunity', mapResponses, mapBookingRowIndex);
        return mapResponses.values();
    }
    
    webservice static List<UpsertResponse> doUpsertPersonAccounts(PersonAccounts PersonAccounts) {  
        
        Map<Integer, UpsertResponse> mapResponses = new Map<Integer, UpsertResponse>();
        List<PersonAccount> listPersonAccounts = PersonAccounts.PersonAccount;
        
        //Added by TMA-JK CG CRMSS-160 Start
        Set<String> setEmail = new Set<String>();
        Set<String> setExtID = new Set<String>();
        
        
        Map<String, Account> mapExternalAccountsToTreat = new Map<String, Account>();
        Map<String, Integer> mapPersonRowIndex = new Map<String, Integer>();        
        Integer existingIndex = 0;
        Integer rowIndex = 0;
        
        system.debug('### cg FromBookingInfo'+FromBookingInfo);
        if(!FromBookingInfo){
            
            system.debug('### cg FromBookingInfo false'+FromBookingInfo);
            /*Commented by TMA-EIL CRMSS-579 16/04/2020 
            //Add for logs Start
            Log__c log2 = new Log__c();
            log2.WSName__c = 'Do upsert Person Account';
            insert log2;
            Attachment  doc2 = new Attachment ();
            doc2.Name = 'JsonLog';  
            doc2.Body = Blob.valueOf(Json.serialize(PersonAccounts));
            doc2.ContentType = 'text/plain';
            doc2.ParentId = log2.id;
            insert doc2;
            //Add for logs End
            //*/
            
            for(PersonAccount guestAccount : listPersonAccounts) {
                setEmail.add(guestAccount.Email.tolowercase());
                setExtID.add(guestAccount.ExternalId);
            }
            
            matchGuestAccounts(setEmail,setExtID,mapEmailSFID,mapExtIDSFID);
            
            //Added by TMA-JK CG CRMSS-160 End
            
            for(PersonAccount guestAccount : listPersonAccounts) {
                try {
                    if(String.isNotBlank(guestAccount.ExternalId)) {
                        if(mapExternalAccountsToTreat.containsKey(guestAccount.ExternalId)) {
                            existingIndex = mapPersonRowIndex.get(guestAccount.ExternalId);
                            mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId));
                            mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId));
                            mapExternalAccountsToTreat.remove(guestAccount.ExternalId);
                        } else {
                            mapPersonRowIndex.put(guestAccount.ExternalId, rowIndex);
                            //Added by TMA-JK CRMSS-160 Start
                            Account acc = new Account();
                            acc = guestAccount.mapSFFields();
                            if(mapExtIDSFID.containsKey(acc.Externalid__c)){
                                System.debug('### EXT contains');
                                acc.id = mapExtIDSFID.get(acc.Externalid__c);
                            }else if(mapEmailSFID.containsKey(acc.Email__pc.tolowercase())){
                                System.debug('### Email__pc contains');
                                acc.id = mapEmailSFID.get(acc.Email__pc.tolowercase());
                            }
                            //Added by TMA-JK CRMSS-160 End
                            mapExternalAccountsToTreat.put(guestAccount.ExternalId, acc);
                            mapResponses.put(rowIndex, null);
                        }                                                            
                    } else {
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified'));
                    }
                }catch(Exception ex) {
                    mapResponses.put(rowIndex, new UpsertResponse(false,guestAccount.ExternalId , rowIndex, ex.getMessage()));
                }finally {
                    rowIndex ++;    
                }
            }
            System.debug('### mapExternalAccountsToTreat.values() not fm bookingInfo' + mapExternalAccountsToTreat.values());
            doUpsertRecords(mapExternalAccountsToTreat.values(), 'Account', mapResponses, mapPersonRowIndex);    
            
            /*Commented by TMA-EIL CRMSS-579 16/04/2020 
            //Add for logs Start
            Log__c log = new Log__c();
            log.WSName__c = 'Do upsert Person Account Return';
            insert log;
            Attachment  doc = new Attachment ();
            doc.Name = 'JsonLog';  
            doc.Body = Blob.valueOf(Json.serialize(mapResponses.values()));
            doc.ContentType = 'text/plain';
            doc.ParentId = log.id;
            insert doc;
            //Add for logs End
            //*/
            
        }
        //Added by Cynthia Geagea ACT-795 30/10/2019 Start
        else{
            system.debug('##### mapBookingIdListPA' + mapBookingIdListPA);
            system.debug('### cg FromBookingInfo true'+FromBookingInfo);
            
            Map<String,Map<String,Account>> MapPAToTreat = new  Map<String,Map<String,Account>>();
            for(String bookExtID : mapBookingIdListPA.keySet()){
                MapPAToTreat.put(bookExtID, new Map<String,Account>());
                //Added by TMA-JK CG CRMSS-160 End 
                for(PersonAccount guestAccount : mapBookingIdListPA.get(bookExtID)) {
                    system.debug('##### mapBookingIdListPA get info' + mapBookingIdListPA.get(bookExtID));
                    system.debug('##### mapExternalAccountsToTreat' + mapExternalAccountsToTreat.values());
                    try {
                        if(String.isNotBlank(guestAccount.ExternalId)) {
                            if(MapPAToTreat.get(bookExtID).containsKey(guestAccount.ExternalId)){
                                existingIndex = mapPersonRowIndex.get(guestAccount.ExternalId);
                                mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId));
                                mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId));
                                MapPAToTreat.get(bookExtID).remove(guestAccount.ExternalId);
                            }else{
                                mapPersonRowIndex.put(guestAccount.ExternalId, rowIndex);
                                //Added by TMA-JK CRMSS-160 Start
                                Account acc = new Account();
                                acc = guestAccount.mapSFFields();
                                if(mapExtIDSFID.containsKey(acc.Externalid__c)){
                                    System.debug('### EXT contains');
                                    acc.id = mapExtIDSFID.get(acc.Externalid__c);
                                }else if(mapEmailSFID.containsKey(acc.Email__pc.tolowercase())){
                                    System.debug('### Email__pc contains');
                                    acc.id = mapEmailSFID.get(acc.Email__pc.tolowercase());
                                }
                                //Added by TMA-JK CRMSS-160 End
                                MapPAToTreat.get(bookExtID).put(guestAccount.ExternalId, acc);
                                mapResponses.put(rowIndex, null);
                            }
                            /*if(mapExternalAccountsToTreat.containsKey(guestAccount.ExternalId)) {
existingIndex = mapPersonRowIndex.get(guestAccount.ExternalId);
mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId));
mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId));
mapExternalAccountsToTreat.remove(guestAccount.ExternalId);
} else {
mapPersonRowIndex.put(guestAccount.ExternalId, rowIndex);
//Added by TMA-JK CRMSS-160 Start
Account acc = new Account();
acc = guestAccount.mapSFFields();
if(mapExtIDSFID.containsKey(acc.Externalid__c)){
System.debug('### EXT contains');
acc.id = mapExtIDSFID.get(acc.Externalid__c);
}else if(mapEmailSFID.containsKey(acc.Email__pc.tolowercase())){
System.debug('### Email__pc contains');
acc.id = mapEmailSFID.get(acc.Email__pc.tolowercase());
}
//Added by TMA-JK CRMSS-160 End
mapExternalAccountsToTreat.put(guestAccount.ExternalId, acc);
mapResponses.put(rowIndex, null);
}      */                                                      
                        } else {
                            mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified'));
                        }
                    }catch(Exception ex) {
                        mapResponses.put(rowIndex, new UpsertResponse(false,guestAccount.ExternalId , rowIndex, ex.getMessage()));
                    }finally {
                        rowIndex ++;    
                    }
                }
                
                //Put all PA together
                
                for(String bookID : MapPAToTreat.keySet()){
                    Map<String,Account> mapPA = MapPAToTreat.get(bookID);
                    for(String guestAccountID : mapPA.keyset()) {
                        mapExternalAccountsToTreat.put(guestAccountID,mapPA.get(guestAccountID));
                    }
                    
                }
                
                System.debug('### mapExternalAccountsToTreat.values() from BookingInfo' + mapExternalAccountsToTreat.values());
                System.debug('### mapExternalAccountsToTreat.values() from mapResponses before modif' + mapResponses.values());
            }		
            system.debug('mapExternalAccountsToTreat ###' + mapExternalAccountsToTreat);
            system.debug('mapResponses ###' + mapResponses);
            doUpsertRecords(mapExternalAccountsToTreat.values(), 'Account', mapResponses, mapPersonRowIndex);  
            system.debug('mapResponses after ###' + mapResponses);
        }   
        //Added by Cynthia Geagea ACT-795 30/10/2019 End
        
        return mapResponses.values();
    }
    
    private static void doUpsertRecords(List<SObject> listSObjectToUpsert, String strObjectName, Map<Integer, UpsertResponse> mapResponses, Map<String, Integer> mapExternalRowIndex) {
        Schema.SObjectField externalIdField;
        List<Account> listAccountToUpsert;
        List<Opportunity> listOpportunityToUpsert;
        List<Booking_Room_Line__c> listBookingRoomLines;
        Integer caseIndex;
        if(strObjectName.equalsIgnoreCase('Opportunity')) {
            externalIdField = Opportunity.Fields.ExternalId__c;
            listOpportunityToUpsert = (List<Opportunity>) listSObjectToUpsert;
            caseIndex = 1;
        } else if(strObjectName.equalsIgnoreCase('Account')) {
            //externalIdField = Account.Fields.ExternalId__c; Removed by TMA-JK CRMSS-160 
            //Added by TMA-JK CRMSS-160 Start
            externalIdField = Account.Fields.id;
            //Added by TMA-JK CRMSS-160 End
            listAccountToUpsert = (List<Account>) listSObjectToUpsert;
            caseIndex = 2;
        } else if(strObjectName.equalsIgnoreCase('Booking_Room_Line__c')) {
            externalIdField = Booking_Room_Line__c.Fields.ExternalId__c;
            listBookingRoomLines = (List<Booking_Room_Line__c>) listSObjectToUpsert;
            caseIndex = 3;
        }
        Database.UpsertResult [] results;
        List<SObject> listUpsertedRecords;
        switch on caseIndex {
            when 1 {         
                results = Database.upsert(listOpportunityToUpsert,externalIdField, false);
                listUpsertedRecords = listOpportunityToUpsert;
                system.debug('listOpportunityToUpsert ' +  listOpportunityToUpsert);
                system.debug('externalIdField ' +  externalIdField);
            }
            when 2 {
                results = Database.upsert(listAccountToUpsert,externalIdField, false);
                listUpsertedRecords = listAccountToUpsert;
            }
            when 3 {
                results = Database.upsert(listBookingRoomLines,externalIdField, false);
                listUpsertedRecords = listBookingRoomLines;
            }
        }
        Integer rowIndex = 0;
        Integer index = 0;
        SObject sfObject;
        String  strExternalId;
        for(Database.UpsertResult result : results) {
            sfObject = listUpsertedRecords[index];
            strExternalId = (String)sfObject.get('ExternalId__c');
            if(mapExternalRowIndex.containsKey(strExternalId)) {
                rowIndex = mapExternalRowIndex.get(strExternalId);
                if(result.isSuccess()) {
                    mapResponses.put(rowIndex, new UpsertResponse(true,strExternalId, rowIndex, null));
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,strExternalId , rowIndex, result.getErrors()[0].getMessage())); 
                }
            }
            index++;
        }
    }
    
    //Added by TMA-JK CRMSS-160 Start
    private static void matchGuestAccounts(Set<String> setEmail, Set<String> setExternalId,  Map<String,String> mapEmailSFID, Map<String,String> mapExtIDSFID){
        
        //Added by TMA-JK CRMSS-160 Start
        if(!setEmail.isEmpty() || !setExternalId.isEmpty())
        {
            system.debug('### setEmail ' + setEmail);
            list<Account> listAccountExisting = [select id, Externalid__c,email__pc
                                                 from account 
                                                 where Externalid__c in :setExternalId or ( Externalid__c = null and email__pc in :setEmail)];
            System.debug('### listAccountExisting ' + listAccountExisting);
            
            for (Account acc : listAccountExisting)
            {
                if(acc.Externalid__c == null){
                    mapEmailSFID.put(acc.Email__pc,acc.id);
                }else {
                    mapExtIDSFID.put(acc.Externalid__c,acc.id);
                }
            }
        }
        //Added by TMA-JK CRMSS-160 End
        
        system.debug('### mapEmailSFID ' + mapEmailSFID);
    }
    
    
    global class UpsertResponse {
        webservice boolean Success;
        webservice String ExternalId;
        webservice Integer Index;
        webservice String Error;
        
        public UpsertResponse() {}
        
        public UpsertResponse(boolean isSuccess, String strExternalId, Integer rowIndex, String strError) {
            Success = isSuccess;
            ExternalId = strExternalId;
            Index = rowIndex;
            Error = strError;
        } 
    }
    
    global class BookingInfoUpsertResponse {
        webservice String MasterBookingExternalId;
        webservice boolean Success;
        webservice String Error;
        webservice Integer Index;
        webservice String ErrorOnObject;
        webservice Boolean LimitException;
        
        public BookingInfoUpsertResponse(){}
        
        public BookingInfoUpsertResponse(boolean isSuccess, String masterExternalId, String strError, Integer rowIndex, String strErrorObject, Boolean limitExcept) {
            Success = isSuccess;
            MasterBookingExternalId = masterExternalId;
            Error = strError;
            Index = rowIndex;
            ErrorOnObject = strErrorObject;
            LimitException = limitExcept;
        }
    }
    
    global class PersonAccounts {
        webservice List<PersonAccount> PersonAccount;
    }
    
    global class MasterBookings {
        webservice List<MasterBooking> MasterBooking;
    }
    
    global class Bookings {
        webservice List<Booking> Booking;
    }
    
    global class BookingRoomLines {
        webservice List<BookingRoomLine> BookingRoomLine;
    }
    
    global class BookingInfos {
        webservice List<BookingInfo> BookingInfo;
    }
    
    
    
}