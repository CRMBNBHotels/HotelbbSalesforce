/*
* Description: Class to initialise all info used in the WS and the actions on error/success
* Ticket NB: CRMSS-130
* @author: TMA JK
* @date: 10/05/2019
* @Test class: 
*/
public without sharing class BB_AccountObjectEClub extends BB_Object implements BB_Object_Interface,BB_Object_Sync_Interface {

    public String initializeRequestEndpointUpdate() {
        String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_UpdateAccountEClubEndpoint;
        return endPoint;
    }
    
    public String initializeRequestEndpoint() {
        return null;
        
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey, String sfdcId,set<String> setfieldtoInclude, String PageDateKey) {
        
        BBAccountRequestWrapper AccountWrapper = new BBAccountRequestWrapper();
        AccountWrapper.UpdateClubRQ = new UpdateClubRQ();
        AccountWrapper.UpdateClubRQ.ID = sfdcId;
        
        String JsonNotCompleted = JSON.serialize(AccountWrapper);
        String JsonToReturn;

        if(setfieldtoInclude != null && setfieldtoInclude.size()>0){
            JsonToReturn = FillField(JsonNotCompleted, setfieldtoInclude,sfdcId);
        }
        return JsonToReturn;
    }
    
    public String FillField(String JsonObject, Set<String> setfieldtoInclude,String sfdcId) {
        String Query = 'Select Email__pc,';
        for(String field : setfieldtoInclude){
            query = query + field + ',';
        }
        query = query.removeEnd(',');
        query = query + ' from account where externalID__c = \'' + sfdcId + '\' limit 1';
        Account acc = Database.query(query);
        BBAccountRequestWrapper AccountWrapper = new BBAccountRequestWrapper();
        AccountWrapper = (BBAccountRequestWrapper)JSON.deserializeStrict(JsonObject,BBAccountRequestWrapper.Class);
        if(setfieldtoInclude != null && setfieldtoInclude.size()>0){
            AccountWrapper.UpdateClubRQ.Email = acc.Email__pc;
            if(setfieldtoInclude.contains('E_Club_Status__c') ){
                AccountWrapper.UpdateClubRQ.Status = acc.E_Club_Status__c;
            }
            if(setfieldtoInclude.contains('E_club_Expiration_date__pc')){
               AccountWrapper.UpdateClubRQ.ExpirationDate = String.valueOf(acc.E_club_Expiration_date__pc);
            }
            
        }
        String strBody = JSON.serialize(AccountWrapper,true);
        strBody = strBody.replace('"UpdateClubRQ":', '"bb:UpdateClubRQ":');
        strBody = strBody.replace('"ID":', '"@ID":');
        strBody = strBody.replace('"Email":', '"@Email":');
        if(strBody.contains('"Status":')){
            strBody = strBody.replace('"Status":', '"@Status":');
        }
        if(strBody.contains('"ExpirationDate":')){
            strBody = strBody.replace('"ExpirationDate":', '"@ExpirationDate":');
        }
        return strBody;
    }
    
    public DataTableWrapper createTableFromResponse(String strResponse) {
        return null;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        return null;
    } 
    
    public Account actionBadResponse(String strResponse, String sfdcId,set<String> listField) {
        
        String Query = 'Select id,Tech_Data__c';
        query = query + ' from account where id = \'' + sfdcId + '\' limit 1';
        
        Account acc = Database.query(query);
        acc.Eclub_change_request__c = 'Error : ';
        
        String oldDataJson = acc.Tech_Data__c;
        
        AP02_SObject_WS.SerializeObject OldDataWrapper = (AP02_SObject_WS.SerializeObject)JSON.deserialize(oldDataJson, AP02_SObject_WS.SerializeObject.class);
   
        if(listField != null && listField.size()>0){
            
            if(OldDataWrapper.sobj == null || OldDataWrapper.sobj.get('E_club_Expiration_date__pc') == null || OldDataWrapper.sobj.get('E_Club_Status__c') != null){
                if(listField.contains('E_club_Expiration_date__pc')){
                    acc.E_club_Expiration_date__pc = (Date)OldDataWrapper.sobj.get('E_club_Expiration_date__pc');
                }
                if(listField.contains('E_Club_Status__c')){
                    acc.E_Club_Status__c = (String)OldDataWrapper.sobj.get('E_Club_Status__c');
                }
            }
            
            if(OldDataWrapper.sobj != null){
                
                if(listField.contains('E_club_Expiration_date__pc') && OldDataWrapper.sobj.get('E_club_Expiration_date__pc') != null){
                    acc.E_club_Expiration_date__pc = (Date)OldDataWrapper.sobj.get('E_club_Expiration_date__pc');
                }
                if(listField.contains('E_Club_Status__c') && OldDataWrapper.sobj.get('E_Club_Status__c') != null){
                    acc.E_Club_Status__c = (String)OldDataWrapper.sobj.get('E_Club_Status__c');
                }
            }    
        }
        if(strResponse != null && strResponse != ''){
            
            strResponse = cleanResponse(strResponse);
            AccountResponse responseWrapper = (AccountResponse)JSON.deserialize(strResponse, AccountResponse.class);  
            //Check if error
            if(responseWrapper.UpdateClubRS.Errors != null){
                
                acc.Eclub_change_request__c = 'Error : ' + responseWrapper.UpdateClubRS.Errors.error[0].ShortText + ' ' + String.valueOf(DateTime.now().format());
                
            }
        }
        return acc;
    }
    
    public void actionGoodResponse(String strResponse) {
        strResponse = cleanResponse(strResponse); 
        AccountResponse responseWrap = (AccountResponse)JSON.deserialize(strResponse, AccountResponse.class);        // check for Success
        if(responseWrap.UpdateClubRS.success == null) {
            System.debug('Success');
        }
    }
    
    // request wrappers
    public class BBAccountRequestWrapper{
        public UpdateClubRQ UpdateClubRQ {get;set;}
    }
    public class Headers {
        public String ApiKey {get;set;}
    }
    public class UpdateClubRQ {
        public String ID {get;set;}
        public String Email {get;set;}
        public String Status {get;set;}
        public String ExpirationDate {get;set;}
    }
    // end of request wrappers
    
    // response wrappers
   
    public class AccountResponse{
        public UpdateClientRS UpdateClubRS {get;set;}
        public String TimeStamp {get;set;}
    }
    public class UpdateClientRS {
        public Success Success {get;set;}
        Public String TimeStamp {get;set;}
        Public errors Errors {get;set;}
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
    public class Success {
        
    }
    // end of response wrappers
}