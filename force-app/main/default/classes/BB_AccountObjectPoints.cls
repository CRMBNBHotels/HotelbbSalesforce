/*
* Description: Class to initialise all info used in the WS and the actions on error/success
* Ticket NB: CRMSS-128
* @author: TMA Cynthia Geagea
* @date: 27/05/2019
* @Test class: BB_AccountObjectPoints_Test
* @Coverage: 85 %
*/

public without sharing class BB_AccountObjectPoints extends BB_Object implements BB_Object_Interface,BB_Object_Sync_Interface{
    
    public String initializeRequestEndpoint() {
        return null;
    }
    
    public String initializeRequestEndpointUpdate() {
        String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_WalletEndpointUpdate;
        return endPoint;
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey, String sfdcId,set<String> setfieldtoInclude, String PageDateKey) {
        
        BBPointsRequestWrapper AccountWrapper = new BBPointsRequestWrapper();
        AccountWrapper.UpdateWalletRQ = new UpdateWalletRQ();
        AccountWrapper.UpdateWalletRQ.Id = sfdcId;
        AccountWrapper.UpdateWalletRQ.Type = '';
        AccountWrapper.UpdateWalletRQ.Reason = '';

        String JsonNotCompleted = JSON.serialize(AccountWrapper);
        String JsonToReturn;
        
        if(setfieldtoInclude != null && setfieldtoInclude.size()>0){
            JsonToReturn = FillField(JsonNotCompleted, setfieldtoInclude,sfdcId);
        }
        return JsonToReturn;   
        
    }
    
    public String FillField(String JsonObject, Set<String> setfieldtoInclude,String sfdcId) {
                
        String Query = 'Select Id, Email__pc,Tech_points_results__c,';
        for(String field : setfieldtoInclude){
            query = query + field + ',';
        }
        query = query.removeEnd(',');
        query = query + ' from account where externalID__c = \'' + sfdcId + '\' limit 1';
        Account acc = Database.query(query);
        String oldDataJson = acc.Tech_points_results__c;
        AP02_SObject_WS.SerializeObject OldDataWrapper = (AP02_SObject_WS.SerializeObject)JSON.deserialize(oldDataJson, AP02_SObject_WS.SerializeObject.class); 
        
        BBPointsRequestWrapper AccountWrapper = new BBPointsRequestWrapper();
        AccountWrapper = (BBPointsRequestWrapper)JSON.deserializeStrict(JsonObject,BBPointsRequestWrapper.Class);
        if(setfieldtoInclude != null && setfieldtoInclude.size()>0){
            AccountWrapper.UpdateWalletRQ.Email = acc.Email__pc;
            AccountWrapper.UpdateWalletRQ.Amount = String.valueOf(OldDataWrapper.nbPoint);
            String TypeTrans;
            if((String)OldDataWrapper.typePt == 'Ajout' || (String)OldDataWrapper.typePt == 'Adding'){
                TypeTrans = 'ADD';
            }else if((String)OldDataWrapper.typePt == 'Suppression'){
                TypeTrans = 'REMOVE';
            }else {
                TypeTrans = (String)OldDataWrapper.typePt;
            }
            AccountWrapper.UpdateWalletRQ.type = TypeTrans;
            //AccountWrapper.UpdateWalletRQ.Reason = (String)OldDataWrapper.Reason;
            
            //Added by TMA Cynthia Geagea - CRMSS 234 - 30/07/2019 - CRMSS 260 - 27/08/2019 - Start
            if(getReasonWithLanguage(OldDataWrapper, sfdcId) != null){
                
                if((String)OldDataWrapper.Description != null){
                    
                    AccountWrapper.UpdateWalletRQ.Reason = getReasonWithLanguage(OldDataWrapper, sfdcId) + ' - ' + (String)OldDataWrapper.Description;
                }
                else{
                    
                    AccountWrapper.UpdateWalletRQ.Reason = getReasonWithLanguage(OldDataWrapper, sfdcId);  
                }
            }
            else{
                
                AccountWrapper.UpdateWalletRQ.Reason = (String)OldDataWrapper.Reason;
            }
            //Added by TMA Cynthia Geagea - CRMSS 234 - 30/07/2019 - CRMSS 260 - 27/08/2019 - End
        }
        
        String strBody = JSON.serialize(AccountWrapper,true);
        strBody = strBody.replace('"UpdateWalletRQ":', '"bb:UpdateWalletRQ":');
        strBody = strBody.replace('"Id":', '"@ID":');
        strBody = strBody.replace('"Email":', '"@Email":');
        strBody = strBody.replace('"Amount":', '"@Amount":');
        strBody = strBody.replace('"Type":', '"@Type":');
        strBody = strBody.replace('"Reason":', '"@Reason":');
        system.debug('strBody in initialize'+strBody);
        return strBody;
    }
    
    //Added by TMA Cynthia Geagea - CRMSS 234 - 30/07/2019 - Start
    
    public String getReasonWithLanguage(AP02_SObject_WS.SerializeObject OldDataWrapper, String sfdcId){
        
        List<Account> listAccountLang = [Select Language__pc 
                                         from Account 
                                         where externalID__c =: sfdcId
                                         limit 1];
        
        String accountLang;
        if(listAccountLang != null && listAccountLang.size()>0 && listAccountLang[0].Language__pc != null){
            
            accountLang = listAccountLang[0].Language__pc; 
        }
        else{
            
            accountLang = 'EN';
        }
        system.debug('### accountLang'+accountLang);
        String userLangComp = UserInfo.getLanguage();
        String userLangSplit = userLangComp.split('_').get(0);
        String userLang = userLangSplit.toUppercase();
        system.debug('### userLang'+userLang);
        String reasonValue = (String)OldDataWrapper.Reason;
        system.debug('### reasonValue'+reasonValue);
        
        //added by TMA EIL CRMSS-469 24-02-2020 Start
        /*List<Language__c> listLang = [select Language_Client__c, Language_User__c, Translated_Value__c, Value__c
                                      from Language__c
                                      where Language_User__c =:userLang And Language_Client__c =:accountLang and Translated_Value__c =: reasonValue
                                      limit 1];*/
        List<Languagemdtp__mdt> listLang = [select Language_Client__c, Language_User__c, Translated_Value__c, Value__c
                                      from Languagemdtp__mdt
                                      where Language_User__c =:userLang And Language_Client__c =:accountLang and Translated_Value__c =: reasonValue
                                      limit 1];
        //added by TMA EIL CRMSS-469 24-02-2020 end
        
        
        system.debug('### listLang'+listLang);
        String reasonValueTrans;
        if(listLang != null && listLang.size()>0){
            
            reasonValueTrans = listLang[0].Value__c;
            system.debug('### reasonValueTrans'+reasonValueTrans);
        }
        
        return reasonValueTrans;
    }
    
    //Added by TMA Cynthia Geagea - CRMSS 234 - 30/07/2019 - End
 
    public DataTableWrapper createTableFromResponse(String strResponse) {
        
        return null;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        
        return null;
    }
    
    public Account actionBadResponse(String strResponse, String sfdcId,set<String> listField){
        
        String Query = 'Select id, Point_Request__c,';
        query = query.removeEnd(',');
        query = query + ' from Account where id = \'' + sfdcId + '\' limit 1';
        
        Account acc = Database.query(query);
        
        if(strResponse != null && strResponse != ''){
            
            strResponse = cleanResponse(strResponse);
            BBPointsResponseWrapper responseWrapper = (BBPointsResponseWrapper)JSON.deserialize(strResponse, BBPointsResponseWrapper.class);
            
            //Check if error
            if(responseWrapper.UpdateWalletRS.Errors != null){
                
                acc.Point_Request__c = 'Error : ' + responseWrapper.UpdateWalletRS.Errors.error[0].ShortText + ' ' + String.valueOf(DateTime.now().format());
                acc.Tech_BBUS__c = False;
            }
        }
        
        return acc;
    }
    
    public void actionGoodResponse(String strResponse){
        
        strResponse = cleanResponse(strResponse); 
        BBPointsResponseWrapper responseWrap = (BBPointsResponseWrapper)JSON.deserialize(strResponse, BBPointsResponseWrapper.class);        
        // check for Success
        if(responseWrap.UpdateWalletRS.success == null) {
            System.debug('Success');
        }
    }
    
    //request wrappers
    public class BBPointsRequestWrapper{
        public UpdateWalletRQ UpdateWalletRQ {get;set;}
    }
    public class UpdateWalletRQ{
        public String Id {get;set;}
        public String Email {get;set;}
        public String Type {get;set;}
        public String Amount {get;set;}
        public String Reason {get;set;}
    }
    //End of request wrappers
    
    //Response Wrappers
    public class BBPointsResponseWrapper{
        public UpdateWalletRS UpdateWalletRS {get;set;}
    }
    public class UpdateWalletRS{
        public Errors Errors {get;set;}
        public Success Success {get;set;}
        public string TimeStamp {get;set;}
    }
    public class Errors{
        public List<Error> Error {get;set;}
    }
    public class Error{
        public string body {get;set;}
        public string Type {get;set;}
        public string ShortText {get;set;}
        public string Code {get;set;}
    }
    public class Success{
        
    }
    //End of response wrappers
    
}