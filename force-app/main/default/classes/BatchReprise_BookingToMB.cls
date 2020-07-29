/*
* Description: Batch Reprise to calculate data on a master booking and a person account according to their related bookings CRMSS - 374
               Data calculated is realted to the following tickets: CRMSS-264-247-292-248-249-250-251-252-253-255
* @author: TMA-EIL CG
* @date: 27/11/2019
* @Test: BatchReprise_BookingToMB_Test
* @Coverage: 89%
*/

Global without sharing class BatchReprise_BookingToMB implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String,String> mapBookingOrPaId = new Map<String,String>();
    global Integer Counter;
    
    global BatchReprise_BookingToMB(map<String, String> mapBookingOrPaId, integer counter) {
        
        system.debug('### cg in constructor');
        this.Counter = counter;
        this.mapBookingOrPaId= new Map<String,String>();
        
        if(mapBookingOrPaId != null && mapBookingOrPaId.size()>0){
            
            this.mapBookingOrPaId= mapBookingOrPaId;
        }  
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('### cg in start');
        String StaticListID = Label.BatchRepBookingToMb_Ids;system.debug('### cg StaticListID'+StaticListID);
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            system.debug('### cg what wre u doing here');
            liststaticId = StaticListID.split(',');
        }
        string query;
        
        //Query on opportunities of record type bookings to retrieve all data to be used
        if((mapBookingOrPaId == null || mapBookingOrPaId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            system.debug('### cg map and list null');
            query = 'select id, Master_Booking_FK__c, StageName, Confirmation_Number__c, Hotel_Name__c, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Confirmation_Number__c, Master_Booking_FK__r.Hotel_Name_MB__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c from opportunity where RecordType.DeveloperName=\'Booking\' and Master_Booking_FK__c != null';
        }
        else if(mapBookingOrPaId != null && mapBookingOrPaId.size()>0){
            
            set<string> setBookingOrPaId = mapBookingOrPaId.keyset();
            query = 'select id, Master_Booking_FK__c, StageName, Confirmation_Number__c, Hotel_Name__c, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Confirmation_Number__c, Master_Booking_FK__r.Hotel_Name_MB__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c from opportunity where RecordType.DeveloperName=\'Booking\' and Master_Booking_FK__c != null and Master_Booking_FK__c in: setBookingOrPaId'; 
        }
        else if(liststaticId != null && liststaticId.size() > 0){
            
            query = 'select id, Master_Booking_FK__c, StageName, Confirmation_Number__c, Hotel_Name__c, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Confirmation_Number__c, Master_Booking_FK__r.Hotel_Name_MB__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c from opportunity where RecordType.DeveloperName=\'Booking\' and Master_Booking_FK__c != null and Master_Booking_FK__c in: liststaticId'; 
        }
        
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
       
        list<Opportunity> listOppInLot = new list<Opportunity>([select id, Booking_Person_account__c, Booking_Person_account__r.Tech_HotelCount__c, Booking_Person_account__r.Hotels_Count__c, Master_Booking_FK__c, StageName, Confirmation_Number__c, Hotel_Name__c,Hotel_ID__c, Hotel__c, Number_of_nights__c, Chambre__c, Master_Booking_FK__r.Confirmation_Number__c, Master_Booking_FK__r.Hotel_Name_MB__c, Master_Booking_FK__r.Number_of_nights_master__c, Master_Booking_FK__r.Rooms__c, Master_Booking_FK__r.Bookings_Booked_Count__c, Master_Booking_FK__r.Bookings_Cancelled_Count__c, Master_Booking_FK__r.Bookings_Checked_Count__c, Master_Booking_FK__r.Bookings_Error_Count__c, Master_Booking_FK__r.Bookings_No_Show_Count__c 
                                                                from opportunity 
                                                                where RecordType.DeveloperName='Booking' and (Master_Booking_FK__c != null or Booking_Person_account__c != null) and ID IN: listBookings]);
        
        //For MBs update
        list<Opportunity> listMtoUpdate = new list<opportunity>();
        map<String,list<Opportunity>> mapMBlistBookings = new map<string,list<opportunity>>();
        
        //We need to filter and organise the retrieved data in the correspondant maps
        if(listOppInLot != null && listOppInLot.size()>0){
            
            for(Opportunity book : listOppInLot){
                
                //Organise data related to MBs update
                if(book.Master_Booking_FK__c != null){
                    
                    if(!mapMBlistBookings.containskey(book.Master_Booking_FK__c)){
              
                               list<Opportunity> listToPut = new list<opportunity>();
                               listToPut.add(book);
                               mapMBlistBookings.put(book.Master_Booking_FK__c, listToPut);
                           
                    }
                    else{
                        
                        list<Opportunity> listToPut = mapMBlistBookings.get(book.Master_Booking_FK__c);
                        listToPut.add(book);
                        mapMBlistBookings.put(book.Master_Booking_FK__c, listToPut);
                    }
                }
                
            }
        }
        
        //Calculate data related to MBs update
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            for(String mbId : mapMBlistBookings.Keyset()){
                
                Decimal sumNights = 0;
                Decimal sumChambres = 0;
                Decimal countBooked = 0;
                Decimal countChecked = 0;
                Decimal countCancelled = 0;
                Decimal countError = 0;
                Decimal countNoShow = 0;
                String confNumb = '';
                String hotelName = '';
                system.debug('### cg mapMBlistBookings.get(mbId)'+mapMBlistBookings.get(mbId));
                for(Opportunity book : mapMBlistBookings.get(mbId)){
                    system.debug('### cg in for book');
                    //Calculate the counts related to the StageName
                    
                    //We need to check these conditions in the first place, in order to not erase existing data on the fields in question
                    if(book.Master_Booking_FK__r.Bookings_Booked_Count__c != null && book.Master_Booking_FK__r.Bookings_Booked_Count__c != 0){
                        
                        countBooked = book.Master_Booking_FK__r.Bookings_Booked_Count__c;
                    }
                    if(book.Master_Booking_FK__r.Bookings_Checked_Count__c != null && book.Master_Booking_FK__r.Bookings_Checked_Count__c != 0){
                        
                        countChecked = book.Master_Booking_FK__r.Bookings_Checked_Count__c;
                    }
                    if(book.Master_Booking_FK__r.Bookings_Cancelled_Count__c != null && book.Master_Booking_FK__r.Bookings_Cancelled_Count__c != 0){
                        
                        countCancelled = book.Master_Booking_FK__r.Bookings_Cancelled_Count__c;
                    }
                    if(book.Master_Booking_FK__r.Bookings_Error_Count__c != null && book.Master_Booking_FK__r.Bookings_Error_Count__c != 0){
                        
                        countError = book.Master_Booking_FK__r.Bookings_Error_Count__c;
                    }
                    if(book.Master_Booking_FK__r.Bookings_No_Show_Count__c != null && book.Master_Booking_FK__r.Bookings_No_Show_Count__c != 0){
                        
                        countNoShow = book.Master_Booking_FK__r.Bookings_No_Show_Count__c;
                    }
                    
                    //Then we calculate the values according to these conditions
                    if(book.StageName == 'Booked'){
                        
                        if(book.Master_Booking_FK__r.Bookings_Booked_Count__c == null || book.Master_Booking_FK__r.Bookings_Booked_Count__c == 0){
                            countBooked++;system.debug('### cg countBooked'+countBooked);
                        }
                        else{
                            countBooked = book.Master_Booking_FK__r.Bookings_Booked_Count__c;system.debug('### cg countBooked filled'+countBooked);
                            countBooked++;
                        }
                    }
                    
                    if(book.StageName == 'Checked'){
                        
                        if(book.Master_Booking_FK__r.Bookings_Checked_Count__c == null || book.Master_Booking_FK__r.Bookings_Checked_Count__c == 0){
                            countChecked++;system.debug('### cg countChecked'+countChecked);
                        }
                        else{
                            countChecked = book.Master_Booking_FK__r.Bookings_Checked_Count__c;system.debug('### cg countChecked filled'+countChecked);
                            countChecked++;
                        }
                    }
                    
                    if(book.StageName == 'Cancelled'){
                        
                        if(book.Master_Booking_FK__r.Bookings_Cancelled_Count__c == null || book.Master_Booking_FK__r.Bookings_Cancelled_Count__c == 0){
                            countCancelled++;system.debug('### cg countCancelled'+countCancelled);
                        }
                        else{
                            countCancelled = book.Master_Booking_FK__r.Bookings_Cancelled_Count__c;system.debug('### cg countCancelled filled'+countCancelled);
                            countCancelled++;
                        }
                    }
                    
                    if(book.StageName == 'Error'){
                        
                        if(book.Master_Booking_FK__r.Bookings_Error_Count__c == null || book.Master_Booking_FK__r.Bookings_Error_Count__c == 0){
                            countError++;system.debug('### cg countError'+countError);
                        }
                        else{
                            countError = book.Master_Booking_FK__r.Bookings_Error_Count__c;system.debug('### cg countError filled'+countError);
                            countError++;
                        }
                    }
                    
                    if(book.StageName == 'No Show'){
                        
                        if(book.Master_Booking_FK__r.Bookings_No_Show_Count__c == null || book.Master_Booking_FK__r.Bookings_No_Show_Count__c == 0){
                            countNoShow++;system.debug('### cg countNoShow'+countNoShow);
                        }
                        else{
                            countNoShow = book.Master_Booking_FK__r.Bookings_No_Show_Count__c;system.debug('### cg countNoShow filled'+countNoShow);
                            countNoShow++;
                        }
                    }
                    
                    //Calculate the number of nights
                    if(book.Number_of_nights__c != null){
                        
                        if(book.Master_Booking_FK__r.Number_of_nights_master__c == null || book.Master_Booking_FK__r.Number_of_nights_master__c == 0){
                            sumNights+= book.Number_of_nights__c;system.debug('### cg sumNights'+sumNights);
                        }
                        else{
                            sumNights = book.Master_Booking_FK__r.Number_of_nights_master__c;system.debug('### cg sumNights filled'+sumNights);
                            sumNights++;
                        }
                    }
                    
                    //Calculate the number of rooms
                    if(book.Chambre__c != null){
                        
                        if(book.Master_Booking_FK__r.Rooms__c == null || book.Master_Booking_FK__r.Rooms__c == 0){
                            sumChambres+= book.Chambre__c;system.debug('### cg sumChambres'+sumChambres);
                        }
                        else{
                            sumChambres = book.Master_Booking_FK__r.Rooms__c;system.debug('### cg sumChambres filled'+sumChambres);
                            sumChambres++;
                        }
                    }
                    
                    //Calculate the Confirmation number
                    if( (book.Master_Booking_FK__r.Confirmation_Number__c  == null || book.Master_Booking_FK__r.Confirmation_Number__c == '') && (book.Confirmation_Number__c != null && book.Confirmation_Number__c != '') ){
                        
                        book.Master_Booking_FK__r.Confirmation_Number__c = book.Confirmation_Number__c;
                        confNumb = book.Confirmation_Number__c;system.debug('### cg confNumb'+confNumb);
                    }
                    else if(book.Master_Booking_FK__r.Confirmation_Number__c != null && book.Master_Booking_FK__r.Confirmation_Number__c != ''){
                        
                        confNumb = book.Master_Booking_FK__r.Confirmation_Number__c;system.debug('### cg confNumb filled'+confNumb);
                    }
                    
                    //Calculate the Hotel Name
                    if( (book.Master_Booking_FK__r.Hotel_Name_MB__c  == null || book.Master_Booking_FK__r.Hotel_Name_MB__c == '') && (book.Hotel_Name__c != null && book.Hotel_Name__c != '') ){
                        
                        book.Master_Booking_FK__r.Hotel_Name_MB__c = book.Hotel_Name__c;
                        hotelName = book.Hotel_Name__c;system.debug('### cg hotelName'+hotelName);
                    }
                    else if(book.Master_Booking_FK__r.Hotel_Name_MB__c != null && book.Master_Booking_FK__r.Hotel_Name_MB__c != ''){
                        
                        hotelName = book.Master_Booking_FK__r.Hotel_Name_MB__c;system.debug('### cg hotelName filled'+hotelName);
                    }
                }
                
                //Fill the calculated info in the corresponding fields of the master booking
                Opportunity mbOpp = new Opportunity();
                mbOpp.Id = mbId;
                mbOpp.Bookings_Booked_Count__c = countBooked;system.debug('### cg mbOpp.Bookings_Booked_Count__c'+mbOpp.Bookings_Booked_Count__c);
                mbOpp.Bookings_Checked_Count__c = countChecked;system.debug('### cg mbOpp.Bookings_Checked_Count__c'+mbOpp.Bookings_Checked_Count__c);
                mbOpp.Bookings_Cancelled_Count__c = countCancelled;system.debug('### cg mbOpp.Bookings_Cancelled_Count__c'+mbOpp.Bookings_Cancelled_Count__c);
                mbOpp.Bookings_Error_Count__c = countError;system.debug('### cg mbOpp.Bookings_Error_Count__c'+mbOpp.Bookings_Error_Count__c);
                mbOpp.Bookings_No_Show_Count__c = countNoShow;system.debug('### cg mbOpp.Bookings_No_Show_Count__c'+mbOpp.Bookings_No_Show_Count__c);
                mbOpp.Number_of_nights_master__c = sumNights;system.debug('### cg mbOpp.Number_of_nights_master__c'+mbOpp.Number_of_nights_master__c);
                mbOpp.Rooms__c = sumChambres;system.debug('### cg mbOpp.Rooms__c'+mbOpp.Rooms__c);
                mbOpp.Confirmation_Number__c = confNumb;system.debug('### cg mbOpp.Confirmation_Number__c'+mbOpp.Confirmation_Number__c);
                mbOpp.Hotel_Name_MB__c = hotelName;system.debug('### cg mbOpp.Hotel_Name_MB__c'+mbOpp.Hotel_Name_MB__c);
                
                listMtoUpdate.add(mbOpp); 
            }
        }
        
        Database.SaveResult[] srListMB;
        
        //Update the MBs
        if(listMtoUpdate != null && listMtoUpdate.size()>0){
           
            srListMB = Database.update(listMtoUpdate, false);
        }
        
        for(Integer i=0; i < listMtoUpdate.size(); i++){
            system.debug('### cg looping saveresults');
            Database.SaveResult sr = srListMB[i];
            
            Opportunity MBook = listMtoUpdate[i];
            system.debug('### cg MBook'+MBook);
            
            if (!sr.isSuccess()){
                system.debug('### cg error in saveresult');
                Database.Error error = sr.getErrors().get(0);
                String errorMsg = error.getMessage();
                
                system.debug('### cg Failed Book.Id'+MBook.Id);
                system.debug('### cg mapBookingOrPaId 1 '+mapBookingOrPaId);
                mapBookingOrPaId.put(MBook.Id, errorMsg);
                system.debug('### cg mapBookingOrPaId 2 '+mapBookingOrPaId);
            }
            
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        
         if (counter < 2){
            
            counter ++;
            
             if(mapBookingOrPaId != null && mapBookingOrPaId.size()>0){
                 
                 BatchReprise_BookingToMB batchObj = new BatchReprise_BookingToMB(mapBookingOrPaId,counter);
                 DataBase.executeBatch(batchObj);
             }
            system.debug('### cg counter'+counter + '### cg mapBookingOrPaId when constructor called from finish'+mapBookingOrPaId);
        }
        else{
            system.debug('### cg in send email');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'cynthia.geagea@ei-technologies.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Error : BatchReprise_BookingToMB ' );
            
            if(mapBookingOrPaId != null && mapBookingOrPaId.size()>0){
                
                String body = 'Total:' +'  '+ mapBookingOrPaId.size() +'  '+ ' records not updated sucessfully';
                
                for (String failedId : mapBookingOrPaId.keySet()){
                    
                    body+='\n'+failedId + ' reason : ' + mapBookingOrPaId.get(failedId); 
                }
                
                mail.setPlainTextBody(body);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            system.debug('### cg email sent');
        }
    }
    
}