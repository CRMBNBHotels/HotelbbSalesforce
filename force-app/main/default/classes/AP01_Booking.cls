/**
* @author TMA-EIT CG
* @date 24/11/2020
* @description: Calculate booking percentages on person accounts
* @test class : AP01_Booking_Test
* @coverage: 100 %
*/

public without sharing class AP01_Booking {
    
    public static void updatePAMarketingFields(List<Booking__c> listNewBookings) {
        
        set<string> firstSetPAIds = new set<string>();
        set<string> secondSetPAIds = new set<string>();
        set<string> setPAExtIds = new set<string>();
        list<Account> listPAAccounts = new list<Account>();
        list<Booking__c> listExistingBookings = new list<Booking__c>();
        Map<String,Double> mapAccountIdNbrFR = new Map<String,Double>();
        Map<String,Double> mapAccountIdNbrDE = new Map<String,Double>();
        Map<String,Double> mapAccountIdNbrAT = new Map<String,Double>();
        Map<String,Double> mapAccountIdNbrIT = new Map<String,Double>();
        Map<String,Double> mapAccountIdNbrES = new Map<String,Double>();
        Map<String,Double> mapAccountIdNbrPL = new Map<String,Double>();
        Map<String,Double> mapAccountIdNbrOther = new Map<String,Double>();
        
        for(Integer i = 0; i < (listNewBookings.size())/2; i++){
            
            if(listNewBookings[i].Personnal_Account__c != null){
                
                firstSetPAIds.add(listNewBookings[i].Personnal_Account__c);
            }
        }
        
        for(Integer i = (listNewBookings.size())/2; i < listNewBookings.size(); i++){
            
            if(listNewBookings[i].Personnal_Account__c != null){
                
                secondSetPAIds.add(listNewBookings[i].Personnal_Account__c);
            }
        }
        
        if(firstSetPAIds != null && firstSetPAIds.size()>0){
            
            list<account> listFirstPAExtIds = new list<account>([SELECT Id, Externalid__pc FROM Account WHERE Id IN: firstSetPAIds]);
            
            for(Account acc : listFirstPAExtIds){
                
                setPAExtIds.add(acc.Externalid__pc);
            }
        }
        
        if(secondSetPAIds != null && secondSetPAIds.size()>0){
            
            list<account> listSecondPAExtIds = new list<account>([SELECT Id, Externalid__pc FROM Account WHERE Id IN: secondSetPAIds]);
            
            for(Account acc : listSecondPAExtIds){
                
                setPAExtIds.add(acc.Externalid__pc);
            }
        }
        
        if(setPAExtIds != null && setPAExtIds.size()>0){
            
            listExistingBookings = [SELECT Id, Personnal_Account__c,Hotel__c, Hotel__r.Country_code__c, stage__c, Personnal_Account__r.Externalid__pc
                                    FROM Booking__c
                                    WHERE (stage__c ='Booked' or stage__c = 'Checked') AND Personnal_Account__r.Externalid__pc IN: setPAExtIds];
            
            for(string accId : setPAExtIds){
                
                mapAccountIdNbrFR.put(accId,0);
                mapAccountIdNbrDE.put(accId,0);
                mapAccountIdNbrAT.put(accId,0);
                mapAccountIdNbrIT.put(accId,0);
                mapAccountIdNbrES.put(accId,0);
                mapAccountIdNbrPL.put(accId,0);
                mapAccountIdNbrOther.put(accId,0);
            }
            
            if(listExistingBookings != null && listExistingBookings.size()>0){
                
                for(booking__c book : listExistingBookings){
                    
                    if(book.Hotel__r.Country_code__c == 'FR'){
                        
                        Double countFR = mapAccountIdNbrFR.get(book.Personnal_Account__r.Externalid__pc);
                        countFR ++;
                        mapAccountIdNbrFR.put(book.Personnal_Account__r.Externalid__pc, countFR);
                    }
                    else if(book.Hotel__r.Country_code__c == 'DE'){
                        
                        Double countDE = mapAccountIdNbrDE.get(book.Personnal_Account__r.Externalid__pc);
                        countDE ++;
                        mapAccountIdNbrDE.put(book.Personnal_Account__r.Externalid__pc, countDE);
                    }
                    else if(book.Hotel__r.Country_code__c == 'AT'){
                        
                        Double countAT = mapAccountIdNbrAT.get(book.Personnal_Account__r.Externalid__pc);
                        countAT ++;
                        mapAccountIdNbrAT.put(book.Personnal_Account__r.Externalid__pc, countAT);
                    }
                    else if(book.Hotel__r.Country_code__c == 'IT'){
                        
                        Double countIT = mapAccountIdNbrIT.get(book.Personnal_Account__r.Externalid__pc);
                        countIT ++;
                        mapAccountIdNbrIT.put(book.Personnal_Account__r.Externalid__pc, countIT);
                    }
                    else if(book.Hotel__r.Country_code__c == 'ES'){
                        
                        Double countES = mapAccountIdNbrES.get(book.Personnal_Account__r.Externalid__pc);
                        countES ++;
                        mapAccountIdNbrES.put(book.Personnal_Account__r.Externalid__pc, countES);
                    }
                    else if(book.Hotel__r.Country_code__c == 'PL'){
                        
                        Double countPL = mapAccountIdNbrPL.get(book.Personnal_Account__r.Externalid__pc);
                        countPL ++;
                        mapAccountIdNbrPL.put(book.Personnal_Account__r.Externalid__pc, countPL);
                    }
                    else{
                        
                        Double countOther = mapAccountIdNbrOther.get(book.Personnal_Account__r.Externalid__pc);
                        countOther ++;
                        mapAccountIdNbrOther.put(book.Personnal_Account__r.Externalid__pc, countOther);
                    }
                }
            }
            
            listPAAccounts = [SELECT ID,Booking_FranceNB__c, Booking_SpainNb__c, Booking_ItalyNb__c, Booking_GermanyNb__c,
                              Booking_PolandNb__c, Booking_AustriaNB__c,Booking_OthersNb__c, Externalid__pc
                              FROM Account
                              WHERE Externalid__pc IN: setPAExtIds];
            
            If(listPAAccounts != null && listPAAccounts.size()>0){
                
                For(Account acc : listPAAccounts){
                    
                    acc.Booking_FranceNB__c = mapAccountIdNbrFR.get(acc.Externalid__pc);
                    acc.Booking_GermanyNb__c = mapAccountIdNbrDE.get(acc.Externalid__pc);
                    acc.Booking_AustriaNB__c = mapAccountIdNbrAT.get(acc.Externalid__pc);
                    acc.Booking_ItalyNb__c = mapAccountIdNbrIT.get(acc.Externalid__pc);
                    acc.Booking_SpainNb__c = mapAccountIdNbrES.get(acc.Externalid__pc);
                    acc.Booking_PolandNb__c = mapAccountIdNbrPL.get(acc.Externalid__pc);
                    acc.Booking_OthersNb__c = mapAccountIdNbrOther.get(acc.Externalid__pc);
                }
                
                UtilsBypass.SKIP_APEXCLASS_MAP.put('AccountTrigger','Do not execute any other events on Accounts');
                
                update listPAAccounts;
            }        
        }
    }
}