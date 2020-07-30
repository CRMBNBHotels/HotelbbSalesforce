/*
* Description: CRMSS - 395 Batch to update the first and last booking dates on a person account, according to the departure date on its related masterbookings
* @author: TMA-EIL CG
* @date: 23/12/2019
* @Test: Batch_FirstLastBooking_Test
* @Coverage: 91 %
*/

Global without sharing class Batch_FirstLastBooking implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String,String> mapAccountId = new Map<String,String>();
    global Integer Counter;// counter is the number of time the batch has been called 
    global set<String> setPAId = new set<String>();//list of PA ID from the masterbooking list
    
    //Defining the constructor of the batch, allowing to run the batch with the global variables above
    global Batch_FirstLastBooking(map<String, String> mapAccountId, integer counter) {
        
        this.Counter = counter;
        this.mapAccountId= new Map<String,String>();
        
        if(mapAccountId != null && mapAccountId.size()>0){
            
            this.mapAccountId= mapAccountId;
        }  
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String StaticListID = Label.Batch_FirstLastBooking_PAIds;
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            
            liststaticId = StaticListID.split(',');
        }
        
        set<string> setAccountId = mapAccountId.keyset();
        String query;
        String query2;
        
        if((mapAccountId == null || mapAccountId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            query = 'select id,Person_Account__c,LastModifiedDate,OldParent__c, RecordTypeId, Person_Account__r.TechIsNotFirst_02__c from opportunity '+system.label.Batch_FirstLastBooking_WhereClause+' ALL ROWS';// and LastModifiedDate>=YESTERDAY
        }
        else if(mapAccountId != null && mapAccountId.size()>0){
            query = 'select id,Person_Account__c,LastModifiedDate,OldParent__c, RecordTypeId, Person_Account__r.TechIsNotFirst_02__c from opportunity where RecordType.DeveloperName=\'Master_Booking\' and  Person_Account__c != null and Person_Account__c in: setAccountId ';
            
        }
        else if(liststaticId != null && liststaticId.size() > 0){
            query = 'select id,Person_Account__c, LastModifiedDate,OldParent__c, RecordTypeId, Person_Account__r.TechIsNotFirst_02__c from opportunity where RecordType.DeveloperName=\'Master_Booking\' and  Person_Account__c != null and Person_Account__c in: liststaticId';
        }
        
        if (!string.isBlank(query)){
            
            List<Opportunity> lstB = Database.query(query);
            
            for(Opportunity book: lstB){
                
                if(!string.isBlank(book.OldParent__c)){
                    
                    setPAId.add(book.OldParent__c);
                }
                setPAId.add(book.Person_Account__c);
            }
        }
        
        if(setPAId!=null && setPAId.size()>0){
            
            query2 = 'select id, Person_Account__c, Bookings_Checked_Count__c, OldParent__c, LastModifiedDate, RecordTypeId, Person_Account__r.TechIsNotFirst_02__c from opportunity where RecordType.DeveloperName=\'Master_Booking\' and  Person_Account__c != null and  (Person_Account__c in: setPAId OR OldParent__c in: setPAId) and Bookings_Checked_Count__c>0';
        }
        
        return Database.getQueryLocator(query2);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
        
        list<Opportunity> listOppInLot = new list<Opportunity>();
        Map<string,Account> MapPAToUpdate = new Map<string,Account>();
        system.debug('@@@ listBookings '+listBookings);
        if(listBookings != null && listBookings.size()>0){
            
            listOppInLot = [select id, Person_Account__c, OldParent__c, Person_Account__r.First_Booking_Date__c,Person_Account__r.Last_Booking_Date__c,Person_Account__r.TechIsNotFirst_02__c,  Bookings_Checked_Count__c, LastModifiedDate, Departure_Date__c
                            from opportunity 
                            where RecordType.DeveloperName='Master_Booking' and  Person_Account__c != null and id in : listBookings and Bookings_Checked_Count__c > 0];
            system.debug('@@@ listOppInLot '+listOppInLot);
            if(listOppInLot != null && listOppInLot.size()>0){
                Date FirstDate = Date.newInstance(2100, 1, 1);
                Date LastDate = Date.newInstance(1900, 1, 1);
                for(Opportunity Book : listOppInLot){
                    
                    if(!Book.Person_Account__r.TechIsNotFirst_02__c){
                        system.debug('### put it null');
                       /* if(Book.Person_Account__r.First_Booking_Date__c != null){
                            
                            Book.Person_Account__r.First_Booking_Date__c = null;
                        }*/
                        
                        if(Book.Person_Account__r.Last_Booking_Date__c != null){
                            
                            Book.Person_Account__r.Last_Booking_Date__c = null;
                        }
                    }
                    system.debug('### MapPAToUpdate beforeeeeeeee ' + MapPAToUpdate);
                    system.debug('### Book.Person_Account__r.First_Booking_Date__c ' + Book.Person_Account__r.First_Booking_Date__c);
                    system.debug('### book.Departure_Date__c ' + book.Departure_Date__c);
                     system.debug('### MapPAToUpdate.containsKey(Book.Person_Account__c ' + MapPAToUpdate.containsKey(Book.Person_Account__c));
                     //system.debug('### MapPAToUpdate.get(Book.Person_Account__c).First_Booking_Date__c ' + MapPAToUpdate.get(Book.Person_Account__c).First_Booking_Date__c);
                     system.debug('### Book.Person_Account__r.First_Booking_Date__c ' + Book.Person_Account__r.First_Booking_Date__c);

                    if((Book.Person_Account__r.First_Booking_Date__c != null && book.Departure_Date__c < Book.Person_Account__r.First_Booking_Date__c && !MapPAToUpdate.containsKey(Book.Person_Account__c)) || 
                       (Book.Person_Account__r.First_Booking_Date__c == null && !MapPAToUpdate.containsKey(Book.Person_Account__c))
                      || (MapPAToUpdate.containsKey(Book.Person_Account__c) && (MapPAToUpdate.get(Book.Person_Account__c).First_Booking_Date__c == null || MapPAToUpdate.get(Book.Person_Account__c).First_Booking_Date__c > book.Departure_Date__c) )){
                        system.debug('@@@ in firstt');
                        Account acc = new Account();
                        acc.id = Book.Person_Account__c;
                        acc.First_Booking_Date__c = book.Departure_Date__c;
                        //acc.TechIsNotFirst_02__c = true;
                        
                        if(!MapPAToUpdate.containsKey(Book.Person_Account__c)){
                            acc.Last_Booking_Date__c = Book.Person_Account__r.Last_Booking_Date__c;
                            MapPAToUpdate.put(Book.Person_Account__c,acc);
                        }
                        else{
                            
                            acc = MapPAToUpdate.get(Book.Person_Account__c);
                            acc.First_Booking_Date__c = book.Departure_Date__c;
                            acc.TechIsNotFirst_02__c = true;
                            MapPAToUpdate.put(Book.Person_Account__c,acc);
                        }					
                    }
                    system.debug('### Book.Person_Account__r.Last_Booking_Date__c ' + Book.Person_Account__r.Last_Booking_Date__c);
                    system.debug('### book.Departure_Date__c ' + book.Departure_Date__c);
                    if((Book.Person_Account__r.Last_Booking_Date__c != null && book.Departure_Date__c > Book.Person_Account__r.Last_Booking_Date__c  && !MapPAToUpdate.containsKey(Book.Person_Account__c)) || (Book.Person_Account__r.Last_Booking_Date__c == null && !MapPAToUpdate.containsKey(Book.Person_Account__c))
                       || (MapPAToUpdate.containsKey(Book.Person_Account__c)&& (MapPAToUpdate.get(Book.Person_Account__c).Last_Booking_Date__c == null || MapPAToUpdate.get(Book.Person_Account__c).Last_Booking_Date__c < book.Departure_Date__c)) ){
                         system.debug('@@@ in last');
                        Account acc = new Account();
                        acc.id = Book.Person_Account__c;
                        acc.Last_Booking_Date__c = book.Departure_Date__c;
                        acc.TechIsNotFirst_02__c = true;
                        
                        if(!MapPAToUpdate.containsKey(Book.Person_Account__c)){
                            acc.First_Booking_Date__c = Book.Person_Account__r.First_Booking_Date__c;
                            MapPAToUpdate.put(Book.Person_Account__c,acc);
                        }
                        else{
                            
                            acc = MapPAToUpdate.get(Book.Person_Account__c);
                            acc.Last_Booking_Date__c = book.Departure_Date__c;
                            acc.TechIsNotFirst_02__c = true;
                            MapPAToUpdate.put(Book.Person_Account__c,acc);
                        }
                        							
                    }
                    system.debug('### MapPAToUpdate after ' + MapPAToUpdate);
                }
                system.debug('### MapPAToUpdate final ' + MapPAToUpdate);
                if(MapPAToUpdate != null && MapPAToUpdate.size()>0){
                    
                    Database.SaveResult[] srListPA;
                    List<Account> listAccToUpdate = MapPAToUpdate.values();
                    
                    srListPA = Database.update(MapPAToUpdate.values(), false);
                    
                    for(Integer iloop=0; iloop < listAccToUpdate.size(); iloop++){
                        
                        Database.SaveResult sr = srListPA[iloop];
                        
                        Account acc = listAccToUpdate.get(iloop);
                        
                        if (!sr.isSuccess()){
                            
                            Database.Error error = sr.getErrors().get(0);
                            String errorMsg = error.getMessage();
                            mapAccountId.put(acc.Id, errorMsg);
                        }
                    }
                } 
            }
            
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        database.executeBatch(new Batch_DeflagAccount_FirstLastBooking());
        
        //If the counter is less than 2, we call the batch again
        if (counter < 2){
            
            counter ++;
            
            if(mapAccountId != null && mapAccountId.size()>0){
                
                Batch_FirstLastBooking batchObj = new Batch_FirstLastBooking(mapAccountId,counter);
                DataBase.executeBatch(batchObj);
            }
        }
        //If the batch reached 3, we send an email with failed PA Ids, to be filled manually in the label Batch_HotelCountChecked
        else{
            
            String[] toAddresses = new String[] {'joanna.karam@ei-technologies.com'};
            String Subject = 'Batch Error : Batch_FirstLastBooking ';
            
            //if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){
                
                Utils_Email.sendEmailApex(toAddresses, Subject, mapAccountId);
            //}
            
        }
    }
    
}