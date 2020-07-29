/**
* @author Georges Hobeika
* @date 25/01/2019
* @description webservice used by BBUS to insert/modify BookingInfo : Master Booking - Booking - Person Account - Booking Room Lines
*/
global without sharing class WS01_BookingInfo {
    
    static Map<String, Map<String, Booking_Room_Line__c>> mapBookingRoomLinesByExternalId = new  Map<String, Map<String, Booking_Room_Line__c>>();
    static Map<String, Booking_Room_Line__c> mapBRToUpdate = new Map<String, Booking_Room_Line__c>();
    
    //Added by TMA-JK CRMSS-160 Start
    static Map<String,String> mapEmailSFID = new Map<String,String>();
    static Map<String,String> mapExtIDSFID = new Map<String,String>();
    //Added by TMA-JK CRMSS-160 End
    //Add for logs Start
    Static boolean FromBookingInfo = false;
    //Add for logs End
    webservice static List<BookingInfoUpsertResponse> doUpsertBookingInfos(BookingInfos BookingInfos ) {
        //Add for logs Start
        FromBookingInfo = true;
        Log__c log = new Log__c();
        log.WSName__c = 'Booking Info';
        insert log;
        Attachment  doc = new Attachment ();
        doc.Name = 'JsonLog';  
        doc.Body = Blob.valueOf(Json.serialize(BookingInfos));
        doc.ContentType = 'text/plain';
        doc.ParentId = log.id;
        insert doc;        
        //Add for logs End
        
        Map<Integer, BookingInfoUpsertResponse> mapIndexListResponses = new Map<Integer, BookingInfoUpsertResponse>();
        BookingInfo.MasterBookingWrapper masterBookingWrapper;
        List<BookingInfo.BookingWrapper> listBookingWrapper;
        
        MasterBooking masterBooking;
        
        Integer rowIndex = 0;
        boolean bError;
        String strError;
        String strObjectName;
        String strExternalIdError;
        String strMasterExternalId;
        List<UpsertResponse> listResponses = new List<UpsertResponse>();
        UpsertResponse response;
        SavePoint sp;
        MasterBookings masterBookings;
        Bookings bookings;
        PersonAccounts personAccounts;
        BookingRoomLines bookingRoomLines;
        //Added by TMA-JK - CRMSS-173 Start
        BookingRoomLines bookingRoomLinesParent;
        //Added by TMA-JK - CRMSS-173 End
        //jul start
        set<String> setExistingBookings = new set<String>();
        Set<String> setBookingRLFromWebService = new Set<String>();
        BookingInfo.MasterBookingWrapper masterBookingWrapper2;
        List<BookingInfo.BookingWrapper> listBookingWrapper2;
        //Added by TMA-JK - CRMSS-160 Start
        set<String> setPersonAccountEmail = new set<String>();
        set<String> setPersonAccountExtID = new set<String>();
        //Added by TMA-JK - CRMSS-160 End
        
        
        for(BookingInfo bookinginfo : BookingInfos.BookingInfo)
        {
            masterBookingWrapper2 = bookinginfo.MasterBookingWrapper;
            listBookingWrapper2 = masterBookingWrapper2.BookingWrapper;
            
            if(listBookingWrapper2 != null && listBookingWrapper2.size() > 0)
            {
                for(BookingInfo.BookingWrapper bookingWrapper : listBookingWrapper2) {
                    if(bookingWrapper.Booking != null && bookingWrapper.Booking.ExternalId != null)
                    {
                        if(bookingWrapper.BookingRoomLines != null) {
                            for(BookingRoomLine rl : bookingWrapper.BookingRoomLines) {
                                if(rl.ExternalId != null) {
                                    setBookingRLFromWebService.add(rl.ExternalId);
                                }
                            }
                        }
                        setExistingBookings.add(bookingWrapper.Booking.ExternalId);
                    }
                    //Added by TMA-JK - CRMSS-160 Start
                    if(bookingWrapper.GuestAccount1 != null) {
                        setPersonAccountEmail.add(bookingWrapper.GuestAccount1.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrapper.GuestAccount1.ExternalId);
                    }
                    if(bookingWrapper.GuestAccount2 != null) {
                        setPersonAccountEmail.add(bookingWrapper.GuestAccount2.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrapper.GuestAccount2.ExternalId);
                    }
                    if(bookingWrapper.GuestAccount3 != null) {
                        setPersonAccountEmail.add(bookingWrapper.GuestAccount3.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrapper.GuestAccount3.ExternalId);
                    }
                    if(bookingWrapper.GuestAccount4 != null) {
                        setPersonAccountEmail.add(bookingWrapper.GuestAccount4.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrapper.GuestAccount4.ExternalId);
                    }
                    if(bookingWrapper.GuestAccount5 != null) {
                        system.debug('Guest account 5 != null');
                        setPersonAccountEmail.add(bookingWrapper.GuestAccount5.Email.toLowerCase());
                        setPersonAccountExtID.add(bookingWrapper.GuestAccount5.ExternalId);
                    }
                    //Added by TMA-JK - CRMSS-160 End
                }
            }
        }
        
        if(!setExistingBookings.isEmpty())
        {
            list<Booking_Room_Line__c> ListBRL = [select id, Externalid__c,Obsolete__c
                                                  from Booking_Room_Line__c 
                                                  where Booking_FK__r.ExternalId__c in :setExistingBookings];
            
            for (Booking_Room_Line__c BRL : ListBRL)
            {
                if(!setBookingRLFromWebService.contains(BRL.Externalid__c)) {
                    mapBRToUpdate.put(BRL.ExternalId__c, BRL);
                }
            }
        } 
        //jul end 
        matchGuestAccounts(setPersonAccountEmail,setPersonAccountExtID,mapEmailSFID,mapExtIDSFID);

        for(BookingInfo bookinginfo : BookingInfos.BookingInfo) { 
            sp = Database.setSavepoint();
            bError = false;
            masterBookingWrapper = bookinginfo.MasterBookingWrapper;
            masterBooking = masterBookingWrapper.MasterBooking;
           
            if (masterBooking.ExternalId != null)
            {
                strMasterExternalId = masterBooking.ExternalId;
            }
            
            masterBookings = new MasterBookings();
            masterBookings.MasterBooking  = new List<MasterBooking>{masterBooking};
            listResponses = doUpsertMasterBookings(masterBookings);system.debug('### cg listResponses mb'+listResponses);
            response = listResponses[0];
            if(response.Success) { 
                listBookingWrapper = masterBookingWrapper.BookingWrapper;
                bookings = new Bookings();
                bookings.Booking = new List<Booking>();
                personAccounts = new PersonAccounts();
                personAccounts.PersonAccount = new List<PersonAccount>();
                bookingRoomLines = new BookingRoomLines();
                bookingRoomLines.BookingRoomLine = new List<BookingRoomLine>();
                //Added by TMA-JK - CRMSS-173 Start
                bookingRoomLinesParent = new BookingRoomLines();
                bookingRoomLinesParent.BookingRoomLine = new List<BookingRoomLine>();
                //Added by TMA-JK - CRMSS-173 End
                if(listBookingWrapper != null && listBookingWrapper.size() > 0) {
                    for(BookingInfo.BookingWrapper bookingWrapper : listBookingWrapper) {
                        if(bookingWrapper.Booking != null) {
                            bookingWrapper.Booking.MasterBooking = strMasterExternalId;
                            if(bookingWrapper.Booking != null) {
                                bookings.Booking.add(bookingWrapper.Booking);
                            }
                            system.debug('bookingWrapper.GuestAccount12 ' + bookingWrapper.GuestAccount2 );
                            //get Person Accounts of the list of bookings
                            if(bookingWrapper.GuestAccount1 != null) {
                                personAccounts.PersonAccount.add(bookingWrapper.GuestAccount1);
                                bookingWrapper.Booking.GuestAccount1 = bookingWrapper.GuestAccount1.ExternalId;
                            }
                            if(bookingWrapper.GuestAccount2 != null) {
                                personAccounts.PersonAccount.add(bookingWrapper.GuestAccount2);
                                bookingWrapper.Booking.GuestAccount2 = bookingWrapper.GuestAccount2.ExternalId;
                                
                                system.debug('bookingWrapper.Booking.GuestAccount1  ' + bookingWrapper.Booking.GuestAccount2 );
                            }
                            if(bookingWrapper.GuestAccount3 != null) {
                                personAccounts.PersonAccount.add(bookingWrapper.GuestAccount3);
                                bookingWrapper.Booking.GuestAccount3 = bookingWrapper.GuestAccount3.ExternalId;
                            }
                            if(bookingWrapper.GuestAccount4 != null) {
                                personAccounts.PersonAccount.add(bookingWrapper.GuestAccount4);
                                bookingWrapper.Booking.GuestAccount4 = bookingWrapper.GuestAccount4.ExternalId;
                            }
                            if(bookingWrapper.GuestAccount5 != null) {
                                personAccounts.PersonAccount.add(bookingWrapper.GuestAccount5);
                                bookingWrapper.Booking.GuestAccount5 = bookingWrapper.GuestAccount5.ExternalId;
                            }
                            
                            // get booking room lines of the list of bookings
                            if(bookingWrapper.BookingRoomLines != null) {
                                for(BookingRoomLine roomLine : bookingWrapper.BookingRoomLines) {
                                    roomLine.Booking = bookingWrapper.Booking.ExternalId;
                                    //Added by TMA-JK - CRMSS-173 Start
                                    if(roomLine.RoomLineParent == null || String.isEmpty(roomLine.RoomLineParent)){
                                        bookingRoomLinesParent.BookingRoomLine.add(roomLine);
                                    }else {
                                        bookingRoomLines.BookingRoomLine.add(roomLine);
                                    }
                                    system.debug('bookingRoomLinesParent ### ' + bookingRoomLinesParent.BookingRoomLine);
                                    system.debug('BookingRoomLine ### ' + bookingRoomLines.BookingRoomLine);
                                    //bookingRoomLines.BookingRoomLine.add(roomLine); Removed by TMA-EI JK CRMSS - 173
                                    //Added by TMA-JK - CRMSS-173 End
                                }
                            }
                        } else {
                            bError = true;
                            strError = 'Bad request. Missing Booking information';
                            strObjectName = 'Master Booking';
                        }
                        
                    }
                } 
                // upsert list of person Accounts
                listResponses = doUpsertPersonAccounts(personAccounts);system.debug('### cg listResponses pa'+listResponses);
                for(UpsertResponse upsertResponse : listResponses) {
                    if(!upsertResponse.Success) {
                        bError = true;
                        strError = upsertResponse.Error;
                        strObjectName = 'PersonAccount';
                        break;
                    }
                }
                if(!bError) {
                    // upsert list of Bookings
                    listResponses = doUpsertBookings(bookings);system.debug('### cg listResponses b'+listResponses);
                    for(UpsertResponse upsertResponse : listResponses) {
                        if(!upsertResponse.Success) {
                            bError = true;
                            strError = upsertResponse.Error;
                            strObjectName = 'Booking';
                            break;
                        }
                    }
                    //Added by TMA-JK - CRMSS-173 Start
                    if(!bError) {
                        // upsert list of booking room lines
                        listResponses = doUpsertBookingRoomLines(bookingRoomLinesParent);system.debug('### cg listResponses brl'+listResponses);
                        for(UpsertResponse upsertResponse : listResponses) {
                            if(!upsertResponse.Success) {
                                bError = true;
                                strError = upsertResponse.Error;
                                strObjectName = 'Booking Room Line';
                                break;
                            }
                        }    
                    } 
                    //Added by TMA-JK - CRMSS-173 End
                    if(!bError) {
                        // upsert list of booking room lines
                        listResponses = doUpsertBookingRoomLines(bookingRoomLines);system.debug('### cg listResponses brl'+listResponses);
                        for(UpsertResponse upsertResponse : listResponses) {
                            if(!upsertResponse.Success) {
                                bError = true;
                                strError = upsertResponse.Error;
                                strObjectName = 'Booking Room Line';
                                break;
                            }
                        }    
                    } 
                } 
            } else {
                bError = true;
                strError = response.Error;
                strObjectName = 'Master Booking';
            } 
            
            if(bError) {
                Database.rollback(sp);
                mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(false, strMasterExternalId, strError, rowIndex, strObjectName));
            } else {
                mapIndexListResponses.put(rowIndex, new BookingInfoUpsertResponse(true, strMasterExternalId, null, rowIndex, null));
            }
            rowIndex++;
        }
        Log__c log2 = new Log__c();
        log2.WSName__c = 'Booking Info Return';
        insert log2;
        Attachment  doc2 = new Attachment ();
        doc2.Name = 'JsonLog';  
        doc2.Body = Blob.valueOf(Json.serialize(mapIndexListResponses.values()));
        doc2.ContentType = 'text/plain';
        doc2.ParentId = log2.id;
        insert doc2;        
        //Add for logs End
        system.debug('### cg mapIndexListResponses'+mapIndexListResponses);
        return mapIndexListResponses.values();
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
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + roomLine.ExternalId ));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified : ' + roomLine.ExternalId ));
                        mapExternalBookingRoomLinesToTreat.remove(roomLine.ExternalId);
                    } else {    
                        mapBookingRoomLineRowIndex.put(roomLine.ExternalId, rowIndex);
                        mapExternalBookingRoomLinesToTreat.put(roomLine.ExternalId, roomLine.mapSFFields());
                        mapResponses.put(rowIndex, null); 
                    }
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified' ));
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
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + masterBooking.ExternalId ));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + masterBooking.ExternalId ));
                        mapExternalMasterBookingsToTreat.remove(masterBooking.ExternalId);
                    } else {
                        mapMasterRowIndex.put(masterBooking.ExternalId, rowIndex);
                        mapExternalMasterBookingsToTreat.put(masterBooking.ExternalId, masterBooking.mapSFFields());
                        mapResponses.put(rowIndex, null);
                    }
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified' ));
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
        system.debug('Bookings' + Bookings);
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
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + booking.ExternalId ));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + booking.ExternalId ));
                        mapExternalBookingsToTreat.remove(booking.ExternalId);
                    } else {
                        mapBookingRowIndex.put(booking.ExternalId, rowIndex);
                        mapExternalBookingsToTreat.put(booking.ExternalId, booking.mapSFFields());
                        mapResponses.put(rowIndex, null); 
                    }
                } else {
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified' )); 
                }
            }catch(Exception ex) {
                mapResponses.put(rowIndex, new UpsertResponse(false,booking.ExternalId , rowIndex, ex.getMessage()));
            }finally {
                rowIndex ++;    
            }
        }
        system.debug('mapExternalBookingsToTreat.values()' + mapExternalBookingsToTreat.values());
        doUpsertRecords(mapExternalBookingsToTreat.values(), 'Opportunity', mapResponses, mapBookingRowIndex);
        return mapResponses.values();
    }
    
    webservice static List<UpsertResponse> doUpsertPersonAccounts(PersonAccounts PersonAccounts) {  
        Map<Integer, UpsertResponse> mapResponses = new Map<Integer, UpsertResponse>();
        List<PersonAccount> listPersonAccounts = PersonAccounts.PersonAccount;
       
        //Added by TMA-JK CG CRMSS-160 Start
        Set<String> setEmail = new Set<String>();
        Set<String> setExtID = new Set<String>();
        
        if(!FromBookingInfo){
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
            for(PersonAccount guestAccount : listPersonAccounts) {
                setEmail.add(guestAccount.Email.tolowercase());
                setExtID.add(guestAccount.ExternalId);
            }
            
            matchGuestAccounts(setEmail,setExtID,mapEmailSFID,mapExtIDSFID);
        }
        //Added by TMA-JK CG CRMSS-160 End

        Map<String, Account> mapExternalAccountsToTreat = new Map<String, Account>();
        Map<String, Integer> mapPersonRowIndex = new Map<String, Integer>();        
        Integer existingIndex = 0;
        Integer rowIndex = 0;
        
        
        for(PersonAccount guestAccount : listPersonAccounts) {
            try {
                if(String.isNotBlank(guestAccount.ExternalId)) {
                    if(mapExternalAccountsToTreat.containsKey(guestAccount.ExternalId)) {
                        existingIndex = mapPersonRowIndex.get(guestAccount.ExternalId);
                        mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId ));
                        mapResponses.put(existingIndex, new UpsertResponse(false,null , existingIndex, 'Duplicate external id specified: ' + guestAccount.ExternalId ));
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
                    mapResponses.put(rowIndex, new UpsertResponse(false,null , rowIndex, 'ExternalId__c not specified' ));
                }
            }catch(Exception ex) {
                mapResponses.put(rowIndex, new UpsertResponse(false,guestAccount.ExternalId , rowIndex, ex.getMessage()));
            }finally {
                rowIndex ++;    
            }
        }
        System.debug('### mapExternalAccountsToTreat.values() ' + mapExternalAccountsToTreat.values());
        doUpsertRecords(mapExternalAccountsToTreat.values(), 'Account', mapResponses, mapPersonRowIndex);    
        if(!FromBookingInfo){
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
           }
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
        
        public BookingInfoUpsertResponse(){}
        
        public BookingInfoUpsertResponse(boolean isSuccess, String masterExternalId, String strError, Integer rowIndex, String strErrorObject) {
            Success = isSuccess;
            MasterBookingExternalId = masterExternalId;
            Error = strError;
            Index = rowIndex;
            ErrorOnObject = strErrorObject;
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