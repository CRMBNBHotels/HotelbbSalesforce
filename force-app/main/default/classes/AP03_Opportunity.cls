/*
* Decription: Update the total nights partnership, total revenue partnership and total transactions partnership fields 
*             on business account based on the opportunity Partner Code
* @author: TMA-EIL CG
* @date: 30/12/2019
* @Test: 90%
*/
public without sharing class AP03_Opportunity 
{
    public static Map<String,Boolean> mapAccFlag = new Map<String,Boolean>();
    
    public static list<Account> getNightsAndRevenue(Map<String, list<Opportunity>> mapAcclistBookings){
        
        list<account> listAccsToUpdate =  new list<account>();
        
        if(mapAcclistBookings != null && mapAcclistBookings.size()>0){
            
            for(string accId : mapAcclistBookings.keyset()){
                
                account accToUpdate = new account();
                accToUpdate.Id = accId; 
                
                double nightsPartSum = 0;
                double revenuePartSum = 0;
                
                if(mapAcclistBookings.get(accId) != null && mapAcclistBookings.get(accId).size()>0){
                    
                    for(opportunity book : mapAcclistBookings.get(accId)){
                        
                        if(book.PartnerCode__r.TechIsNotFirst_03__c){
                            
                            if(book.PartnerCode__r.Total_Nights_PartnerShip__c != null && book.PartnerCode__r.Total_Nights_PartnerShip__c != 0 && nightsPartSum == 0){
                                
                                nightsPartSum = book.PartnerCode__r.Total_Nights_PartnerShip__c;
                            }
                            if(book.PartnerCode__r.Total_Revenue_PartnerShip__c != null && book.PartnerCode__r.Total_Revenue_PartnerShip__c != 0 && revenuePartSum == 0){
                                
                                revenuePartSum = book.PartnerCode__r.Total_Revenue_PartnerShip__c;
                            }
                            
                            if(book.Number_of_nights__c != null && book.Number_of_nights__c != 0){
                                
                                nightsPartSum+=book.Number_of_nights__c;
                            }
                            if(book.Invoiced_amount__c != null && book.Invoiced_amount__c != 0){
                                
                                revenuePartSum+=book.Invoiced_amount__c;
                            }
                        }
                        else{
                            
                            if(book.Number_of_nights__c != null && book.Number_of_nights__c != 0){
                                
                                nightsPartSum+=book.Number_of_nights__c;
                            }
                            if(book.Invoiced_amount__c != null && book.Invoiced_amount__c != 0){
                                
                                revenuePartSum+=book.Invoiced_amount__c;
                            }
                        }
                    }
                    
                    accToUpdate.Total_Nights_PartnerShip__c = nightsPartSum;
                    accToUpdate.Total_Revenue_PartnerShip__c = revenuePartSum;
                    accToUpdate.TechIsNotFirst_03__c = true;
                    listAccsToUpdate.add(accToUpdate);
                }
                
                if(mapAccFlag != null && mapAccFlag.size() > 0 && mapAccFlag.containsKey(accToUpdate.id) && mapAccFlag.get(accToUpdate.id) == false){
                    
                    accToUpdate.Total_Nights_PartnerShip__c = nightsPartSum;
                    accToUpdate.Total_Revenue_PartnerShip__c = revenuePartSum;
                    accToUpdate.TechIsNotFirst_03__c = true;
                    listAccsToUpdate.add(accToUpdate); 
                }
            }
        }
                
        return listAccsToUpdate;
    }
    
    public static list<Account> getTransactions(Map<String, map<string, opportunity>> mapAccMapBookings){
        
        list<account> listAccsToUpdate =  new list<account>();
        
        if(mapAccMapBookings != null && mapAccMapBookings.size()>0){
            
            for(string accId : mapAccMapBookings.keyset()){
                
                account accToUpdate = new account();
                accToUpdate.Id = accId; 
                
                double transactionsPartSum = 0;
                
                if(mapAccMapBookings.get(accId) != null && mapAccMapBookings.get(accId).size()>0){
                    
                    for(string mbId : mapAccMapBookings.get(accId).keyset()){
                        
                        if(mapAccMapBookings.get(accId).get(mbId).PartnerCode__r.TechIsNotFirst_03__c){
                            
                            if(mapAccMapBookings.get(accId).get(mbId).PartnerCode__r.Total_Transactions_PartnerShip__c != null && mapAccMapBookings.get(accId).get(mbId).PartnerCode__r.Total_Transactions_PartnerShip__c != 0 && transactionsPartSum ==0){
                                
                              transactionsPartSum = mapAccMapBookings.get(accId).get(mbId).PartnerCode__r.Total_Transactions_PartnerShip__c;  
                            }
                            
                            transactionsPartSum+= mapAccMapBookings.get(accId).size();
                            break;
                        }
                        else{
                            
                            transactionsPartSum = mapAccMapBookings.get(accId).size();
                        }
                    } 
                }
                
                accToUpdate.Total_Transactions_PartnerShip__c = transactionsPartSum;
                accToUpdate.TechIsNotFirst_03__c = true;
                listAccsToUpdate.add(accToUpdate);
                            
                if(mapAccFlag != null && mapAccFlag.size() > 0 && mapAccFlag.containsKey(accToUpdate.id) && mapAccFlag.get(accToUpdate.id) == false){
                    
                    accToUpdate.Total_Transactions_PartnerShip__c = transactionsPartSum;
                    accToUpdate.TechIsNotFirst_03__c = true;
                    listAccsToUpdate.add(accToUpdate); 
                }
            }
        }
        return listAccsToUpdate;
    }
    
    public static Map<String,String> updatePartnershipFields(Map<String, list<Opportunity>> mapAcclistBookings){
        
        Database.SaveResult[] srListAcc;//For dynamic Update
        Map<String,String> mapAccIdErrors = new Map<String,String>();
        
        map<string,Account> mapAccsToUpdate = new map<string, Account>();//map to retrieve all accounts to update
        
        list<Account> listAccNightsRevenue = new list<Account>();//
        list<Account> listAccTransactions = new list<Account>();//list to be filled with fillHotelName method
        
        map<string, list<opportunity>> mapAcclistBookingsNightsRevenue = new map<string, list<opportunity>>();//map to be given as a parameter to getNightsAndRevenue
        map<string, map<string, opportunity>> mapAccMapBookingsTransactions = new map<string, map<string, opportunity>>();//map to be given as a parameter to getTransactions
        
        if(mapAcclistBookings != null && mapAcclistBookings.size()>0){
            
            for(string accId : mapAcclistBookings.keyset()){
                
                if(mapAcclistBookings.get(accId) != null && mapAcclistBookings.get(accId).size()>0){
                    
                    for(Opportunity book : mapAcclistBookings.get(accId)){
                        
                        if((book.Number_of_nights__c != null && book.Number_of_nights__c != 0) || (book.Invoiced_amount__c != null && book.Invoiced_amount__c != 0)){
                            
                            if(!book.IsDeleted){
                                
                                if(!mapAcclistBookingsNightsRevenue.containsKey(accId)){
                                    
                                    list<Opportunity> listToPut = new list<Opportunity>();
                                    listToPut.add(book);
                                    mapAcclistBookingsNightsRevenue.put(accId,listToPut);
                                }
                                else{
                                    
                                    list<Opportunity> listToPut = mapAcclistBookingsNightsRevenue.get(accId);
                                    listToPut.add(book);
                                    mapAcclistBookingsNightsRevenue.put(accId,listToPut);
                                }
                            }
                            else{
                                
                                if(!mapAcclistBookingsNightsRevenue.containsKey(accId)){
                                    
                                    mapAcclistBookingsNightsRevenue.put(accId, new list<Opportunity>());
                                }
                                else{
                                    
                                    mapAcclistBookingsNightsRevenue.put(accId, mapAcclistBookingsNightsRevenue.get(accId));
                                } 
                            }
                        }
                        
                        
                        if(book.Master_Booking_FK__c != null && string.isNotBlank(book.Master_Booking_FK__c)){
                            
                            if(!book.IsDeleted){
                                
                                if(!mapAccMapBookingsTransactions.containsKey(accId)){
                                    
                                    map<string, opportunity> mapToPut = new map<string, opportunity>();
                                    mapToPut.put(book.Master_Booking_FK__c, book);
                                    mapAccMapBookingsTransactions.put(accId,mapToPut);
                                }
                                else{
                                    
                                    map<string, opportunity> mapToPut = mapAccMapBookingsTransactions.get(accId);
                                    mapToPut.put(book.Master_Booking_FK__c, book);
                                    mapAccMapBookingsTransactions.put(accId,mapToPut);
                                }
                            }
                            else{
                                
                                if(!mapAccMapBookingsTransactions.containsKey(accId)){
                                    
                                    mapAccMapBookingsTransactions.put(accId, new map<string, opportunity>());
                                }
                                else{
                                    
                                    mapAccMapBookingsTransactions.put(accId, mapAccMapBookingsTransactions.get(accId));
                                } 
                            }
                        }
                    }
                }
            }           
        }
        
        if(mapAcclistBookingsNightsRevenue != null && mapAcclistBookingsNightsRevenue.size()>0){
            
            listAccNightsRevenue = getNightsAndRevenue(mapAcclistBookingsNightsRevenue);
            
            if(listAccNightsRevenue != null && listAccNightsRevenue.size()>0){
                
                for(Account acc : listAccNightsRevenue){
                    
                    if(!mapAccsToUpdate.containsKey(acc.Id)){
                        
                        mapAccsToUpdate.put(acc.Id, acc);
                    }
                    else{
                        
                        acc.Total_Transactions_PartnerShip__c = mapAccsToUpdate.get(acc.Id).Total_Transactions_PartnerShip__c;
                        mapAccsToUpdate.put(acc.Id, acc);
                    }
                }
            }
        }
        
        if(mapAccMapBookingsTransactions != null && mapAccMapBookingsTransactions.size()>0){
            
            listAccTransactions = getTransactions(mapAccMapBookingsTransactions);
            
            if(listAccTransactions != null && listAccTransactions.size()>0){
                
                for(Account acc : listAccTransactions){
                    
                    if(!mapAccsToUpdate.containsKey(acc.Id)){
                        
                        mapAccsToUpdate.put(acc.Id, acc);
                    }
                    else{
                        
                        acc.Total_Nights_PartnerShip__c = mapAccsToUpdate.get(acc.Id).Total_Nights_PartnerShip__c;
                        acc.Total_Revenue_PartnerShip__c = mapAccsToUpdate.get(acc.Id).Total_Revenue_PartnerShip__c;
                        mapAccsToUpdate.put(acc.Id, acc);
                    }
                    
                }
            }
        }
        
        if(mapAccsToUpdate != null && mapAccsToUpdate.size()>0){
            
            try{
                
                srListAcc = database.update(mapAccsToUpdate.values(), false);
                
                //Loop over updated masterbookings, to catch errors encountered and return them to the batch
                for(Integer i=0; i < (mapAccsToUpdate.values()).size(); i++){
                    
                    Database.SaveResult sr = srListAcc[i];
                    
                    Account acc = (mapAccsToUpdate.values())[i];
                    
                    if (!sr.isSuccess()){
                        
                        Database.Error error = sr.getErrors().get(0);
                        String errorMsg = error.getMessage();
                        
                        mapAccIdErrors.put(acc.Id, errorMsg);
                    } 
                }
            }
            
            catch(exception e){
                
                system.debug('The following error occured while updating Masterbookings: '+ e.getMessage());
            } 
        }
        
        return mapAccIdErrors;
    }
}