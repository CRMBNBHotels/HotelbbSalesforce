/*
* Description: Batch Reprise to update 1st booking and last booking date on Person account of a master booking CRMSS-377
* @author: TMA-EI JKA
* @date: 03/12/2019
* @Test: Batch_Account_BookingDates_Test
* @Coverage: 100%
*/

Global without sharing class Batch_Account_BookingDates implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String,String> mapAccountId = new Map<String,String>();
    global Integer Counter; 
    
    global Batch_Account_BookingDates(Map<String,String> mapAccountId,integer counter){
        
        system.debug('### cg in constructor');
        this.Counter = counter;
        this.mapAccountId= new Map<String,String>();
        
        if(mapAccountId != null && mapAccountId.size()>0){
            
            this.mapAccountId= mapAccountId;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        system.debug('### cg in start');
        String StaticListID = Label.BatchRepAccountsBookingDates_Ids;system.debug('### cg StaticListID'+StaticListID);
        list<String> liststaticId = new list<String>();
        
        if(String.isNotBlank(StaticListID) && StaticListID != '//'){
            system.debug('### cg what wre u doing here');
            liststaticId = StaticListID.split(',');
        }
        string query;
        if((mapAccountId == null || mapAccountId.size() == 0) && (liststaticId == null || liststaticId.size() == 0)){
            system.debug('### cg query null');
            //Query on opp in failed PA
            query = 'select id, Person_Account__c, Departure_Date__c, Person_Account__r.First_Booking_Date__c, Person_Account__r.Last_Booking_Date__c from opportunity where RecordType.DeveloperName = \'Master_Booking\' and Person_Account__c != null and Departure_Date__c != null';
        }
        else if(mapAccountId != null && mapAccountId.size()>0){
            system.debug('### cg query map not null');
            set<string> setAccountId = mapAccountId.keyset();
            //Query on opportunities of record type master bookings to retrieve all data to be used
            query = 'select id, Person_Account__c, Departure_Date__c, Person_Account__r.First_Booking_Date__c, Person_Account__r.Last_Booking_Date__c from opportunity where RecordType.DeveloperName = \'Master_Booking\' and Person_Account__c != null and Departure_Date__c != null and Person_Account__c in: setAccountId';     
        }
        else if(liststaticId != null && liststaticId.size() > 0){
            system.debug('### cg query list not null');
            query = 'select id, Person_Account__c, Departure_Date__c, Person_Account__r.First_Booking_Date__c, Person_Account__r.Last_Booking_Date__c from opportunity where RecordType.DeveloperName = \'Master_Booking\' and Person_Account__c != null and Departure_Date__c != null and Person_Account__c in: liststaticId';
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listMBookings){
        
        List<Opportunity> listMBookingsFiltered = new list<Opportunity>([select id, Person_Account__c, Departure_Date__c, Person_Account__r.First_Booking_Date__c, Person_Account__r.Last_Booking_Date__c 
                                                                         from opportunity
                                                                         where RecordType.DeveloperName = 'Master_Booking' and Person_Account__c != null and Departure_Date__c != null and Id in:listMBookings]);
        
        //For PAs update
        list<account> listPersAccToUpdate = new list<account>();
        map<string,list<Opportunity>> mapPAlistMBooking = new map<string,list<Opportunity>>();
        
        //We need to filter and organise the retrieved data in the correspondant maps
        if(listMBookingsFiltered != null && listMBookingsFiltered.size()>0){
            
            for(Opportunity mbook : listMBookingsFiltered){
                
                if(!mapPAlistMBooking.containskey(mbook.Person_Account__c)){
                    
                    list<Opportunity> listToPut = new list<Opportunity>();
                    listToPut.add(mbook);
                    mapPAlistMBooking.put(mbook.Person_Account__c, listToPut);
                }
                else{
                    
                    list<Opportunity> listToPut = mapPAlistMBooking.get(mbook.Person_Account__c);
                    listToPut.add(mbook);
                    mapPAlistMBooking.put(mbook.Person_Account__c, listToPut);
                }
            } 
        }
        
        //Calculate data related to PAs update
        if(mapPAlistMBooking != null && mapPAlistMBooking.size()>0){
            
            for(string accId : mapPAlistMBooking.keySet()){
                
                Date FirstDate = Date.newInstance(2100, 1, 1);
                Date LastDate = Date.newInstance(1900, 1, 1);
                
                for(Opportunity masterBook : mapPAlistMBooking.get(accId)){
                    
                    if( (masterBook.Person_Account__r.First_Booking_Date__c == null && masterBook.Departure_Date__c < FirstDate) || (masterBook.Person_Account__r.First_Booking_Date__c != null && masterBook.Departure_Date__c < masterBook.Person_Account__r.First_Booking_Date__c)){
                        
                        FirstDate = masterBook.Departure_Date__c;
                    }
                    
                    if( (masterBook.Person_Account__r.Last_Booking_Date__c == null && masterBook.Departure_Date__c > LastDate) || (masterBook.Person_Account__r.Last_Booking_Date__c != null && masterBook.Departure_Date__c > masterBook.Person_Account__r.Last_Booking_Date__c)){
                        
                        LastDate = masterBook.Departure_Date__c;
                    }
                }
                
                account accToUpdate = new account();
                accToUpdate.id = accId;
                
                if(FirstDate != Date.newInstance(2100, 1, 1)){
                    system.debug('### jka FirstDate'+FirstDate);
                    accToUpdate.First_Booking_Date__c = FirstDate;
                }
                
                if(LastDate != Date.newInstance(1900, 1, 1)){
                    system.debug('### jka LastDate'+LastDate);
                    accToUpdate.Last_Booking_Date__c = LastDate;
                }
                
                listPersAccToUpdate.add(accToUpdate);
            } 
        }
        
        Database.SaveResult[] srListPA;
        
        //Update the PAs
        if(listPersAccToUpdate != null && listPersAccToUpdate.size()>0){
            
            srListPA = Database.update(listPersAccToUpdate, false);
        }
        
        for(Integer i=0; i < listPersAccToUpdate.size(); i++){
            system.debug('### cg looping saveresults');
            Database.SaveResult sr = srListPA[i];
            
            Account acc = listPersAccToUpdate[i];
            system.debug('### cg acc'+acc);
            
            if (!sr.isSuccess()){
                system.debug('### cg error in saveresult');
                Database.Error error = sr.getErrors().get(0);
                String errorMsg = error.getMessage();
                
                system.debug('### cg Failed acc.Id'+acc.Id);
                system.debug('### cg mapAccountId 1 '+mapAccountId);
                mapAccountId.put(acc.Id, errorMsg);
                system.debug('### cg mapAccountId 2 '+mapAccountId);
            }
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        if (counter < 2){
            
            counter ++;
            
            if(mapAccountId!= null && mapAccountId.size()>0){
                
                Batch_Account_BookingDates batchObj = new Batch_Account_BookingDates(mapAccountId,counter);
                DataBase.executeBatch(batchObj);
                system.debug('### cg counter'+counter + '### cg mapAccountId when constructor called from finish'+mapAccountId);
            }
        }
        else{
            system.debug('### cg in send email');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'cynthia.geagea@ei-technologies.com'};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Error : Batch_Account_BookingDates ' );
            
            if(mapAccountId != null && mapAccountId.size()>0){
                
                String body = 'Total:' +'  '+ mapAccountId.size() +'  '+ ' records not updated sucessfully';
                
                for (String failedId : mapAccountId.keySet()){
                    
                    body+='\n'+failedId + ' reason : ' + mapAccountId.get(failedId); 
                }
                
                mail.setPlainTextBody(body);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            system.debug('### cg email sent');
        }
    }

}