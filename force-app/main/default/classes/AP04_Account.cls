public without sharing class AP04_Account {
    
    public static void initializeDataHistoryField(List<Account> listAccounts) {
        system.debug('@@@ initializeDataHistoryField');
        Id guestAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.PersonAccountDeveloperName).getRecordTypeId();
        for(Account acct : listAccounts) {
            if(acct.RecordTypeId == guestAccountRT) {
                acct.Data_History__c = JSON.serialize(new AccountDataHistory());system.debug('### cg acct.Data_History__c in ap04 '+acct.Data_History__c);
            }
        } 
    }
    
    
    public static void doUpdateGuestFields(Map<Id,AccountDataHistory> mapGuestIdDataHistory) {
        Set<Id> setCompaniesToUpdate = new Set<Id>();
        Map<Id, Integer> mapCompaniesNights = new Map<Id, Integer>();
        Map<Id, decimal> mapCompaniesRevenues = new Map<Id, decimal>();
        List<Account> listGuestAccounts = [SELECT Id, Data_History__c, Customer_type__pc, Total_Nights__c, Total_nights__pc,Total_Revenue__pc,Current_Compagny__pc
                                           FROM Account
                                           WHERE Id IN :mapGuestIdDataHistory.keySet()
                                          ];
        
        AccountDataHistory dataHistoryObjToUpdate;
        AccountDataHistory guestAccountInformationObject;
        Integer businessTypeCounter;
        Integer leisureTypeCounter;
        boolean bUpdateGuestAcc;
        Integer totalNights;
        decimal totalRevenue;
         for(Account guestAccount : listGuestAccounts) {
            bUpdateGuestAcc = false;
            dataHistoryObjToUpdate = AccountDataHistory.parse(guestAccount.Data_History__c);
            guestAccountInformationObject =  mapGuestIdDataHistory.get(guestAccount.Id);
            
            // Update Customer Type field
            if(guestAccountInformationObject.CustomerType.business != 0) {
                bUpdateGuestAcc = true;
                dataHistoryObjToUpdate.CustomerType.setBusinessType(guestAccountInformationObject.CustomerType.business);
            }
            
            if(guestAccountInformationObject.CustomerType.leisure != 0) {
                if(!bUpdateGuestAcc) {
                    bUpdateGuestAcc = true;
                }
                dataHistoryObjToUpdate.CustomerType.setLeisureType(guestAccountInformationObject.CustomerType.leisure);
            }
            if(bUpdateGuestAcc) {
                businessTypeCounter = dataHistoryObjToUpdate.CustomerType.getBusinessType();
                leisureTypeCounter  = dataHistoryObjToUpdate.CustomerType.getLeisureType();
                doUpdateCustomerType(guestAccount, businessTypeCounter, leisureTypeCounter);
            }
            bUpdateGuestAcc = false;
            // End of Update Customer Type field
            
            // Update Countries Percentages fields
            if(guestAccountInformationObject.CountryPercentage.france != 0 && dataHistoryObjToUpdate.CountryPercentage != null) {
                dataHistoryObjToUpdate.CountryPercentage.setFrance(guestAccountInformationObject.CountryPercentage.france);
            }
            if(guestAccountInformationObject.CountryPercentage.spain != 0 && dataHistoryObjToUpdate.CountryPercentage != null) {
                dataHistoryObjToUpdate.CountryPercentage.setSpain(guestAccountInformationObject.CountryPercentage.spain);
            }
            if(guestAccountInformationObject.CountryPercentage.italy != 0 && dataHistoryObjToUpdate.CountryPercentage != null) {
                dataHistoryObjToUpdate.CountryPercentage.setItaly(guestAccountInformationObject.CountryPercentage.italy);
            }
            if(guestAccountInformationObject.CountryPercentage.germany != 0 && dataHistoryObjToUpdate.CountryPercentage != null) {
                dataHistoryObjToUpdate.CountryPercentage.setGermany(guestAccountInformationObject.CountryPercentage.germany);
            }
            if(guestAccountInformationObject.CountryPercentage.poland != 0 && dataHistoryObjToUpdate.CountryPercentage != null) {
                dataHistoryObjToUpdate.CountryPercentage.setPoland(guestAccountInformationObject.CountryPercentage.poland);
            }
            if(guestAccountInformationObject.CountryPercentage.others != 0 && dataHistoryObjToUpdate.CountryPercentage != null) {
                dataHistoryObjToUpdate.CountryPercentage.setOthers(guestAccountInformationObject.CountryPercentage.others);
            }
            if(dataHistoryObjToUpdate.CountryPercentage != null) {
                // This condition is put while testing for existing account that were not initialized with CountryPercentage attribute
                doUpdateCountries(guestAccount, dataHistoryObjToUpdate.countryPercentage);
            }
            
           /* // Update TotalNights field
            if(guestAccountInformationObject.mapBookingNight != null && guestAccountInformationObject.mapBookingNight.size() > 0 && dataHistoryObjToUpdate.mapBookingNight != null ) {
                for(AccountDataHistory.Night night : guestAccountInformationObject.mapBookingNight.values()) {
                    if(dataHistoryObjToUpdate.mapBookingNight.containsKey(night.bookingId)) {
                        dataHistoryObjToUpdate.mapBookingNight.get(night.bookingId).nbrNights = night.nbrNights;
                        dataHistoryObjToUpdate.mapBookingNight.get(night.bookingId).year = night.year;
                    } else {
                        dataHistoryObjToUpdate.mapBookingNight.put(night.bookingId, night);
                    }
                }                
                dataHistoryObjToUpdate.setTotalNights();
                if(guestAccount.Total_nights__pc == null) {
                    guestAccount.Total_nights__pc = 0;
                }
                // update companies fields
                if(guestAccount.Current_Compagny__pc != null) {
                    setCompaniesToUpdate.add(guestAccount.Current_Compagny__pc);                     
                }
                
                guestAccount.Total_nights__pc = dataHistoryObjToUpdate.totalNights;
                
            }
            
            // Update TotalRevenue field
            if(guestAccountInformationObject.mapBookingRevenue != null && guestAccountInformationObject.mapBookingRevenue.size() > 0 && dataHistoryObjToUpdate.mapBookingRevenue != null) {
                for(AccountDataHistory.Revenue revenue : guestAccountInformationObject.mapBookingRevenue.values()) {
                    if(dataHistoryObjToUpdate.mapBookingRevenue.containsKey(revenue.bookingId)) {
                        dataHistoryObjToUpdate.mapBookingRevenue.get(revenue.bookingId).bookingRevenue = revenue.bookingRevenue;
                        dataHistoryObjToUpdate.mapBookingRevenue.get(revenue.bookingId).year = revenue.year; 
                    } else {
                        dataHistoryObjToUpdate.mapBookingRevenue.put(revenue.bookingId, revenue);
                    }
                }                
                dataHistoryObjToUpdate.setTotalRevenue();
                if(guestAccount.Total_Revenue__pc == null) {
                    guestAccount.Total_Revenue__pc = 0;
                }
                
                // update companies fields
                if(guestAccount.Current_Compagny__pc != null) {
                    setCompaniesToUpdate.add(guestAccount.Current_Compagny__pc);
                }
                guestAccount.Total_Revenue__pc = dataHistoryObjToUpdate.totalRevenue;
            }
            */
            // Update data history field
            guestAccount.Data_History__c = JSON.serialize(dataHistoryObjToUpdate);
            
        }
        System.debug('###gho setCompaniesToUpdate :' + setCompaniesToUpdate);
        update listGuestAccounts;
        if(setCompaniesToUpdate.size() > 0) {
            updateCompaniesFields(setCompaniesToUpdate);
        }
    }
    
    public static void updateCompaniesFields(Set<Id> setCompanies) {
        List<Account> lstGuestAccounts = [SELECT Id,Current_Compagny__pc, Data_History__c
                                          FROM Account
                                          Where Current_Compagny__pc IN:setCompanies
                                         ];
        System.debug('###gho lstGuestAccounts : ' +lstGuestAccounts);
        Map<Id, Account> mapCompaniesToTreat = new Map<Id, Account>();
        AccountDataHistory dataHistoryField = null;
        decimal revenue;
        decimal nights;
        Account company;
        for(Account guestAccount : lstGuestAccounts) {
            if(guestAccount.Data_History__c != null) {
                dataHistoryField = AccountDataHistory.parse(guestAccount.Data_History__c);
                if(!mapCompaniesToTreat.containsKey(guestAccount.Current_Compagny__pc)) {
                    mapCompaniesToTreat.put(guestAccount.Current_Compagny__pc, new Account(Id = guestAccount.Current_Compagny__pc));
                }
                company = mapCompaniesToTreat.get(guestAccount.Current_Compagny__pc);
                nights = company.Total_Nights__c == null ? 0 : company.Total_Nights__c;
                revenue = company.Total_Revenue__c == null ? 0: company.Total_Revenue__c;
               /* if(dataHistoryField.totalNights== null) {
                    dataHistoryField.totalNights = 0;
                }
                if(dataHistoryField.totalRevenue == null) {
                    dataHistoryField.totalRevenue = 0;
                }
                company.Total_Nights__c = dataHistoryField.totalNights + nights;
                company.Total_Revenue__c = dataHistoryField.totalRevenue + revenue;
              */  
            } 
        }
        if(mapCompaniesToTreat.size() > 0) {
            update mapCompaniesToTreat.values();  
        }
    }
    
    private static void doUpdateCustomerType(Account guestAccount, Integer businessTypeCounter, Integer leisureTypeCounter) {
        guestAccount.Customer_type__pc = businessTypeCounter > leisureTypeCounter ? Label.BusinessCustomerType : 
        businessTypeCounter < leisureTypeCounter ? Label.LeisureCustomerType :
        businessTypeCounter != 0 ? Label.MixedCustomerType : null;
    }
    
    public static void doUpdateCountries(Account guestAccount, AccountDataHistory.CountryPercentage cp) {
        system.debug('@@@ in doUpdateCountries ' + cp);
        Integer sum = cp.france + cp.spain + cp.italy + cp.germany + cp.poland + cp.others;
        	guestAccount.Booking_FranceNB__c = cp.france;
            guestAccount.Booking_SpainNB__c = cp.spain;
            guestAccount.Booking_OthersNB__c = cp.others;
            guestAccount.Booking_GermanyNB__c = cp.germany;
            guestAccount.Booking_ItalyNB__c = cp.italy;
            guestAccount.Booking_PolandNB__c = cp.poland; 
        if(sum>0){
            guestAccount.Booking_France__c = cp.france*100/sum;
            guestAccount.Booking_Spain__c = cp.spain*100/sum;
            guestAccount.Booking_Others__c = cp.others*100/sum;
            guestAccount.Booking_Germany__c = cp.germany*100/sum;
            guestAccount.Booking_Italy__c = cp.italy*100/sum;
            guestAccount.Booking_Poland__c = cp.poland*100/sum; 
        } if(sum==0){
            guestAccount.Booking_France__c = 0; 
            guestAccount.Booking_Spain__c = 0;
            guestAccount.Booking_Others__c = 0;
            guestAccount.Booking_Germany__c = 0;
            guestAccount.Booking_Italy__c = 0;
            guestAccount.Booking_Poland__c = 0; 
        }
    }
}