/**
* @author TMA-EIL JK
* @date 06/03/2020
* @description calculate bookings percentages
* @test class : 
* @coverage: 
*/

Global without sharing class Batch_pourcentageBooking  implements Database.Batchable<sObject>, Database.Stateful{
    
    //global Map<Id,NumberOfBooking> mapPAId = new Map<Id,NumberOfBooking>();
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'select id from Opportunity where RecordType.name =\'Booking\' and (StageName = \'Booked\' or StageName = \'Checked\' ) and (Master_Booking_FK__r.Channel__c = \'Dashboard\' or Master_Booking_FK__r.Channel__c = \'Website\' or Master_Booking_FK__r.Channel__c = \'Apps\') and Person_Account__c != null  '+label.Batch_pourcentageBooking;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
        
        List<Opportunity> listCurrBook = [select id,person_account__c,HotelCountry__c,person_account__r.Booking_FranceNB__c,person_account__r.Booking_GermanyNb__c,
                                          person_account__r.Booking_ItalyNb__c,person_account__r.Booking_OthersNb__c,person_account__r.Booking_PolandNb__c,person_account__r.Booking_SpainNb__c 
                                          from Opportunity where id in :listBookings];
        
        Map<String,AccountDataHistory.CountryPercentage> mapPAId = new Map<String,AccountDataHistory.CountryPercentage>();
        List< Messaging.SingleEmailMessage> listmails = new List< Messaging.SingleEmailMessage>();
        for(Opportunity book:listCurrBook){
            if(!mapPAId.containskey(book.Person_Account__c)){
                
                mapPAId.put(book.Person_Account__c,new AccountDataHistory.CountryPercentage());
            }
            
             	
            AccountDataHistory.CountryPercentage percentage = mapPAId.get(book.Person_Account__c);
            
            system.debug('#### HotelCountry__c ' + book.HotelCountry__c);
            system.debug('#### book.Person_Account__r ' + book.Person_Account__r);
            system.debug('#### percentage ' + percentage);
            
            if(book.Person_Account__c == '0011v00002AdS5cAAF' || test.isRunningTest()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'joanna.karam@ei-technologies.com'};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Batch Debug : pourcentage ' );
                String body = 'Percentage logs ';
                body+='\n'+ ' 0011v00002AdS5cAAF'; 
                body+='\n'+ ' mapPAId : ' + mapPAId; 
                body+='\n'+ ' HotelCountry__c : ' + book.HotelCountry__c; 
                body+='\n'+ ' book.Person_Account__r : ' + book.Person_Account__r; 
                body+='\n'+ ' percentage : ' + percentage; 
                mail.setPlainTextBody(body);
                listmails.add(mail);
                
            }
            if(book.HotelCountry__c != null && !string.isBlank(book.HotelCountry__c)){
                
                if(book.HotelCountry__c == 'FR'){
                    
                    if(percentage.france == 0){
                        
                        if(book.Person_Account__r.Booking_FranceNB__c == null){
                            
                            percentage.france = 1;
                        }else if(book.Person_Account__r.Booking_FranceNB__c != null ){
                            percentage.france = (Integer)book.Person_Account__r.Booking_FranceNB__c++;
                        }
                    }
                    else{
                        
                        percentage.france++;
                    }
                }else 
                    if(book.HotelCountry__c == 'DE'){
                        
                        if(percentage.germany == 0){
                            
                            if(book.Person_Account__r.Booking_GermanyNb__c == null){
                                
                                percentage.germany = 1;
                            }else{
                                percentage.germany = (Integer)book.Person_Account__r.Booking_GermanyNb__c++;
                            }
                        }
                        else{
                            
                            percentage.germany++;
                        }
                    }else 
                        if(book.HotelCountry__c == 'IT'){
                            
                            if(percentage.italy == 0){
                                
                                if(book.Person_Account__r.Booking_ItalyNb__c == null){
                                    
                                    percentage.italy = 1;
                                }else{
                                    percentage.italy = (Integer)book.Person_Account__r.Booking_ItalyNb__c++;
                                }
                            }
                            else{
                                
                                percentage.italy++;
                            }
                        }else
                            if(book.HotelCountry__c == 'ES'){
                                
                                if(percentage.spain == 0){
                                    
                                    if(book.Person_Account__r.Booking_SpainNb__c == null){
                                        
                                        percentage.spain = 1;
                                    }else{
                                        percentage.spain = (Integer)book.Person_Account__r.Booking_SpainNb__c++;
                                    }
                                }
                                else{
                                    
                                    percentage.spain++;
                                }
                            }else
                                if(book.HotelCountry__c == 'PL'){
                                    
                                    if(percentage.poland == 0){
                                        
                                        if(book.Person_Account__r.Booking_PolandNb__c == null){
                                            
                                            percentage.poland = 1;
                                        }else{
                                            percentage.poland = (Integer)book.Person_Account__r.Booking_PolandNb__c++;
                                        }
                                    }
                                    else{
                                        
                                        percentage.poland++;
                                    }
                                }else                         
                                    if(percentage.others == 0){
                                        
                                        if(book.Person_Account__r.Booking_OthersNb__c == null){
                                            
                                            percentage.others = 1;
                                        }else{
                                            percentage.others = (Integer)book.Person_Account__r.Booking_OthersNb__c++;
                                        }
                                    }
                else{
                    
                    percentage.others++;
                }
                
            }else{
                
                if(percentage.others == 0){
                    
                    if(book.Person_Account__r.Booking_OthersNb__c == null){
                        
                        percentage.others = 1;
                    }else{
                        percentage.others = (Integer)book.Person_Account__r.Booking_OthersNb__c++;
                    }
                }
                else{
                    
                    percentage.others++;
                }
            }
            if(percentage.Germany == 0 && book.Person_Account__r.Booking_GermanyNb__c != null){
                percentage.Germany = (Integer)book.Person_Account__r.Booking_GermanyNb__c;
            }
            if(percentage.france == 0 && book.Person_Account__r.Booking_FranceNb__c != null){
                percentage.france = (Integer)book.Person_Account__r.Booking_FranceNb__c;
            }
            if(percentage.italy == 0 && book.Person_Account__r.Booking_ItalyNb__c != null){
                percentage.italy = (Integer)book.Person_Account__r.Booking_ItalyNb__c;
            }
            if(percentage.Poland == 0 && book.Person_Account__r.Booking_PolandNb__c != null){
                percentage.Poland = (Integer)book.Person_Account__r.Booking_PolandNb__c;
            }
            if(percentage.Others == 0 && book.Person_Account__r.Booking_OthersNb__c != null){
                percentage.Others = (Integer)book.Person_Account__r.Booking_OthersNb__c;
            }
            if(percentage.spain == 0 && book.Person_Account__r.Booking_spainNb__c != null){
                percentage.spain = (Integer)book.Person_Account__r.Booking_spainNb__c;
            }
            mapPAId.put(book.Person_Account__c,percentage);
            system.debug('#### mapPAId ' + mapPAId);
            system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        }
        
        //Fill for the account the value and the percentage
        List<Account> listAccToUpdate = new List<Account>();
        
        for(String accID : mapPAId.keyset()){
            
            Account acc = new Account();
            acc.id = accId;
            ap04_Account.doUpdateCountries(acc,mapPAId.get(accId));
            system.debug('#### ACC ' + acc);
            if(mapPAId.get(accId).france != 0) 
                acc.Booking_FranceNB__c = mapPAId.get(accId).france;
            if(mapPAId.get(accId).germany != 0)
                acc.Booking_GermanyNb__c = mapPAId.get(accId).germany;
            if(mapPAId.get(accId).poland != 0)
                acc.Booking_PolandNb__c = mapPAId.get(accId).poland;
            if(mapPAId.get(accId).italy != 0)
                acc.Booking_ItalyNb__c = mapPAId.get(accId).italy;
            if(mapPAId.get(accId).spain != 0)
                acc.Booking_SpainNb__c = mapPAId.get(accId).spain;
            if(mapPAId.get(accId).others != 0)
                acc.Booking_OthersNb__c = mapPAId.get(accId).others;
                system.debug('#### Account after modif ' + acc);
            listAccToUpdate.add(acc);
        }
        
        if(listAccToUpdate != null && listAccToUpdate.size()>0){
            
            update listAccToUpdate;
        }
        
                
      if(listmails != null && listmails.size()>0)
                Messaging.sendEmail(listmails);
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
}