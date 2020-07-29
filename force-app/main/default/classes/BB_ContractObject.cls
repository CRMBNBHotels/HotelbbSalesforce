/* Description: This class is used fro the WS of CRMSS-430
* @author: TMA-EIL JKA
* @date: 17-02-2020
* @Test: 
* @Coverage: 
*/

public without sharing class BB_ContractObject extends BB_Object implements BB_Object_Interface,BB_Object_Sync_Interface{
    
    public String initializeRequestEndpoint() {
        return null;
    }
    
    public String initializeRequestEndpointUpdate() {
        String endPoint = Label.BBUS_WebservicesLink + Label.BB_ContractObject_Endpoint;
        return endPoint;
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey, String sfdcId,set<String> setfieldtoInclude, String PageDateKey) {
        
        Contract cont = [select id, AccountId, Loge_Card_Expiration_date__c, BillingCountryCode, Externalid__c, account.Externalid__c  from Contract where Externalid__c=:sfdcId];
        
        // Create a JSONGenerator object
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeFieldName('paymentLinkRQ');
        gen.writeStartObject();
        gen.writeStringField('crmCompanyID', cont.account.Externalid__c);
        
        if(cont.Loge_Card_Expiration_date__c != null){
            
            gen.writeDateField('expirateAt', cont.Loge_Card_Expiration_date__c);
        }
        if(cont.BillingCountryCode != null && cont.BillingCountryCode != ''){
            
            gen.writeStringField('countryCode',cont.BillingCountryCode);
        }
        
        gen.writeEndObject();  
        gen.writeEndObject(); 
        System.debug('### ### ' + gen.getAsString()); 

        return gen.getAsString();
        
    }
    
    
    public DataTableWrapper createTableFromResponse(String strResponse) {
        
        return null;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        
        return null;
    }
    
    public Contract actionBadResponse(String strResponse, String sfdcId,set<String> listField){
        
        return null;
    }
    
    public void actionGoodResponse(String strResponse){
        
    }
}