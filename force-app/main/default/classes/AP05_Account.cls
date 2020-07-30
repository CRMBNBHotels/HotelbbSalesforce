/*
* Description: Class Called when modifiying an Account to stock the old data in a json field and to call the WS BBUS so that the modification will be also applied their 
* Ticket NB: CRMSS-96 - 130
* @author: TMA JK
* @date: 01/05/2019
* @Test class: AP05_Account_test
*/
public without sharing class AP05_Account {
    //Method to stock the old data in a json field
    public static void StockOldData(Map<ID,Account> newMap, Map<ID,Account> oldMap) {
        system.debug('@@@ StockOldData');
        Map<String,SObject> mapAccObject = new Map<String,SObject>();
        Map<String,String> mapJsonObject = new Map<String,String>();
        Set<String> setFieldToInclude = new Set<String>();
        //Get all fields modified
        for(Id accId : oldMap.Keyset()){
            if(oldMap.get(accId).email__pc != newMap.get(accId).email__pc){
                setFieldToInclude.add('email__pc');
            }
            if(oldMap.get(accId).E_mail_address_2__pc != newMap.get(accId).E_mail_address_2__pc){
                setFieldToInclude.add('E_mail_address_2__pc');
            }
            if(oldMap.get(accId).firstname != newMap.get(accId).firstname){
                setFieldToInclude.add('firstname');
            }
            if(oldMap.get(accId).lastname != newMap.get(accId).lastname){
                setFieldToInclude.add('lastname');
                
            }
            if(oldMap.get(accId).PersonMobilePhone != newMap.get(accId).PersonMobilePhone){
                setFieldToInclude.add('PersonMobilePhone');
            }
            if(oldMap.get(accId).Mobile_Phone_Number_2__pc != newMap.get(accId).Mobile_Phone_Number_2__pc){
                setFieldToInclude.add('Mobile_Phone_Number_2__pc');
            }
            if(oldMap.get(accId).E_Club_Status__c != newMap.get(accId).E_Club_Status__c){
                setFieldToInclude.add('E_Club_Status__c');
            }
            if(oldMap.get(accId).E_club_Expiration_date__pc != newMap.get(accId).E_club_Expiration_date__pc){
                setFieldToInclude.add('E_club_Expiration_date__pc');
            }
            if(oldMap.get(accId).PersonMailingCity != newMap.get(accId).PersonMailingCity){
                setFieldToInclude.add('PersonMailingCity');
            }
            
            if(oldMap.get(accId).PersonMailingCountry != newMap.get(accId).PersonMailingCountry){
                setFieldToInclude.add('PersonMailingCountry');
            }
            if(oldMap.get(accId).PersonMailingState != newMap.get(accId).PersonMailingState){
                setFieldToInclude.add('PersonMailingState');
            }
            if(oldMap.get(accId).PersonMailingPostalCode != newMap.get(accId).PersonMailingPostalCode){
                setFieldToInclude.add('PersonMailingPostalCode');
            }
            if(oldMap.get(accId).PersonMailingStreet != newMap.get(accId).PersonMailingStreet){
                setFieldToInclude.add('PersonMailingStreet');
            }
            
            //Send field to create an instance of an account having the old data of the fields modified
            if(setFieldToInclude != null && setFieldToInclude.size()>0){
                Sobject Account = AP02_SObject_WS.SetFieldAndValue(oldMap.get(AccId),setFieldToInclude);
                mapAccObject.put(accId,Account);
            }
        } 
        //Serialize the account created with the old data
        if(mapAccObject != null && mapAccObject.size() > 0){
            mapJsonObject = AP02_SObject_WS.Serialize(mapAccObject,null,null); 
        }
        //Check the fields modified + if the user is not the technical user + the field that shows the status of the synchronisation between BBUS and SF should not be modified to a value other than "Processing"
        for(Account acc : newMap.values() ){
            String Idcurr = acc.id;
            String ConnectedUserId = userinfo.getUserId();
            IF( ConnectedUserId.substring(0,15) != label.technical_user_2_id){
                //If the info modified is related to E-Club put the correspondant field to "Processing" showing the status of the sync
                if( (newMap.get(Idcurr).E_Club_Status__c != oldMap.get(Idcurr).E_Club_Status__c || newMap.get(Idcurr).E_club_Expiration_date__pc !=  oldMap.get(Idcurr).E_club_Expiration_date__pc)
                   && newMap.get(Idcurr).Eclub_change_request__c == oldMap.get(Idcurr).Eclub_change_request__c)
                { 
                    acc.Eclub_change_request__c = 'Processing';  
                    if(mapJsonObject.containskey(Idcurr)){
                        acc.Tech_Data__c = mapJsonObject.get(Idcurr);
                    }
                } 
                //If the info modified is related to personal info,  put the correspondant field to "Processing" showing the status of the sync
                if((newMap.get(Idcurr).Syncstatus__c == 'Processing' || newMap.get(Idcurr).Syncstatus__c == oldMap.get(Idcurr).Syncstatus__c) && 
                   (newMap.get(Idcurr).email__pc != oldMap.get(Idcurr).email__pc || newMap.get(Idcurr).E_mail_address_2__pc != oldMap.get(Idcurr).E_mail_address_2__pc || newMap.get(Idcurr).firstname != oldMap.get(Idcurr).firstname ||
                    newMap.get(Idcurr).lastname != oldMap.get(Idcurr).lastname || newMap.get(Idcurr).PersonMobilePhone != oldMap.get(Idcurr).PersonMobilePhone || newMap.get(Idcurr).Mobile_Phone_Number_2__pc != oldMap.get(Idcurr).Mobile_Phone_Number_2__pc 
                    || newMap.get(Idcurr).PersonMailingCountry != oldMap.get(Idcurr).PersonMailingCountry  || newMap.get(Idcurr).PersonMailingCity != oldMap.get(Idcurr).PersonMailingCity || 
                    newMap.get(Idcurr).PersonMailingState != oldMap.get(Idcurr).PersonMailingState || newMap.get(Idcurr).PersonMailingPostalCode != oldMap.get(Idcurr).PersonMailingPostalCode 
                    || newMap.get(Idcurr).PersonMailingStreet != oldMap.get(Idcurr).PersonMailingStreet ))
                {
                    
                    acc.Syncstatus__c = 'Processing';
                    if(mapJsonObject.containskey(Idcurr)){
                        acc.Tech_Data__c = mapJsonObject.get(Idcurr);
                    }
                }
            }
        }
    }  
    
    //Method to call the WS on update
    public static void CallWSUpdatePersonAccountInfo(Map<ID,Account> newMap, Map<ID,Account> oldMap) {
        system.debug('### jka in CallWSUpdatePersonAccountInfo');
        
        Account accountToAddNEW = new Account();
        Account accountToAddOLD = new Account();
        
        Map<String,String> mapfieldModified = new Map<String,String>();
        Map<ID,Account> mapOldData = new Map<ID,Account>();
        Map<ID,Account> mapNewData = new Map<ID,Account>();
        List<account> listAcc = new List<Account>();
        Set<String> setFieldEClub = new Set<String>();
        //Check the fields modified + if the user is not the technical user + the field that shows the status of the synchronisation between BBUS and SF should not be modified to a value other than "Processing"
        for(Id Idcurr : newMap.Keyset() ){
            accountToAddOLD = new Account();
            accountToAddNEW = new Account();
            String ConnectedUserId = userinfo.getUserId();
            IF( ConnectedUserId.substring(0,15) != label.technical_user_2_id){
                //If the info modified is related to personal info, set a list of fields modified and call a future method to perform the callout for BBUS
                if((newMap.get(Idcurr).Syncstatus__c =='Processing' || newMap.get(Idcurr).Syncstatus__c == oldMap.get(Idcurr).Syncstatus__c )&& 
                   (newMap.get(Idcurr).email__pc != oldMap.get(Idcurr).email__pc || newMap.get(Idcurr).E_mail_address_2__pc != oldMap.get(Idcurr).E_mail_address_2__pc || newMap.get(Idcurr).firstname != oldMap.get(Idcurr).firstname ||
                    newMap.get(Idcurr).lastname != oldMap.get(Idcurr).lastname || newMap.get(Idcurr).PersonMobilePhone != oldMap.get(Idcurr).PersonMobilePhone || newMap.get(Idcurr).Mobile_Phone_Number_2__pc != oldMap.get(Idcurr).Mobile_Phone_Number_2__pc 
                    || newMap.get(Idcurr).PersonMailingCountryCode  != oldMap.get(Idcurr).PersonMailingCountryCode  || newMap.get(Idcurr).PersonMailingCity != oldMap.get(Idcurr).PersonMailingCity || 
                    newMap.get(Idcurr).PersonMailingState != oldMap.get(Idcurr).PersonMailingState || newMap.get(Idcurr).PersonMailingPostalCode != oldMap.get(Idcurr).PersonMailingPostalCode || newMap.get(Idcurr).PersonMailingStreet != oldMap.get(Idcurr).PersonMailingStreet) )
                {
                    accountToAddNEW.id = Idcurr;
                    accountToAddOLD.id = Idcurr;
                    if(oldMap.get(Idcurr).email__pc != newMap.get(Idcurr).email__pc){
                        accountToAddOLD.email__pc = oldMap.get(Idcurr).email__pc;
                        accountToAddNEW.email__pc = newMap.get(Idcurr).email__pc;
                        mapfieldModified.put('email__pc',newMap.get(Idcurr).email__pc);
                    }
                    if(oldMap.get(Idcurr).E_mail_address_2__pc != newMap.get(Idcurr).E_mail_address_2__pc){
                        accountToAddOLD.E_mail_address_2__pc = oldMap.get(Idcurr).E_mail_address_2__pc;
                        accountToAddNEW.E_mail_address_2__pc = newMap.get(Idcurr).E_mail_address_2__pc;
                        mapfieldModified.put('E_mail_address_2__pc',newMap.get(Idcurr).E_mail_address_2__pc);
                    }
                    if(oldMap.get(Idcurr).firstname != newMap.get(Idcurr).firstname){
                        accountToAddOLD.firstname = oldMap.get(Idcurr).firstname;
                        accountToAddNEW.firstname = newMap.get(Idcurr).firstname;
                        mapfieldModified.put('firstname',newMap.get(Idcurr).firstname);
                    }
                    if(oldMap.get(Idcurr).lastname != newMap.get(Idcurr).lastname){
                        accountToAddOLD.lastname = oldMap.get(Idcurr).lastname;
                        accountToAddNEW.lastname = newMap.get(Idcurr).lastname;
                        mapfieldModified.put('lastname',newMap.get(Idcurr).lastname);
                        
                    }
                    if(oldMap.get(Idcurr).PersonMobilePhone != newMap.get(Idcurr).PersonMobilePhone){
                        accountToAddOLD.PersonMobilePhone = oldMap.get(Idcurr).PersonMobilePhone;
                        accountToAddNEW.PersonMobilePhone = newMap.get(Idcurr).PersonMobilePhone;
                        mapfieldModified.put('PersonMobilePhone',newMap.get(Idcurr).PersonMobilePhone);
                    }
                    if(oldMap.get(Idcurr).Mobile_Phone_Number_2__pc != newMap.get(Idcurr).Mobile_Phone_Number_2__pc){
                        accountToAddOLD.Mobile_Phone_Number_2__pc = oldMap.get(Idcurr).Mobile_Phone_Number_2__pc;
                        accountToAddNEW.Mobile_Phone_Number_2__pc = newMap.get(Idcurr).Mobile_Phone_Number_2__pc;
                        mapfieldModified.put('Mobile_Phone_Number_2__pc',newMap.get(Idcurr).Mobile_Phone_Number_2__pc);
                    }
                    if(oldMap.get(Idcurr).PersonMailingCity != newMap.get(Idcurr).PersonMailingCity){
                        accountToAddOLD.PersonMailingCity = oldMap.get(Idcurr).PersonMailingCity;
                        accountToAddNEW.PersonMailingCity = newMap.get(Idcurr).PersonMailingCity;
                        mapfieldModified.put('PersonMailingCity',newMap.get(Idcurr).PersonMailingCity);
                    }
                    if(oldMap.get(Idcurr).PersonMailingState != newMap.get(Idcurr).PersonMailingState){
                        accountToAddOLD.PersonMailingState = oldMap.get(Idcurr).PersonMailingState;
                        accountToAddNEW.PersonMailingState = newMap.get(Idcurr).PersonMailingState;
                        mapNewData.put(Idcurr,accountToAddNEW);
                        mapOLDData.put(Idcurr,accountToAddOLD);
                        mapfieldModified.put('PersonMailingState',newMap.get(Idcurr).PersonMailingState);
                    }
                    if(oldMap.get(Idcurr).PersonMailingPostalCode != newMap.get(Idcurr).PersonMailingPostalCode){
                        accountToAddOLD.PersonMailingPostalCode = oldMap.get(Idcurr).PersonMailingPostalCode;
                        accountToAddNEW.PersonMailingPostalCode = newMap.get(Idcurr).PersonMailingPostalCode;
                        mapfieldModified.put('PersonMailingPostalCode',newMap.get(Idcurr).PersonMailingPostalCode);
                    }
                    if(oldMap.get(Idcurr).PersonMailingStreet != newMap.get(Idcurr).PersonMailingStreet){
                        accountToAddOLD.PersonMailingStreet = oldMap.get(Idcurr).PersonMailingStreet;
                        accountToAddNEW.PersonMailingStreet = newMap.get(Idcurr).PersonMailingStreet;
                        mapfieldModified.put('PersonMailingStreet',newMap.get(Idcurr).PersonMailingStreet);
                    }
                    if(oldMap.get(Idcurr).PersonMailingCountryCode  != newMap.get(Idcurr).PersonMailingCountryCode ){
                        accountToAddOLD.PersonMailingCountry = oldMap.get(Idcurr).PersonMailingCountry;
                        accountToAddNEW.PersonMailingCountry = newMap.get(Idcurr).PersonMailingCountry;
                        mapNewData.put(Idcurr,accountToAddNEW);
                        mapOLDData.put(Idcurr,accountToAddOLD);
                        mapfieldModified.put('PersonMailingCountry',newMap.get(Idcurr).PersonMailingCountry);
                        mapfieldModified.put('PersonMailingCountryCode',newMap.get(Idcurr).PersonMailingCountryCode);
                    }
                    
                    //Call the future method
                    //CallWS(newMap.get(Idcurr).externalID__c,Idcurr,mapfieldModified.keyset());
                    
                    
                    //If it's from a batch or future method call the regular method
                    //Modified by TMA JKA - CRMSS 328 - 18/10/2019
                    //If it's from from SF (without extID) do not call the WS
                    if((System.isFuture() || System.isBatch()) && newMap.get(Idcurr).externalID__c!=null){
                        regularCallWS(newMap.get(Idcurr).externalID__c,Idcurr,mapfieldModified.keyset(),newMap.get(Idcurr).lastname);
                    } 
                    else {
                        
                        //call the future method
                        //Modified by TMA JKA - CRMSS 328 - 18/10/2019
                        //If it's from from SF (without extID) do not call the WS
                        System.debug('### jka extId)'+newMap.get(Idcurr).externalID__c);
                        if((Limits.getFutureCalls() < Limits.getLimitFutureCalls())&& newMap.get(Idcurr).externalID__c!=null){
                            futureCallWS(newMap.get(Idcurr).externalID__c,Idcurr,mapfieldModified.keyset(),newMap.get(Idcurr).lastname);
                        }
                    }
                }
                //newMap.get(Idcurr).E_Club_Status__c != oldMap.get(Idcurr).E_Club_Status__c || 
                //If the info modified is related to Eclub info, set a list of fields modified and call a future method to perform the callout for BBUS
                if ((newMap.get(Idcurr).Eclub_change_request__c =='Processing' || newMap.get(Idcurr).Eclub_change_request__c == oldMap.get(Idcurr).Eclub_change_request__c )&& 
                    (newMap.get(Idcurr).E_club_Expiration_date__pc != oldMap.get(Idcurr).E_club_Expiration_date__pc)){
                        system.debug('### cg in ap05 before regular call');
                        system.debug('### cg in ap05 before regular call newMap.get(Idcurr).Eclub_change_request__c'+newMap.get(Idcurr).Eclub_change_request__c);
                        system.debug('### cg in ap05 before regular call oldMap.get(Idcurr).Eclub_change_request__c'+oldMap.get(Idcurr).Eclub_change_request__c);
                        system.debug('### cg in ap05 before regular call newMap.get(Idcurr).E_Club_Status__c'+newMap.get(Idcurr).E_Club_Status__c);
                        system.debug('### cg in ap05 before regular call oldMap.get(Idcurr).E_Club_Status__c'+oldMap.get(Idcurr).E_Club_Status__c);
                        system.debug('### cg in ap05 before regular call newMap.get(Idcurr).E_club_Expiration_date__pc'+newMap.get(Idcurr).E_club_Expiration_date__pc);
                        system.debug('### cg in ap05 before regular call oldMap.get(Idcurr).E_club_Expiration_date__pc'+oldMap.get(Idcurr).E_club_Expiration_date__pc);
                        
                        
                        
                       // if(oldMap.get(Idcurr).E_Club_Status__c != newMap.get(Idcurr).E_Club_Status__c){
                      //      setFieldEClub.add('E_Club_Status__c');
                     //   }
                        if(oldMap.get(Idcurr).E_club_Expiration_date__pc != newMap.get(Idcurr).E_club_Expiration_date__pc){
                            setFieldEClub.add('E_club_Expiration_date__pc');
                        }
                        
                        //Call the future method
                        //Modified by TMA Cynthia Geagea - CRMSS 270-271 - 18/09/2019 - Start
                        //If it's from a batch or future method call the regular method
                        if(System.isFuture() || System.isBatch()){
                            regularCallWSEClub(newMap.get(Idcurr).externalID__c,Idcurr,setFieldEClub);
                        } 
                        else {
                            //call the future method
                            if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()){
                                futureCallWSEClub(newMap.get(Idcurr).externalID__c,Idcurr,setFieldEClub);
                            }
                        }
                        
                        //CallWSEClub(newMap.get(Idcurr).externalID__c,Idcurr,setFieldEClub);
                        //Modified by TMA Cynthia Geagea - CRMSS 270-271 - 18/09/2019 - End
                    }
            }
            if(mapOldData != null && mapOldData.size() > 0 && mapNewData != null && mapNewData.size() > 0){
                StockOldData( mapNewData, mapOldData);
                update mapNewData.values();
            }
        }
    }
    
    //Future method to perform the callout to BBUS and check if it's a bad response or good response and perform the correspondant action
    @future(callout=true)
    Public Static Void futureCallWS(String ExtID, String Idcurr,Set<String> setfieldModif, String Status){
        regularCallWS(ExtID, Idcurr, setfieldModif, Status);
    }
    
    //Method to perform the callout to BBUS and check if it's a bad response or good response and perform the correspondant action
    Public Static Void regularCallWS(String ExtID, String Idcurr,Set<String> setfieldModif, String Status){
        

        BB_AccountObject accountobject = new BB_AccountObject(); 
        Account acc = new Account();
        try {
            
            HttpResponse response = BBUS_DataHistoryManager.callBBUSWebserviceResponse('Account', null, null, ExtID,setfieldModif);  
            String strResponse = response.getBody();
            Log__c log = new Log__c();
            log.WSName__c = 'Account Synchronisation Return';
            log.JsonMessage__c = strResponse;
            log.FromSalesforce__c = true;
            insert log;
            //if it's a bad response then perform a roolback + set the status of the sync to error
            if(response.getStatusCode() != 200){
                
                acc =  accountobject.actionBadResponse(strResponse, Idcurr,setfieldModif);
                
            }else{
                
                //if it's a good response then set the status of the sync to Successful with the date
                acc.id = Idcurr;
                acc.Syncstatus__c = 'Successful ' + String.valueOf(DateTime.now().format()) ;
            }
            update acc;
        }catch(Exception e) {
            //if we could not perform the callout, set the status to error with the date
            acc =  accountobject.actionBadResponse(null, Idcurr,setfieldModif);
            acc.Syncstatus__c = 'Error ' + String.valueOf(DateTime.now().format());
            update acc;
        }
    }
    
    //Future method to perform the callout to BBUS and check if it's a bad response or good response and perform the correspondant action
    //Modified by TMA Cynthia Geagea - CRMSS 270-271 - 18/09/2019 - Start
    @future(callout=true)
    public static void futureCallWSEClub(String ExtID, String Idcurr,Set<String> setfieldModif){
        regularCallWSEClub(ExtID, Idcurr, setfieldModif);
    }
    //Modified by TMA Cynthia Geagea - CRMSS 270-271 - 18/09/2019 - End
    
    Public Static Void regularCallWSEClub(String ExtID, String Idcurr,Set<String> setfieldModif){
        BB_AccountObjectEClub accountobject = new BB_AccountObjectEClub(); 
        Account acc = new Account();
        try {            
            HttpResponse response = BBUS_DataHistoryManager.callBBUSWebserviceResponse('AccountEClub', null, null, ExtID,setfieldModif);
            String strResponse = response.getBody();
            system.debug('### strResponse body ' + strResponse );
            Log__c log = new Log__c();
            log.WSName__c = 'Account EClub Synchronisation Return';
            log.JsonMessage__c = strResponse;
            log.FromSalesforce__c = true;
            insert log;
            //if it's a bad response then perform a roolback + set the status of the sync to error
            if(response.getStatusCode() != 200){
                acc =  accountobject.actionBadResponse(strResponse, Idcurr,setfieldModif);
            }else{
                //if it's a good response then set the status of the sync to Successful with the date
                acc.id = Idcurr;
                acc.Eclub_change_request__c = 'Successful ' + String.valueOf(DateTime.now().format());
            }
            update acc;
        }catch(Exception e) {
            //if we could not performed the callout, set the status to error with the date
            acc =  accountobject.actionBadResponse(null, Idcurr,setfieldModif);
            acc.Eclub_change_request__c = 'Error ' + String.valueOf(DateTime.now().format());
            update acc; 
        }
    }
}