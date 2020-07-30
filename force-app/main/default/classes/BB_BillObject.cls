/*
* Description: Webservice bill download initliase endpoint body and action on response
* @author: TMA-EI JK
* @date: 06/04/2020
* @Test class: BB_BillObject_test
* @Coverage: 82 %
*/
public without sharing class BB_BillObject extends BB_Object implements BB_Object_Interface{
    
    /**************************************************************************************************************************************************************************************************/
    /****************************************************************************Initialize the endpoint***********************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public String initializeRequestEndpoint() {
        String endPoint = Label.BBUS_WebservicesLink + Label.bb_BillDownload;
        return endPoint;
    }
    
    
    /**************************************************************************************************************************************************************************************************/
    /********************************************************************This class is in the inteface and should be overridden************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public String initializeRequestEndpointUpdate() {  
        return null;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /****************************************************************************Create the body of the request****************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public String initializeRequestBody(boolean includePaging, String pageKey, String sfdcId,set<String> setfieldtoInclude,String PageDateKey) {
        system.debug('initializeRequestBody');
        Account accObj = [Select Id, Email__pc, Externalid__c
                          FROM Account
                          WHERE Id =:sfdcId];
        string emailClient = accObj.Email__pc;
        string idClient = accObj.Externalid__c;
        
        // Create a JSONGenerator object
        JSONGenerator gen = JSON.createGenerator(true);
        
        if(idClient == null)
            idClient ='';
        if(emailClient == null)
            emailClient ='';
        
        gen.writeStartObject();
        gen.writeFieldName('bb:BillDownloadRQ');
        gen.writeStartObject();
        gen.writeStringField('@IDAccount', idClient);
        gen.writeStringField('@Email', emailClient);
        /*gen.writeFieldName('bb:Pagination');
		gen.writeStartObject();
		gen.writeStringField('@Limit', Label.BBUS_NumberOfUnits);
		gen.writeEndObject();*/
        gen.writeEndObject();  
        gen.writeEndObject(); 
        System.debug('### ### ' + gen.getAsString()); 
        
        return gen.getAsString();
    }
    
    /**************************************************************************************************************************************************************************************************/
    /******************************************************************************Action to do on good response***************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public DataTableWrapper createTableFromResponse(String strResponse) {
        system.debug('Good response');
        DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
        strResponse = strResponse.replace('Currency', 'curr');
        system.debug('strResponse modified ' + strResponse);
        BBBillDownloadRS responseWrapper = (BBBillDownloadRS)JSON.deserialize(strResponse, BBBillDownloadRS.class);
         system.debug('responseWrapper modified ' + responseWrapper);
        tableWrapper.listHeaders = fillListHeaders();
        tableWrapper.listRecords = new List<DataTableWrapper.TableRecord>();
        DataTableWrapper.TableRecord record = new DataTableWrapper.TableRecord();
        List<DataTableWrapper.TableField> listFields = null;
        Date generatedDate;
        String strVoucherDate;
        String bookingId;
        for(BillDownload bill : responseWrapper.BillDownloadRS.BillDownload) {
            record = new DataTableWrapper.TableRecord();
            bookingId = null;
            generatedDate = null;
            listFields = new List<DataTableWrapper.TableField>();
            listFields.add(new DataTableWrapper.TableField(bill.type, null, null));
            listFields.add(new DataTableWrapper.TableField(bill.Amount, null, null));
            listFields.add(new DataTableWrapper.TableField(bill.EmissionDate, null, null));
            listFields.add(new DataTableWrapper.TableField(bill.Link, 'link', null));
            record.listFields = listFields;
            tableWrapper.listRecords.add(record);    
        }
        system.debug('tableWrapper' + tableWrapper);
        return tableWrapper;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /******************************************************************************Action to do on bad response****************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        
         DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
         system.debug('strResponse modified ' + strResponse);
        BBBillDownloadRS responseWrapper = (BBBillDownloadRS)JSON.deserialize(strResponse, BBBillDownloadRS.class);
        if(errorCode == 400 &&  responseWrapper.BillDownloadRS != null &&  responseWrapper.BillDownloadRS.Errors != null &&
           responseWrapper.BillDownloadRS.Errors.Error != null && responseWrapper.BillDownloadRS.Errors.Error.size()>0){
            for(Error errorObj : responseWrapper.BillDownloadRS.Errors.Error){
                if(errorObj.body.contains('ID and email don\'t match')){
                    tableWrapper.errorMessage = 'ID and email don\'t match';
                }
                else {
                    tableWrapper.errorMessage = errorObj.body;
                }
            }
        }
        else if(errorCode == 401){
            tableWrapper.errorMessage = 'Contact your Salesforce administrator.';
        }
        return tableWrapper;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /*******************************************************Create the header of the table to be displayed on the lightning component******************************************************************/
    /**************************************************************************************************************************************************************************************************/
    private List<String> fillListHeaders() {
        List<String> lstHeaders = new List<String>();
        lstHeaders.add('Type');
        lstHeaders.add('Amount');
        lstHeaders.add('Date');
        lstHeaders.add('View / Download');
        return lstHeaders;
    } 

    
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************************************Wrapper classes to store the WS response***********************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public class BBBillDownloadRS{
        public BillDownloadRS BillDownloadRS {get;set;}
    }
    public class BillDownloadRS{
        public Success Success {get; set;}
        public Errors Errors {get; set;}
        public string key {get; set;}
        public string TimeStamp {get; set;}
        public string TotalNumberBills  {get; set;}
        public List<BillDownload> BillDownload {get; set;}
    }
    public class Success{
        
    }
    public class Errors{
        public List<Error> Error {get; set;}
    }
    
    public class Error{
        public string body {get; set;}
        public string Type  {get; set;}
        public string ShortText  {get; set;}
        public string Code  {get; set;}
        public string CodeError  {get; set;}
    }
    public class BillDownload{
        public string Amount {get; set;}
        public string curr  {get; set;}
        public string EmissionDate  {get; set;}
        public string Link  {get; set;}
        public string type  {get; set;}
        public string HotelID  {get; set;}
        public string Wording  {get; set;}
    }
        
}