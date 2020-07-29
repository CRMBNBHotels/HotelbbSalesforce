global class Batch_AP06_Stay implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        /*
        User currUser = new User();
        currUser.id = userinfo.getUserId();
        currUser.BypassProcessBuilder__c = true;
        currUser.BypassValidationRule__c = true;
        currUser.BypassWorkflow__c = true;
        update currUser;
        
        string query='Select Id From Account'+
            ' where recordtypeId = \'' + Label.PersonAccountRecordTypeId + '\'';
        system.debug('query' + query);
        return Database.getQueryLocator(query);
	*/
        return null;
    }
    global void execute(Database.BatchableContext BC, list<Account> listAffectedAccount)
    {        
        /*
        if(listAffectedAccount.size() > 0)
        {            
            System.debug('##### AP06_Stay listAffectedAccount ' + listAffectedAccount);
            //Map each account to its corresponding bookings through Stays__r
            Id accId;
            map<Id,set<Id>> mapAccountBookings = new map<Id,set<Id>>();
            Set<Id> listBookingIdToSelect = new Set<Id>();
            
            List<stay__c> ListStay = [Select Id,Booking__c,Guest_account__c 
                                      From stay__c 
                                      where Booking__c != null and Guest_account__c!= null and
                                      Guest_account__c  in :listAffectedAccount];
            
            
            for(Stay__c stay:ListStay)
            {
                if(String.isNotBlank(stay.Booking__c)) listBookingIdToSelect.add(stay.Booking__c);
                if(!mapAccountBookings.containsKey(stay.Guest_account__c))
                {
                    mapAccountBookings.put(stay.Guest_account__c,new Set<id> {stay.Booking__c}); 
                }else{
                    Set<id> tempid =  mapAccountBookings.get(stay.Guest_account__c);
                    tempid.add(stay.Booking__c);
                    mapAccountBookings.put(stay.Guest_account__c,tempid);   
                }
            }
            
            //Get the Booking Room Line That are affected
            map<Id,list<Booking_Room_Line__c>> mapBookingToBookingRoomLines = new map<Id,list<Booking_Room_Line__c>>();
            list<Booking_Room_Line__c> listBRL = new list<Booking_Room_Line__c>();
            listBRL = [Select Id,Room_code__c,Booking_FK__c
                       From Booking_room_line__c
                       Where Room_code__c != null and Booking_FK__c IN: listBookingIdToSelect];
            list<Booking_Room_Line__c> listBRLToBooking = new list<Booking_Room_Line__c>();
            for(Booking_room_line__c bookingRL : listBRL)
            {
                if(!mapBookingToBookingRoomLines.containsKey(bookingRL.Booking_FK__c) && String.isNotBlank(bookingRL.Booking_FK__c))
                {
                    listBRLToBooking = new list<Booking_Room_Line__c>();
                    listBRLToBooking.add(bookingRL);
                    mapBookingToBookingRoomLines.put(bookingRL.Booking_FK__c,listBRLToBooking);
                } else {
                    listBRLToBooking = mapBookingToBookingRoomLines.get(bookingRL.Booking_FK__c);
                    listBRLToBooking.add(bookingRL);
                    mapBookingToBookingRoomLines.put(bookingRL.Booking_FK__c,listBRLToBooking);
                }
            }
            //Assign each account to the related Booking Room Line
            map<Id,list<Booking_Room_Line__c>> mapAccountToBookingRoomLine = new map<Id,list<Booking_Room_Line__c>>();
            for(Account acc: listAffectedAccount)
            {
                set<Id> listBookingId = mapAccountBookings.get(acc.Id);
                if(listBookingId!=null){
                   for(Id bookingId : listBookingId)
                {
                    if(!mapAccountToBookingRoomLine.containsKey(acc.Id))
                    {
                        mapAccountToBookingRoomLine.put(acc.Id,new list<Booking_Room_Line__c>());
                    }
                    if(mapBookingToBookingRoomLines.containsKey(bookingId))
                        mapAccountToBookingRoomLine.get(acc.Id).addAll(mapBookingToBookingRoomLines.get(bookingId));  
                } 
                }
                
            }
            System.debug('##### AP06_Stay listBRL ' + listBRL);
            //map each room code to its room code and option record
            list<string> listRoomCode = new list<string>();
            for(Booking_Room_Line__c BRL: listBRL)
            {
             if(String.isNotBlank(BRL.Room_code__c))listRoomCode.add(BRL.Room_code__c); 
            }
             list<Hotel_Room_Option__c> listRoomCodeAndOption= new list<Hotel_Room_Option__c>();
            if(listRoomCode!= null && listRoomCode.size()>0){
               listRoomCodeAndOption = [Select Id,Room_code__c,Type_code__c,Room_Type__c,
                                                                Room_Type_Label__c,Room_Code_Label__c
                                                                From Hotel_Room_Option__c
                                                                Where Room_code__c IN: listRoomCode];  
            }
            
            System.debug('##### AP06_Stay listRoomCodeAndOption ' + listRoomCodeAndOption);
            map<string,Hotel_Room_Option__c> mapRoomCodeToRoomCodeAndOption = new map<string,Hotel_Room_Option__c>();
            for(Hotel_Room_Option__c roomCodeAndOption : listRoomCodeAndOption)
            {
                if(!mapRoomCodeToRoomCodeAndOption.containsKey(roomCodeAndOption.Room_code__c))
                {
                    mapRoomCodeToRoomCodeAndOption.put(roomCodeAndOption.Room_code__c,roomCodeAndOption);
                }
            }
            string roomCode;
            Hotel_Room_Option__c hotelRoomOption;
            string type;
            integer count;
            list<Account> listAccountToUpdate = new list<Account>();
            for(Account acc : listAffectedAccount)
            {
                map<string,integer> mapRoomCount = new map<string,integer>();
                map<string,integer> mapOptionCount = new map<string,integer>(); 
                list<Booking_room_line__c> listBookingRoomLine = mapAccountToBookingRoomLine.get(acc.Id);
                if(listBookingRoomLine != null)
                {
                    for(Booking_Room_Line__c BRL: listBookingRoomLine)
                    {
                        roomCode = BRL.Room_code__c;
                        if(mapRoomCodeToRoomCodeAndOption.containsKey(roomCode))
                        {
                            hotelRoomOption = mapRoomCodeToRoomCodeAndOption.get(roomCode);
                            type = hotelRoomOption.Type_code__c;
                        }
                        else
                        {
                            hotelRoomOption = null;
                            type = null; 
                        }
                        if((type == label.TypeCodeRoom || hotelRoomOption == null) && !string.IsBlank(roomCode))
                        {
                            if(!mapRoomCount.containsKey(roomCode))
                            {
                                mapRoomCount.put(roomCode,0); 
                            }
                            count =  mapRoomCount.get(roomCode) + 1;
                            mapRoomCount.put(roomCode, count);
                        }
                        if((type == label.TypeCodeOption || hotelRoomOption == null) && !string.IsBlank(roomCode))
                        {
                            if(!mapOptionCount.containsKey(roomCode))
                            {
                                mapOptionCount.put(roomCode,0); 
                            }
                            count =  mapOptionCount.get(roomCode) + 1;
                            mapOptionCount.put(roomCode, count);                            
                        }
                    }
                }
                //Clear all values to recalculate them
                clearAllFavorites(acc);
                //Get the most used Room Room Code
                integer maxValue=0;
                string maxRoomCode;               
                for(string key:mapRoomCount.keySet())
                {
                    if(mapRoomCount.get(key) > maxValue){
                        maxRoomCode = key;
                        maxValue=mapRoomCount.get(key); 
                    }
                }
                //populate the favorite room type and room type label
                if(mapRoomCodeToRoomCodeAndOption.containsKey(maxRoomCode))
                {
                    hotelRoomOption = mapRoomCodeToRoomCodeAndOption.get(maxRoomCode);
                    acc.Favorite_Room_type__pc = hotelRoomOption.Room_Type__c;
                    acc.Favorite_Room_type_Label__pc = hotelRoomOption.Room_Type_Label__c;                    
                }
                else
                {
                    if(maxRoomCode != null)
                    {
                        acc.Favorite_Room_type__pc = label.UnknownProduct; 
                    }
                }
                //Sort the option Room Code from the most used to the least used
                list<OptionWrapper> listOptionRoomCode = new list<OptionWrapper>();
                for(string key:mapOptionCount.keySet())
                {
                    listOptionRoomCode.add(new OptionWrapper(key,mapOptionCount.get(key)));
                }
                integer listSize = listOptionRoomCode.size();   
                if(listSize > 1)
                {
                    listOptionRoomCode.sort(); 
                }       
                //get the first option
                if(listSize > 0)
                {
                    roomCode = listOptionRoomCode[listSize-1].roomCode;
                    if(!mapRoomCodeToRoomCodeAndOption.containsKey(roomCode))
                    {
                        acc.Favorites_option_type__pc = label.UnknownProduct;
                    }
                    else
                    {
                        hotelRoomOption = mapRoomCodeToRoomCodeAndOption.get(roomCode);
                        acc.Favorites_option_type__pc = roomCode;
                        acc.Favorites_option_1_Label__pc = hotelRoomOption.Room_Code_Label__c;
                    }
                    //get the second option
                    if(listOptionRoomCode.size() > 1)
                    {
                        roomCode = listOptionRoomCode[listSize-2].roomCode;
                        if(!mapRoomCodeToRoomCodeAndOption.containsKey(roomCode))
                        {
                            acc.Favorites_option_2__pc = label.UnknownProduct;
                        }
                        else
                        {
                            hotelRoomOption = mapRoomCodeToRoomCodeAndOption.get(roomCode);
                            acc.Favorites_option_2__pc = roomCode;
                            acc.Favorites_option_2_Label__pc = hotelRoomOption.Room_Code_Label__c;
                        } 
                        //get the third option
                        if(listOptionRoomCode.size() > 2)
                        {
                            roomCode = listOptionRoomCode[listSize-3].roomCode;
                            if(!mapRoomCodeToRoomCodeAndOption.containsKey(roomCode))
                            {
                                acc.Favorites_option_type_3__pc = label.UnknownProduct;
                            }
                            else
                            {
                                hotelRoomOption = mapRoomCodeToRoomCodeAndOption.get(roomCode);
                                acc.Favorites_option_type_3__pc = roomCode;
                                acc.Favorites_option_3_Label__pc = hotelRoomOption.Room_Code_Label__c;
                            } 
                            
                        }   
                    }
                }
                listAccountToUpdate.add(acc);               
            }
            update listAccountToUpdate;
        }
		*/
    }
    /*
    public static void clearAllFavorites(Account acc)
    {
        acc.Favorite_Room_type__pc = null;
        acc.Favorite_Room_type_Label__pc = null;      
        acc.Favorites_option_type__pc = null;
        acc.Favorites_option_1_Label__pc = null;
        acc.Favorites_option_2__pc = null;
        acc.Favorites_option_2_Label__pc = null;
        acc.Favorites_option_type_3__pc = null;
        acc.Favorites_option_3_Label__pc = null;
    }
    public class OptionWrapper implements Comparable
    {
        public string roomCode;
        public integer counter;
        public OptionWrapper(string roomCode, Integer counter)
        {
            this.roomCode = roomCode;
            this.counter = counter;
        }
        public Integer compareTo(Object other) 
        {
            return counter-((OptionWrapper)other).counter;
        }
    }*/
     global void finish(Database.BatchableContext BC)
    {
        /*
        User currUser = new User();
        currUser.id = userinfo.getUserId();
        currUser.BypassProcessBuilder__c = false;
        currUser.BypassValidationRule__c = false;
        currUser.BypassWorkflow__c = false;
        update currUser;*/
    }
}