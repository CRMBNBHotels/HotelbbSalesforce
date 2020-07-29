/*
* Description: CRMSS-255 Class to count the number of different hotels where a person account has booked 
* @author: TMA-EIL Cynthia Geagea
* @date: 06/08/2019
* @Test class: AP09_Opportunity_Test 
* @Coverage: 100 %
*/

public without sharing class AP09_Opportunity {
    Public static map<String,Boolean> mapPAFirst = new map<String,Boolean>();
    
    public static Map<String,String> CheckedHotelsCount(map<string,list<opportunity>> mapPAlistBooking,Set<String> setPAID){
        system.debug('@@@ ap09 mapPAlistBooking '+mapPAlistBooking);
        Map<String,String> mapAccIdErrors = new Map<String,String>();
        list<account> listAccToUpdate = new list<account>();
        
        list<String> listDiffHotelsOnBooks = new list<String>();
        set<String> setDiffHotelsOnBooks = new set<String>();
        
        map<String,string> mapBookingHotelsID = new Map<String,string>();
        JSONtoSet jset = new JSONtoSet();
        
        if(mapPAlistBooking != null && mapPAlistBooking.size()>0){
            
            for(string accId : mapPAlistBooking.keySet()){
                if(mapPAlistBooking.get(accId) != null && mapPAlistBooking.get(accId).size()>0){
                    Opportunity book = mapPAlistBooking.get(accId)[0];
                    if(string.isNotBlank(book.Booking_Person_account__r.Tech_HotelCount__c)){
                        jset = (JSONtoSet)json.deserialize(book.Booking_Person_account__r.Tech_HotelCount__c, JSONtoSet.class);
                    }
                }
                Decimal hotelsCount = 0;
                map<String,string> mapBookingHotels = new map<String,string>();
                
                for(opportunity book : mapPAlistBooking.get(accId)){
                    
                    if(book.Booking_Person_account__r.Tech_HotelCount__c == null || string.isBlank(book.Booking_Person_account__r.Tech_HotelCount__c) || book.Booking_Person_account__r.Tech_HotelCount__c == '' ||  !book.Booking_Person_account__r.TechIsNotFirst__c){
                           mapBookingHotelsID = new Map<String,string>();
                       }
                    else{
                        
                        mapBookingHotelsID = jset.mapBookingHotels;
                    }
                    
                   
                    
                    if(book.Booking_Person_account__r.Hotels_Count__c != null && book.Booking_Person_account__r.Hotels_Count__c != 0 && book.Booking_Person_account__r.TechIsNotFirst__c){
                        
                        hotelsCount = book.Booking_Person_account__r.Hotels_Count__c;
                    }
                    if(!mapBookingHotels.containsKey(book.Hotel__c) && !mapBookingHotelsID.containskey(book.Hotel__c)){
                        mapBookingHotels.put(book.Hotel__c, book.Hotel_Name__c);
                        mapBookingHotelsID.put(book.Hotel__c, book.Hotel_Name__c);
                    } 
                }
                
                account accToUpdate = new account();
                accToUpdate.id = accId;
                accToUpdate.Hotels_Count__c = hotelsCount + mapBookingHotels.size();
                accToUpdate.TechIsNotFirst__c = true;
                jset.mapBookingHotels = mapBookingHotelsID;
                accToUpdate.Tech_HotelCount__c = json.serialize(jset);
                
                listAccToUpdate.add(accToUpdate);
            }
        }
        if(setPAID!=null && setPAID.size()>0 && mapPAFirst != null && mapPAFirst.size() > 0){
            system.debug('@@@@@last ap09 setPAID '+setPAID);
             system.debug('@@@@@last ap09 mapPAlistBooking '+mapPAlistBooking);
     			
            for(Id acc :setPAID){
               system.debug('##### acc '+acc);
                system.debug('### mapPAlistBooking.containskey(acc) '+ !mapPAlistBooking.containskey(acc));
                system.debug('##### mapPAFirst.containsKey(acc) '+mapPAFirst.containsKey(acc));
                //system.debug('##### !mapPAFirst.get(acc) '+ !mapPAFirst.get(acc));
                
                if(!mapPAlistBooking.containskey(acc)  && mapPAFirst.containsKey(acc)&& !mapPAFirst.get(acc)){
                    system.debug('##### heyy '+acc);
                    Account acc1 = new Account();
                    acc1.id= acc;
                    acc1.Hotels_Count__c=0;
                    listAccToUpdate.add(acc1);
                }
                
            }
            
        }
        Database.SaveResult[] srListPA;
        try{
            if(Limits.getDMLStatements() < Limits.getLimitDmlStatements()){
                system.debug('@@@@@@ listAccToUpdate '+listAccToUpdate);
                if(listAccToUpdate != null && listAccToUpdate.size()>0){
                    
                    srListPA = Database.update(listAccToUpdate, false);
                }
                for(Integer i=0; i < listAccToUpdate.size(); i++){
                    
                    Database.SaveResult sr = srListPA[i];
                    
                    Account acc = listAccToUpdate[i];
                    
                    if (!sr.isSuccess()){
                        Database.Error error = sr.getErrors().get(0);
                        String errorMsg = error.getMessage();
                        mapAccIdErrors.put(acc.Id, errorMsg);
                        
                    }
                    
                }
            }
        }
        catch(exception e){
            system.debug(' ### The following error occured while updating the PA ' + e.getMessage());
        }
        
        return mapAccIdErrors;
    }
    public class JSONtoSet{
        
        public map<String,string> mapBookingHotels {get;set;}
        
    }
}