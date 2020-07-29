/*
* Description: Manager class for BBUS webservices to get data history information 
* @author: Georges Hobeika
* @date: 21/02/2019
* @Test class: BBUS_DataHistoryManager_Test
*/
public without sharing class BBUS_DataHistoryManager {
 
    public static DataTableWrapper callBBUSWebservice(String objectName, boolean includePaging, String pageKey, Id sfdcId,Set<String> fieldToInclude,String PageDateKey) {
        DataTableWrapper retWrapper = null;
        BB_Object_Interface objectWrapper = null;
        switch on objectName {
            when 'wallet' {
                objectWrapper = new BB_WalletObject();
            }
            when 'voucher' {
                objectWrapper = new BB_VoucherObject();
            }
            when 'booking' {
                objectWrapper = new BB_BookingObject();
            }
            when 'payment'{
                objectWrapper = new BB_PaymentObject();
            }
            //Added by TMA-EIL CG CRMSS-430 18-02/2020 Start
            when 'contract'{
                objectWrapper = new BB_ContractObject();
            }
            //Added by TMA-EIL CG CRMSS-430 18-02/2020 End
        }
        String strEndPoint = null;
        String strBody = null;
        String strMethod = null;
        Map<String, String> mapHeaders = null;
        system.debug('### ' + objectWrapper);
        if(objectWrapper != null) {
            strEndPoint = objectWrapper.initializeRequestEndpoint();
            strBody = objectWrapper.initializeRequestBody(includePaging, pageKey, sfdcId,fieldToInclude,pageDateKey);
            strMethod = objectWrapper.initializeRequestMethod();
            mapHeaders = objectWrapper.initializeRequestHeader();
        }
        
        system.debug('BODY: ' + strBody);
        HttpResponse response = doHttpCallout(strEndPoint, strMethod, strBody, mapHeaders);
        system.debug('@@@ HTTP RESP '+response);
        String strResponse = response.getBody();
        if(response.getStatusCode() == 200) {
			retWrapper = objectWrapper.createTableFromResponse(strResponse);
        }
        else if(response.getStatusCode() != 200){
            retWrapper = objectWrapper.createTableFromBadResponse(strResponse, response.getStatusCode());
        }
        return retWrapper;
        //return null;
    }
    
    public static HttpResponse doHttpCallout(string strEndpoint, string strMethod, string strBody, Map<String, String> mapRequestHeaders){ //private
        system.debug('### cg strEndpoint'+strEndpoint);
        HttpRequest req = new HttpRequest();
        HttpResponse retVal = new HttpResponse();            
        Http http = new Http();
        
        req.setEndpoint(strEndpoint);
        req.setMethod(strMethod);
        req.setBody(strBody);
        for(String headerKey : mapRequestHeaders.keySet()) {
            req.setHeader(headerKey,mapRequestHeaders.get(headerKey));
        }
        try{
            retVal = http.send(req);
            return retVal;
        }
        catch(system.CalloutException e){
            system.debug('Callout error: ' + e);
            system.debug(retVal.toString());
            return retVal;
        }
    }
    
    //Method Added BY TMA-EI JK CRMSS-96 to perform the WS callout without the action on the response
    public static HttpResponse callBBUSWebserviceResponse(String objectName, boolean includePaging, String pageKey, String sfdcId,Set<String> fieldToInclude) {
        System.debug('Calling WS');
        Log__c log = new Log__c();
        BB_Object_Interface objectWrapper = null;
        switch on objectName {
            when 'wallet' {
                objectWrapper = new BB_WalletObject();
                log.WSName__c = 'Wallet Synchronisation';
            }
            when 'voucher' {
                objectWrapper = new BB_VoucherObject();
                log.WSName__c = 'Voucher Synchronisation';
            }
            when 'booking' {
                objectWrapper = new BB_BookingObject();
                log.WSName__c = 'Booking Synchronisation';
            }
            when 'payment'{
                objectWrapper = new BB_PaymentObject();
                log.WSName__c = 'Payment Synchronisation';
            }
            when 'Account'{
                objectWrapper = new BB_AccountObject();
                log.WSName__c = 'Account Synchronisation';
            }
            when 'AccountEClub'{
                objectWrapper = new BB_AccountObjectEClub();
                log.WSName__c = 'Account EClub Synchronisation';
            }
            when 'AccountPoints'{
                objectWrapper = new BB_AccountObjectPoints();
                log.WSName__c = 'Account Points Synchronisation';
            }
            //Added by TMA-EIL CG CRMSS-430 18-02/2020 Start
            when 'contract'{
                objectWrapper = new BB_ContractObject();system.debug('### ### objectWrapper 1'+objectWrapper);
                log.WSName__c = 'Contract Link Generation';
            }
            //Added by TMA-EIL CG CRMSS-430 18-02/2020 End
        }
        String strEndPoint = null;
        String strBody = null;
        String strMethod = null;
        Map<String, String> mapHeaders = null;
        if(objectWrapper != null) {system.debug('### ### objectWrapper != null');
            strEndPoint = objectWrapper.initializeRequestEndpointUpdate();
            strBody = objectWrapper.initializeRequestBody(includePaging, pageKey, sfdcId,fieldToInclude,null);system.debug('### ### strBody'+strBody);
            strMethod = objectWrapper.initializeRequestMethod();
            mapHeaders = objectWrapper.initializeRequestHeader();system.debug('### ### objectWrapper 2'+objectWrapper);
        }
        log.JsonMessage__c = strBody;
        log.ExternalID__c = sfdcId;system.debug('### cg sfdcId'+sfdcId);
        log.FromSalesforce__c = true;
        HttpResponse response = doHttpCallout(strEndPoint, strMethod, strBody, mapHeaders);
        system.debug('@@@@ responsee BBUS DATAH'+response);
        insert log;
        return response;
        //return null;
    }
    
}