/*******************************************************************************************************************************************************************
*
* -- Date         Name              Version  Remarks
* -- -----------  ----------        -------  ---------------------------------------
* -- 29-May-2019  Consultant TMA    1.0     
* -- 19-MAR-2021  Amira             2.0     CRMSS-1106: Vouchers RI/CL/OC : possibilité de mettre à jour le champs montant de consommation
* -- 01-Apr-2021  Amira             3.0     CRMSS-1124: Vouchers statut 7001 transmis au lieu de "used"
* -- 21-may-2021  Amira             4.0     CRMSS-1155: As a CR user, I want to be able to modify the field "responsability" of a voucher RI
*********************************************************************************************************************************************************************/

public without sharing class BB_VoucherObject extends BB_Object implements BB_Object_Interface,BB_Object_Sync_Interface{
    
    //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - Start
    
    public static string RTID;
    public static string IRRecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
    public static string EClubRecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('Eclub').getRecordTypeId();
        
    //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - End
    
    
    public String initializeRequestEndpoint() {
        
        String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_VoucherEndpoint;
        return endPoint;
    }
    
    public String initializeRequestEndpointUpdate() {
        system.debug('@@@ RTID'+RTID);
        //String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_VoucherEndpointUpdate;
        
        
        //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - Start
        string endpoint;
        
        if(RTID == IRRecordTypeID){
            system.debug('@@@@ in RTIDDD');
           endpoint = Label.BBUS_WebservicesLink + Label.BBUS_RefundVoucherEndpointUpdate;  
        }
        else if(RTID == EClubRecordTypeID){
            
           endpoint = Label.BBUS_WebservicesLink + Label.BBUS_VoucherEndpointUpdate;
        }
        //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - End
        
        return endPoint;
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey, String sfdcId,set<String> setfieldtoInclude,String PageDateKey) {
        system.debug('###cyn sfdcId '+sfdcId);
        
        //String SFID =String.valueOf(sfdcId);
        //SFID = SFID.substring(0,15);
        system.debug('###cyn sfdcId after change'+sfdcId);
        if(setfieldtoInclude == null){
            
            Account accObj = [Select Id, Email__pc, Externalid__c
                              FROM Account
                              WHERE Id =:sfdcId];
            string emailClient = accObj.Email__pc;
            string idClient = accObj.Externalid__c;
            
            BBVoucherRequestWrapper voucherWrapper = new BBVoucherRequestWrapper();
            voucherWrapper.headers = new Headers();
            voucherWrapper.headers.ApiKey = Label.BBUS_VoucherAPIKey;
            voucherWrapper.VoucherRQ = new VoucherInfo();
            voucherWrapper.VoucherRQ.Email = emailClient;
            voucherWrapper.VoucherRQ.IDClient = idClient;
            if(includePaging) {
                voucherWrapper.VoucherRQ.PageItem = Label.BBUS_NumberOfUnits;
                voucherWrapper.VoucherRQ.PageKey = pageKey;
            }
            String strBody = JSON.serialize(voucherWrapper);
            strBody = strBody.replace('"headers":', '"bb:Headers":');
            strBody = strBody.replace('"ApiKey":', '"@ApiKey":');
            strBody = strBody.replace('"VoucherRQ":', '"bb:VoucherRQ":');
            strBody = strBody.replace('"Email":', '"@Email":');
            strBody = strBody.replace('"IDClient":', '"@IDClient":');
            strBody = strBody.replace('"PageItem":', '"@PageItem":');
            strBody = strBody.replace('"PageKey":', '"@PageKey":');
            system.debug('strBody1' + strBody);
            return strBody;
            
        }
        
        else{
            
            Voucher__c vouchObj = [Select Id, Code__c, Statut__c, Externalid__c, RecordtypeId,expireDate__c,Montant_de_Consommation__c,Responsabilite__c
                                   From Voucher__c
                                   Where Externalid__c =: sfdcId];
            
            string GeneratedCode = vouchObj.Code__c;
            string Status = vouchObj.Statut__c;
            if (vouchObj.Statut__c=='7003'){

                status='Cancelled';
            }
            else if (vouchObj.Statut__c==label.Statut7000){

                status=label.Generated;
            }
            else if (vouchObj.Statut__c=='7001'){

                status=label.Used;
            }
            else {

                status=vouchObj.Statut__c;
            }
            String expireDate = String.valueof(vouchObj.expireDate__c);
            String Montant = String.valueof(vouchObj.Montant_de_Consommation__c);
            String Responsibility= String.valueof(vouchObj.Responsabilite__c);

            String strBody;
            
            if(vouchObj.RecordTypeId == EClubRecordTypeID){
                
                VoucherClass voucherWrapper = new VoucherClass();
                voucherWrapper.UpdateVoucherRQ = new UpdateVoucherRQ();
                voucherWrapper.UpdateVoucherRQ.voucherRQS = new VoucherRQS();
                voucherWrapper.UpdateVoucherRQ.voucherRQS.GeneratedCode = GeneratedCode;
                voucherWrapper.UpdateVoucherRQ.voucherRQS.Status = Status;
                voucherWrapper.UpdateVoucherRQ.voucherRQS.ExpireDate = expireDate;
                voucherWrapper.UpdateVoucherRQ.voucherRQS.Amount = Montant;
                voucherWrapper.UpdateVoucherRQ.voucherRQS.Responsability = Responsibility;
                
                
                strBody = JSON.serialize(voucherWrapper);
                strBody = strBody.replace('"UpdateVoucherRQ":', '"bb:UpdateVoucherRQ":');
                strBody = strBody.replace('"VoucherRQS":', '"bb:Voucher":');
                strBody = strBody.replace('"GeneratedCode":', '"@GeneratedCode":');
                strBody = strBody.replace('"Status":', '"@Status":');
                strBody = strBody.replace('"ExpireDate":', '"@ExpireDate":');
                strBody = strBody.replace('"Amount":', '"@Amount":');
                strBody = strBody.replace('"Responsability":', '"@Responsability":');
            }
            else if(vouchObj.RecordTypeId == IRRecordTypeID){
                
                RefundVoucherClass refundVoucherWrapper = new RefundVoucherClass();
                refundVoucherWrapper.UpdateRefundVoucherRQ = new UpdateRefundVoucherRQ();
                refundVoucherWrapper.UpdateRefundVoucherRQ.RefundVoucherRQS = new RefundVoucherRQS();
                refundVoucherWrapper.UpdateRefundVoucherRQ.RefundVoucherRQS.GeneratedCode = GeneratedCode;
                refundVoucherWrapper.UpdateRefundVoucherRQ.RefundVoucherRQS.Status = Status;
                refundVoucherWrapper.UpdateRefundVoucherRQ.RefundVoucherRQS.ExpireDate = expireDate;
                refundVoucherWrapper.UpdateRefundVoucherRQ.RefundVoucherRQS.Amount = Montant;
                refundVoucherWrapper.UpdateRefundVoucherRQ.RefundVoucherRQS.Responsability = Responsibility;
                
                
                strBody = JSON.serialize(refundVoucherWrapper);
                strBody = strBody.replace('"UpdateRefundVoucherRQ":', '"bb:UpdateRefundVoucherRQ":');
                strBody = strBody.replace('"RefundVoucherRQS":', '"bb:Voucher":');
                strBody = strBody.replace('"GeneratedCode":', '"@GeneratedCode":');
                strBody = strBody.replace('"Status":', '"@Status":');
                strBody = strBody.replace('"ExpireDate":', '"@ExpireDate":');
                strBody = strBody.replace('"Amount":', '"@Amount":');
                strBody = strBody.replace('"Responsability":', '"@Responsability":');
                
            }
            system.debug('strBody2' + strBody);
            return strBody;
            
        }
    }
    
    public DataTableWrapper createTableFromResponse(String strResponse) {
        
        DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
        
        //if(RTID == EClubRecordTypeID){
            
            BBVoucherResponseWrapper responseWrapper = (BBVoucherResponseWrapper)JSON.deserialize(strResponse, BBVoucherResponseWrapper.class);
            // check for Success
            if(responseWrapper.VoucherRS.Voucher == null  || responseWrapper.VoucherRS.PageKey == null) {
                tableWrapper.pageKey = null;
            }
            else {
                tableWrapper.pageKey = responseWrapper.VoucherRS.PageKey;
            }
            // start creating the table
            // fill list of headers
            tableWrapper.listHeaders = fillListHeaders();
            
            // fill records
            Set<String> setBookingIds = new Set<String>();
            for(Voucher voucher : responseWrapper.VoucherRS.Voucher) {
                if(voucher.IDBooking != null) {
                    setBookingIds.add(voucher.IDBooking);
                }
            }
            Map<String, String> mapBookings = new Map<String, String>();
            
            if(setBookingIds != null && setBookingIds.size()>0){
                
                for(Opportunity booking :[SELECT Id, ExternalId__c
                                          FROM Opportunity
                                          WHERE ExternalId__c IN :setBookingIds
                                         ] ) {
                                             mapBookings.put(booking.ExternalId__c, booking.Id);
                                         }
            }
            
            tableWrapper.listRecords = new List<DataTableWrapper.TableRecord>();
            DataTableWrapper.TableRecord record = new DataTableWrapper.TableRecord();
            List<DataTableWrapper.TableField> listFields = null;
            Date generatedDate;
            String strVoucherDate;
            String bookingId;
            for(Voucher voucher : responseWrapper.VoucherRS.Voucher) {
                record = new DataTableWrapper.TableRecord();
                bookingId = null;
                generatedDate = null;
                listFields = new List<DataTableWrapper.TableField>();
                if(voucher.GeneratedDate != null) {
                    generatedDate = Date.valueOf(voucher.GeneratedDate);
                    if(generatedDate != null) {
                        strVoucherDate = generatedDate.format();
                    }
                }
                listFields.add(new DataTableWrapper.TableField(strVoucherDate, null, null));
                listFields.add(new DataTableWrapper.TableField(voucher.Points, null, null));
                listFields.add(new DataTableWrapper.TableField(voucher.IDVoucher, null, null));
                listFields.add(new DataTableWrapper.TableField(voucher.Type, null, null));
                if(voucher.IDBooking != null && mapBookings.containsKey(voucher.IDBooking)) {
                    bookingId = mapBookings.get(voucher.IDBooking);
                }
                listFields.add(new DataTableWrapper.TableField(voucher.IDBooking, 'link', bookingId));
                record.listFields = listFields;
                tableWrapper.listRecords.add(record);
            }
        //}
        
        return tableWrapper;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
        BBVoucherResponseWrapper responseWrapper = (BBVoucherResponseWrapper)JSON.deserialize(strResponse, BBVoucherResponseWrapper.class);
        
        if(errorCode == 400 && responseWrapper.VoucherRS.Errors.Error.size()>0){
            for(Error errorObj : responseWrapper.VoucherRS.Errors.Error){
                if(errorObj.body.contains('Email address is invalid')){
                    tableWrapper.errorMessage = 'Email address is empty or invalid.';
                }
                else if(errorObj.body.contains('ID and email dosen\'t match')){
                    tableWrapper.errorMessage = 'ID and email don\'t match.';
                }
            }
        }
        else if(errorCode == 401){
            tableWrapper.errorMessage = 'Contact your Salesforce administrator.';
        }
        return tableWrapper;
    }
    
    private List<String> fillListHeaders() {
        List<String> lstHeaders = new List<String>();
        lstHeaders.add('Date');
        lstHeaders.add('Number of points');
        lstHeaders.add('Voucher Id');
        lstHeaders.add('Voucher Type');
        lstHeaders.add('Booking Id');
        return lstHeaders;
    } 
    
    public Voucher__c actionBadResponse(String strResponse, String sfdcId,set<String> listField) {
        
        String Query = 'Select id,Tech_Last_Data__c,';
        for(String field : listField){
            query = query + field + ',';
        }
        query = query.removeEnd(',');
        query = query + ' from Voucher__c where id = \'' + sfdcId + '\' limit 1';
        
        Voucher__c vouch = Database.query(query);
        
        String oldDataJson = vouch.Tech_Last_Data__c;
        system.debug('oldDataJson ' + oldDataJson);
        AP02_SObject_WS.SerializeObject OldDataWrapper = (AP02_SObject_WS.SerializeObject)JSON.deserialize(oldDataJson, AP02_SObject_WS.SerializeObject.class);
       
        if(listField != null && listField.size()>0){

            if(listField.contains('Statut__c') && OldDataWrapper.sobj != null && OldDataWrapper.sobj.get('Statut__c') != null){
                
                vouch.Statut__c = (String)OldDataWrapper.sobj.get('Statut__c');
            }
            else if(listField.contains('Statut__c') && (OldDataWrapper.sobj == null || OldDataWrapper.sobj.get('Statut__c') == null)){
                
                vouch.Statut__c = (String)OldDataWrapper.sobj.get('Statut__c');
            }
            
        }
        
        //Added by TMA-CG CRMSS-203 20/06/2019 start
        if(strResponse != null && strResponse != ''){
        //Added by TMA-CG CRMSS-203 20/06/2019 end
            
            strResponse = cleanResponse(strResponse);
            system.debug('@@@ strResponse '+strResponse);
            if(RTID == IRRecordTypeID){
                
                BBRefundVoucherResponseWrapper refundResponseWrapper = (BBRefundVoucherResponseWrapper)JSON.deserialize(strResponse, BBRefundVoucherResponseWrapper.class);
                
                //Check if error
                if(refundResponseWrapper.UpdateRefundVoucherRS.Errors != null){
                    
                    vouch.Status_change_request__c = 'Error : ' + refundResponseWrapper.UpdateRefundVoucherRS.Errors.error[0].ShortText + ' ' + String.valueOf(DateTime.now().format());
                    
                }
            }
            else if(RTID == EClubRecordTypeID){
                
                BBVoucherResponseWrapper responseWrapper = (BBVoucherResponseWrapper)JSON.deserialize(strResponse, BBVoucherResponseWrapper.class);
                
                //Check if error
                if(responseWrapper.UpdateVoucherRS.Errors != null){
                    
                    vouch.Status_change_request__c = 'Error : ' + responseWrapper.UpdateVoucherRS.Errors.error[0].ShortText + ' ' + String.valueOf(DateTime.now().format());
                    
                }
            }
        }
        return vouch;
    }
    
    public void actionGoodResponse(String strResponse) {
        
        strResponse = cleanResponse(strResponse); 
        
        if(RTID == IRRecordTypeID){
            
            BBRefundVoucherResponseWrapper refundResponseWrapper = (BBRefundVoucherResponseWrapper)JSON.deserialize(strResponse, BBRefundVoucherResponseWrapper.class);
            
            if(refundResponseWrapper.UpdateRefundVoucherRS.success == null) {
                System.debug('Success');
            }
        }
        else if(RTID == EClubRecordTypeID){
            
            BBVoucherResponseWrapper responseWrap = (BBVoucherResponseWrapper)JSON.deserialize(strResponse, BBVoucherResponseWrapper.class);        
            // check for Success
            if(responseWrap.UpdateVoucherRS.success == null) {
                System.debug('Success');
            }
        }
    }
    
    // request wrappers
    public class BBVoucherRequestWrapper{
        public Headers headers {get;set;}
        public VoucherInfo VoucherRQ {get;set;}
    }
    public class Headers {
        public String ApiKey {get;set;}
    }
    
    public class VoucherInfo {
        public String Email {get;set;}  
        public String IDClient {get;set;}
        public String PageItem {get;set;}
        public String PageKey {get;set;}
    }
    
    // end of request wrappers
    
    // request wrappers - ticket CRMSS-129
    public class VoucherClass {
        public UpdateVoucherRQ UpdateVoucherRQ {get;set;}
    }
    public class UpdateVoucherRQ {
        public VoucherRQS VoucherRQS {get;set;}
    }
    
    public class VoucherRQS {
        public String GeneratedCode {get;set;}
        public String Status {get;set;}
        public String ExpireDate {get;set;}
        public String Amount {get;set;}
        public String Responsability {get;set;}
        
    }
    // end of request wrappers - ticket CRMSS-129
    
    //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - Start
    // request wrappers - ticket CRMSS-423
    
    public class RefundVoucherClass{
       public UpdateRefundVoucherRQ UpdateRefundVoucherRQ {get;set;}
    }
    public class UpdateRefundVoucherRQ {
        public RefundVoucherRQS RefundVoucherRQS {get;set;}
    }
    public class RefundVoucherRQS {
        public String GeneratedCode {get;set;}
        public String Status {get;set;}
        public String ExpireDate {get;set;}
        public String Amount {get;set;}
        public String Responsability {get;set;}
    }
    // end of request wrappers - ticket CRMSS-423
    //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - End
    
    // response wrappers
    
    //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - Start
    // response wrappers - ticket CRMSS-423
    
    public class BBRefundVoucherResponseWrapper {
        public RefundVoucherRS UpdateRefundVoucherRS {get;set;}
        public RefundVoucherRS RefundVoucherRS {get;set;}
    }
     public class RefundVoucherRS {
        public List<RefundVoucher> RefundVoucher {get;set;}
        public Success Success {get;set;}
        public Errors Errors {get;set;}
        public string TimeStamp {get;set;}
        public String PageKey {get;set;}
    }
    public class RefundVoucher {
        public string IDBooking {get;set;}
        public string EmitterContext {get;set;} 
        public string IDClient {get;set;}
        public string IDEmitter {get;set;}
        public String IDVoucher {get;set;}
        public String Type {get;set;}
        public String GeneratedCode {get;set;}
        public String GeneratedDate {get;set;}
        public String Responsability {get;set;}
        public String Status {get;set;}
        public String ExpireDate {get;set;}
        public String Amount {get;set;}
        public Reason Reason {get;set;} 
        public List<RefundVoucherDetail> RefundVoucherDetail {get;set;} 
    }
    public class RefundVoucherDetail {
        public String Country {get;set;}
        public String IDVoucherCountry {get;set;}
        public String ValidityDay {get;set;}
    }
    public class Reason{
        public string Category {get;set;} 
        public string Cause {get;set;}
        public string Comment {get;set;}
        public String RefundObject {get;set;}
        public String RefundType {get;set;}
    }
    // end of response wrappers - ticket CRMSS-423
    //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - End
    
    public class BBVoucherResponseWrapper {
        public VoucherRS UpdateVoucherRS {get;set;}
        public VoucherRS VoucherRS {get;set;}
    }
    
    public class VoucherRS {
        public List<Voucher> Voucher {get;set;}
        public Success Success {get;set;}
        public Errors Errors {get;set;}
        public string TimeStamp {get;set;}
        public String PageKey {get;set;}
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
    
    public class Voucher {
        public string IDBooking {get;set;}
        public String IDVoucher {get;set;}
        public String Points {get;set;}
        public String Type {get;set;}
        public String GeneratedCode {get;set;}
        public String GeneratedDate {get;set;}
        public String Status {get;set;}
        public String ExpireDate {get;set;}
        public String Amount {get;set;}
        public String Responsability {get;set;}
        public List<VoucherDetail> VoucherDetail {get;set;} 
    }
    
    public class VoucherDetail {
        public String Country {get;set;}
        public String IDVoucherCountry {get;set;}
        public String MaxDiscount {get;set;}
        public Schedule Schedule {get;set;}
        public List<Prestations> Prestations {get;set;}
    }
    
    public class Schedule {
        public String Monday {get;set;}
        public String Tuesday {get;set;}
        public String Wednesday {get;set;}
        public String Thursday {get;set;}
        public String Friday {get;set;}
        public String Saturday {get;set;}
        public String Sunday {get;set;}
        public String ObservanceDay {get;set;}
        public String Holiday {get;set;}
    }
    
    public class Prestations {
        public String Code {get;set;}
        public String Quantity {get;set;}
    }
    public class Success {
        
    }
    // end of response wrappers
    
}