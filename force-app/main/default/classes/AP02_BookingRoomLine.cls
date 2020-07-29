/**
* @description This class is used to calculate #breakfasts and #chambres on bookings according to their attached booking room lines CRMSS - 400
* @author : TMA EIL JK
* @date 12/12/2019
* @Test Class: BatchReprise_BRLtoBooking_Test
* @coverage:92%
*/

public without sharing class AP02_BookingRoomLine {
    
    //start added by JKA CRMSS-400
    
    public static Map<String,String> bookingRoomLine(List<Booking_Room_Line__c> listBRL, Set<String> SetBookingIDs ){
        system.debug('### jka in ap02');
        
        Database.SaveResult[] srListB;//For dynamic Update
        Map<String,String> mapBIdErrors = new Map<String,String>();
        
        //list of BookingLinesCustomSettings from the custom settings 
        
        //added by TMA EIL CRMSS-469 24-02-2020 Start
        //List<BookingLinesCustomSettings__c> breakFastRoomCodes = BookingLinesCustomSettings__c.getall().values();
        List<BookingLinesCustomSettingsmdt__mdt> breakFastRoomCodes = new List <BookingLinesCustomSettingsmdt__mdt>([select Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Breakfast_Room_Code__c, Chamre_Room_Code__c from BookingLinesCustomSettingsmdt__mdt]);
        //added by TMA EIL CRMSS-469 24-02-2020 end
        
        //list of breakfastRoomCodes from the custom settings too
        List<string> breakfastRoomCodesStr = new List<string> ();
        //list of ChambreRoomCodes from the custom settings too
        List<string> ChambreRoomCodesStr = new List<string> ();
        
        List<Booking_Room_Line__c> listBookingRoomsChambre =new List<Booking_Room_Line__c>();
        
        if(breakFastRoomCodes!=null && breakFastRoomCodes.Size()>0) {
            //the BookingLinesCustomSettings list could contain Breakfast Room Code and/or Chambre Room Code
            
            //added by TMA EIL CRMSS-469 24-02-2020 Start
            //for(BookingLinesCustomSettings__c breakFastRoomCode: breakFastRoomCodes)
            //{  
            for(BookingLinesCustomSettingsmdt__mdt breakFastRoomCode: breakFastRoomCodes)
            { 
                //if it contains a Breakfast Room Code, the value of the Breakfast_Room_Code__c will be filled in the breakfastRoomCodesStrList
                if(breakFastRoomCode.Breakfast_Room_Code__c != null){
                    breakfastRoomCodesStr.add(breakFastRoomCode.Breakfast_Room_Code__c);
                   system.debug('BRC' +breakfastRoomCodesStr);
                }
                //if it contains a Chamre Room Code, the value of the ChamreRoomCode__c will be filled in the ChambreRoomCodesStr
                //added by TMA EIL CRMSS-469 24-02-2020 Start
                //if(breakFastRoomCode.ChamreRoomCode__c != null){
                    if(breakFastRoomCode.Chamre_Room_Code__c != null){
                    //ChambreRoomCodesStr.add(breakFastRoomCode.ChamreRoomCode__c);
                    ChambreRoomCodesStr.add(breakFastRoomCode.Chamre_Room_Code__c);
                }
                //added by TMA EIL CRMSS-469 24-02-2020 end
                
            }
            
            // get room booking lines that have breakfast room codes
            List<Booking_Room_Line__c> listBookingRoomsBreakfasts =new List<Booking_Room_Line__c>();
            
            
            
            
            Pattern patt = Pattern.compile('C\\d{2}');
            Pattern patt2 = Pattern.compile('R\\d{2}');
            list<Opportunity> bookings = new list<Opportunity>();
            if(listBRL != null && listBRL.size()>0){
                for( Booking_Room_Line__c bookingRoomLine : listBRL)   
                { 
                    System.debug('### in listBRL');
                    Matcher pattmatcher;
                    Matcher pattmatcher2;
                    
                    if(bookingRoomLine.Room_code__c != null) {
                        pattmatcher= patt.matcher( bookingRoomLine.Room_code__c );
                    }
                    
                    if(bookingRoomLine.Room_code__c != null) {
                        pattmatcher2= patt2.matcher( bookingRoomLine.Room_code__c );
                    }
                    
                    //if the list breakfastRoomCodesStr contains bookingRoomLine.Room_code__c 
                    if( breakfastRoomCodesStr.contains(bookingRoomLine.Room_code__c ) ){ 
                        System.debug('### in brkfst11');
                        //we will add it to the list listBookingRoomsBreakfasts
                        listBookingRoomsBreakfasts.add(bookingRoomLine);
                    }
                    //if the list ChambreRoomCodesStr contains bookingRoomLine.Room_code__c or the pattern of the room code matches tthe first pattern C12(for ex) or the second one R23 (for ex)
                    if( ChambreRoomCodesStr.contains(bookingRoomLine.Room_code__c ) || ( pattmatcher!= null && pattmatcher.matches()) || (pattmatcher2!= null && pattmatcher2.matches())){ 
                        //we will add it to the list listBookingRoomsChambre
                        listBookingRoomsChambre.add(bookingRoomLine);
                    }   
                }
            }
            //Commented tkt 485
            /*else {
                for(Id book :SetBookingIDs){
                    system.debug('@@@@@@@');
                    Opportunity book1 = new Opportunity();
                    book1.id= book;
                    book1.Chambre__c=0;
                    book1.Breakfasts__c=0;
                    bookings.add(book1);
                }
                system.debug('@@@@@@@ bookings'+bookings);
            }*/
            
            
            if( (listBookingRoomsBreakfasts!=null && listBookingRoomsBreakfasts.Size()>0) || (listBookingRoomsChambre!=null && listBookingRoomsChambre.size()>0) || (bookings !=null && bookings.size()>0)) {
                List<Opportunity> bookingList = new List<Opportunity> (); //contains the number of the breakfast rooms on the bookings
                List<Opportunity> bookingListCH = new List<Opportunity> (); //contains the number of the chambre rooms on the bookings
                Map<id,Opportunity> mapOppToUpdate = new Map<id,Opportunity>();
                
                //Calculate the breakfast number on bookings
                if(listBookingRoomsBreakfasts!=null && listBookingRoomsBreakfasts.Size()>0){
                    system.debug('### listBookingRoomsBreakfasts');
                    bookingList = calculateBreakfast(listBookingRoomsBreakfasts, SetBookingIDs);
                }
                else if((listBookingRoomsBreakfasts==null || listBookingRoomsBreakfasts.Size()<=0)&& (listBookingRoomsChambre!= null && listBookingRoomsChambre.Size()>0)&&(SetBookingIDs!=null && SetBookingIDs.size()>0)) {
                    for(Id book :SetBookingIDs){
                        Opportunity book1 = new Opportunity();
                        book1.id= book;
                        //Commented tkt 485
                        //book1.Breakfasts__c=0;
                        bookingList.add(book1);
                    }
                }
                //Calculate the room number on bookings
                if(listBookingRoomsChambre!= null && listBookingRoomsChambre.Size()>0){
                    bookingListCH = calculateRoom(listBookingRoomsChambre,  SetBookingIDs);
                }
                else if ((listBookingRoomsChambre== null || listBookingRoomsChambre.Size()<=0)&& (listBookingRoomsBreakfasts!=null && listBookingRoomsBreakfasts.Size()>0)&&(SetBookingIDs!=null && SetBookingIDs.size()>0)){
                    for(Id book :SetBookingIDs){
                        Opportunity book1 = new Opportunity();
                        book1.id= book;
                        //Commented tkt 485
                        //book1.Chambre__c=0;
                        bookingListCH.add(book1);
                    }
                }
                
                system.debug('### bookings b4 update'+bookings);
                //update the bookings
                if(bookingList.Size()>0 || bookingListCH.size()>0 || bookings.size()>0 ){
                    system.debug('@@@@@@@UPDATEEEE');
                    for(Opportunity opp : bookingList){
                        If(!mapOppToUpdate.containskey(opp.id)){
                            mapOppToUpdate.put(opp.id,opp);
                        }
                        else{
                            Opportunity oppMap = mapOppToUpdate.get(opp.id);
                            oppMap.Breakfasts__c = opp.Breakfasts__c;
                            mapOppToUpdate.put(opp.id,oppMap);
                        }
                    }
                    for(Opportunity opp : bookingListCH){
                        If(!mapOppToUpdate.containskey(opp.id)){
                            mapOppToUpdate.put(opp.id,opp);
                        }else{
                            Opportunity oppMap = mapOppToUpdate.get(opp.id);
                            oppMap.Chambre__c = opp.Chambre__c;
                            mapOppToUpdate.put(opp.id,oppMap);
                        }
                    }
                    for(Opportunity opp : bookings){
                        system.debug('### bookings');
                        // the mapOppToUpdate will not contain opp.id all the time (so there is no else condition)
                        If(!mapOppToUpdate.containskey(opp.id)){
                            mapOppToUpdate.put(opp.id,opp);
                            System.debug('###@@@');
                        }
                    }
                    
                    try{
                        if(Limits.getDMLStatements() < Limits.getLimitDmlStatements()){
                            //lst of booking to update
                            srListB=database.update(mapOppToUpdate.values(), false);
                            for(Integer i=0; i < (mapOppToUpdate.values()).size(); i++){
                                system.debug('### jka looping saveresults');
                                Database.SaveResult sr = srListB[i];
                                
                                Opportunity Book = (mapOppToUpdate.values())[i];
                                
                                //if an error occured 
                                if (!sr.isSuccess()){
                                    system.debug('### jka error in saveresult');
                                    Database.Error error = sr.getErrors().get(0);
                                    String errorMsg = error.getMessage();
                                    
                                    mapBIdErrors.put(Book.Id, errorMsg);
                                    
                                } 
                            }
                            
                        }
                    }
                    catch(exception e){
                        system.debug(' ### The following error occured while updating the booking ' + e.getMessage());
                    }
                }
            }
        }
        
        return mapBIdErrors;
    }
    
    public static List<Opportunity> calculateBreakfast(list<Booking_Room_Line__c> listBookingRoomsBreakfasts, Set<String> SetBookingIDs ){
        system.debug('### in calBreak');
        Map<id,decimal> mapBookingToBookingLinesQuantity = new Map<id,decimal>();//map the qty of breakfast on each booking
        decimal bookingLineQuantity = 0;
        
        
        for (Booking_Room_Line__c bookingLine : listBookingRoomsBreakfasts)
        {   
            system.debug('### jka in bkfs ###');
            // The business requires that the minimum allowed quantity for a booking line to be 1.
            bookingLineQuantity = bookingLine.quantity__c == null?  1 : bookingLine.quantity__c ;
            
            if(!mapBookingToBookingLinesQuantity.Containskey(bookingLine.Booking_FK__c)){
                system.debug('### jka in bkfs cond1 ###');
                mapBookingToBookingLinesQuantity.put(bookingLine.Booking_FK__c , bookingLineQuantity);
            }
            
            else{
                system.debug('### jka in bkfs cond2 ###');
                system.debug('### SetBookingIDs'+SetBookingIDs);
                bookingLineQuantity = mapBookingToBookingLinesQuantity.get(bookingLine.Booking_FK__c) + bookingLineQuantity;
            }
            system.debug('### ### ### ###');
            mapBookingToBookingLinesQuantity.put(bookingLine.Booking_FK__c ,(bookingLineQuantity));  
        }
        
        //return list of booking to be updated
        List<Opportunity> bookingList = new List<Opportunity> ();
        
        for(id bookingId: SetBookingIDs){
            system.debug('##### in 0');
            Opportunity booking =   new Opportunity(); 
            booking.id = bookingId;
            if(booking.breakfasts__c == null){
                booking.breakfasts__c = 0;
            }
            //commented tkt 485
            /*if(!mapBookingToBookingLinesQuantity.containsKey(bookingId)){
                system.debug('### in map');
                mapBookingToBookingLinesQuantity.put(bookingId,0);
            }
            else{*/
            if (mapBookingToBookingLinesQuantity.containsKey(bookingId)){
                system.debug('###listBookingRoomsBreakfasts'+listBookingRoomsBreakfasts);
                system.debug('###bookingId'+bookingId);
                system.debug('### in map2');
                booking.breakfasts__c = mapBookingToBookingLinesQuantity.get(bookingId);
                system.debug('### mapBookingToBookingLinesQuantity.get(bookingId);');
            }
            
            
            bookingList.add(booking);
        }
        
        return bookingList;
        
        
    }
    
    public static List<Opportunity> calculateRoom (list<Booking_Room_Line__c> listBookingRoomsChambre, Set<String> SetBookingIDs){
        
        //Calculation of room #
        Map<id,decimal> mapBookingToBookingLinesQuantity = new Map<id,decimal>();
        decimal bookingLineQuantity = 0;
        
        for (Booking_Room_Line__c bookingLine : listBookingRoomsChambre)
        {   
            bookingLineQuantity = bookingLine.quantity__c == null?  1 : bookingLine.quantity__c ;
            // The business requires that the minimum allowed quantity for a booking line to be 1.
            
            
            if(!mapBookingToBookingLinesQuantity.Containskey(bookingLine.Booking_FK__c)){
                
                mapBookingToBookingLinesQuantity.put(bookingLine.Booking_FK__c , bookingLineQuantity);
            }
            
            else{
                bookingLineQuantity = mapBookingToBookingLinesQuantity.get(bookingLine.Booking_FK__c) + bookingLineQuantity;
            }
            mapBookingToBookingLinesQuantity.put(bookingLine.Booking_FK__c ,(bookingLineQuantity));  
        }
        
        //return list of booking to be updated
        List<Opportunity> bookingListCH = new List<Opportunity> ();
        for(id bookingId: SetBookingIDs){
            
            Opportunity booking =   new Opportunity(); 
            booking.id = bookingId;
            if(booking.Chambre__c == null){
                booking.Chambre__c = 0;
            }
             //commented tkt 485
            /*if(!mapBookingToBookingLinesQuantity.containsKey(bookingId)){
                mapBookingToBookingLinesQuantity.put(bookingId,0);
            }
            
            else{*/
            if(mapBookingToBookingLinesQuantity.containsKey(bookingId)){
                booking.Chambre__c = mapBookingToBookingLinesQuantity.get(bookingId);
            }
            bookingListCH.add(booking);
        }
        
        return bookingListCH;
    }
    
    // end added by JKA CRMSS-400
    
}