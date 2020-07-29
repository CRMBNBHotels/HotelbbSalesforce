public without sharing class BB_WalletObject extends BB_Object implements BB_Object_Interface{
    
    public String initializeRequestEndpointUpdate() {
        //String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_LoyaltyEndpoint;
        return null;
    }
    
    public String initializeRequestEndpoint() {
        String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_LoyaltyEndpoint;
        return endPoint;
        //return endPoint;
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey,Id sfdcId,set<String> setfieldtoInclude,String PageDateKey) {
        Account accObj = [Select Id, Email__pc, Externalid__c
                          FROM Account
                          WHERE Id =:sfdcId];
        string emailClient = accObj.Email__pc;
        string idClient = accObj.Externalid__c;
        
        BBWalletRequestWrapper walletWrapper = new BBWalletRequestWrapper();
        walletWrapper.Headers = new Headers();
        walletWrapper.Headers.ApiKey = getApiKey();
        walletWrapper.loyaltyPoint = new LoyaltyPointInfo();
        walletWrapper.loyaltyPoint.Email = emailClient;
        walletWrapper.loyaltyPoint.ID = idClient;
        if(includePaging) {
            walletWrapper.loyaltyPoint.NumberOfUnits = Label.BBUS_NumberOfUnits;
            walletWrapper.loyaltyPoint.PageKey = pageKey;
        }
        String strBody = JSON.serialize(walletWrapper);
        strBody = strBody.replace('headers', 'bb:Headers');
        strBody = strBody.replace('ApiKey', '@ApiKey');
        strBody = strBody.replace('loyaltyPoint', 'bb:LoyaltyPoint');
        strBody = strBody.replace('Email', '@Email');
        strBody = strBody.replace('ID', '@ID');
        strBody = strBody.replace('NumberOfUnits', '@NumberOfUnits');
        strBody = strBody.replace('PageKey', '@PageKey');
        return strBody;
    }
    
    public DataTableWrapper createTableFromResponse(String strResponse) {
        DataTableWrapper tableWrapper = new DataTableWrapper();
        
        strResponse = cleanResponse(strResponse);
        
        //Added by TMA Cynthia Geagea - CRMSS 229 - 17/07/2019 - Start
        strResponse = strResponse.replace('"Date"', '"DateRS"');
        //Added by TMA Cynthia Geagea - CRMSS 229 - 17/07/2019 - End
        
        BBWalletResponseWrapper responseWrapper = (BBWalletResponseWrapper)JSON.deserialize(strResponse, BBWalletResponseWrapper.class);
        if(responseWrapper.LoyaltyPointRS.LoyaltyPoints == null || responseWrapper.LoyaltyPointRS.LoyaltyPoints.PageDateKey == null) {
            tableWrapper.pageDateKey = null;
        }
        else {
            tableWrapper.pageDateKey = responseWrapper.LoyaltyPointRS.LoyaltyPoints.PageDateKey;
        }
        if(responseWrapper.LoyaltyPointRS.LoyaltyPoints == null || responseWrapper.LoyaltyPointRS.LoyaltyPoints.PageKey == null) {
            tableWrapper.pageKey = null;
        }
        else {
            tableWrapper.pageKey = responseWrapper.LoyaltyPointRS.LoyaltyPoints.PageKey;
        }
        
        // check for Success
        // start creating the table
        // fill list of headers
        tableWrapper.listHeaders = fillListHeaders();
        // fill records
        Set<String> setBookingIds = new Set<String>();
        Set<String> setHotelIds = new Set<String>();         
        for(LoyaltyPoint loyaltyPoint : responseWrapper.LoyaltyPointRS.LoyaltyPoints.LoyaltyPoint) {
            if(loyaltyPoint.BookingID != null) {
                setBookingIds.add(loyaltyPoint.BookingID);
            }
            if(loyaltyPoint.HotelCode != null) {
                setHotelIds.add(loyaltyPoint.HotelCode);
            }
        }
        Map<String, String> mapBookings = new Map<String, String>();
        for(Opportunity booking :[SELECT Id, ExternalId__c
                                  FROM Opportunity
                                  WHERE ExternalId__c IN :setBookingIds
                                 ] ) {
                                     mapBookings.put(booking.ExternalId__c, booking.Id);
                                 }
        
        Map<String, String> mapHotels = new Map<String, String>();
        for(Hotel__c hotel :[SELECT Id, Hotel_Id__c
                             FROM Hotel__c
                             WHERE Hotel_Id__c IN :setHotelIds
                            ] ) {
                                mapHotels.put(hotel.Hotel_Id__c, hotel.Id);
                            }
        
        tableWrapper.listRecords = new List<DataTableWrapper.TableRecord>();
        DataTableWrapper.TableRecord record = new DataTableWrapper.TableRecord();
        List<DataTableWrapper.TableField> listFields = null;
        String bookingId;
        String hotelId;
        String reason;
        Date endDate;
        String strWalletDate;
        
        for(LoyaltyPoint loyaltyPoint : responseWrapper.LoyaltyPointRS.LoyaltyPoints.LoyaltyPoint) {
            record = new DataTableWrapper.TableRecord();
            bookingId = null;
            hotelId = null;
            endDate = null;
            listFields = new List<DataTableWrapper.TableField>();
            
            /*if(loyaltyPoint.TimeSpan != null && loyaltyPoint.TimeSpan.EndTime != null) {
                endDate = Date.valueOf(loyaltyPoint.TimeSpan.EndTime);
                if(endDate != null) {
                    strWalletDate = endDate.format();
                }
            }*/
            
            //Added by TMA Cynthia Geagea - CRMSS 229 - 17/07/2019 - Start
            if(loyaltyPoint.DateRS != null){
                
               strWalletDate = Date.valueOf(loyaltyPoint.DateRS).format();
            }
            //Added by TMA Cynthia Geagea - CRMSS 229 - 17/07/2019 - End
            
            listFields.add(new DataTableWrapper.TableField(strWalletDate, null, null));
            listFields.add(new DataTableWrapper.TableField(loyaltyPoint.NumberPoint, null, null));
            if(loyaltyPoint.HotelCode != null && mapHotels.containsKey(loyaltyPoint.HotelCode)) {
                hotelId = mapHotels.get(loyaltyPoint.HotelCode);
            }
            if(loyaltyPoint.BookingID != null && mapBookings.containsKey(loyaltyPoint.BookingID)) {
                bookingId = mapBookings.get(loyaltyPoint.BookingID);
            }
            if(loyaltyPoint.Reason != null && mapBookings.containsKey(loyaltyPoint.Reason)) {
                reason = mapBookings.get(loyaltyPoint.Reason);
            }
            //listFields.add(new DataTableWrapper.TableField(loyaltyPoint.HotelCode, 'link', hotelId));
            //listFields.add(new DataTableWrapper.TableField(loyaltyPoint.BookingId, 'link', bookingId));
            listFields.add(new DataTableWrapper.TableField(loyaltyPoint.Reason, null, null));
            record.listFields = listFields;
            tableWrapper.listRecords.add(record);
        }
        
        system.debug('tableWrapper ' + tableWrapper);
        return tableWrapper;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
        BBWalletResponseWrapper responseWrapper = (BBWalletResponseWrapper)JSON.deserialize(strResponse, BBWalletResponseWrapper.class);
        
        if(errorCode == 400 && responseWrapper.LoyaltyPointRS.Errors.Error.size()>0){
            for(Error errorObj : responseWrapper.LoyaltyPointRS.Errors.Error){
                if(errorObj.body.contains('Email empty or invalid')){
                    tableWrapper.errorMessage = 'Email is empty or invalid.';
                }
                else if(errorObj.body.contains('Id Person Account empty or invalid')){
                    tableWrapper.errorMessage = 'Id of Person Account is empty or invalid.';
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
        //lstHeaders.add('Hotel Id');
        //lstHeaders.add('Booking Id');
        lstHeaders.add('Description');
        return lstHeaders;
    } 
    
    // request wrappers
    public class BBWalletRequestWrapper{
        public Headers headers {get;set;}
        public LoyaltyPointInfo loyaltyPoint {get;set;}
    }
    public class Headers {
        public String ApiKey {get;set;}
    }
    
    public class LoyaltyPointInfo {
        public String Email {get;set;}  
        public String ID {get;set;}
        public String NumberOfUnits{get;set;}
        public String PageKey{get;set;}
    }
    // end of request wrappers
    
    // response wrappers
    public class BBWalletResponseWrapper {
        public LoyaltyPointRS LoyaltyPointRS {get;set;}
    }
    
    public class LoyaltyPointRS {
        public Success Success {get;set;}
        public Errors Errors {get;set;}
        public string TimeStamp {get;set;}
        public LoyaltyPoints LoyaltyPoints {get;set;}
    }
    
    public class Success{
        
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
    
    public class LoyaltyPoints{
        public List<LoyaltyPoint> LoyaltyPoint {get;set;}
        public String PageKey {get;set;}   
        public String PageDateKey {get;set;} 
    }
    
    public class LoyaltyPoint {
        public TimeSpan TimeSpan {get;set;}
        public String BookingID {get;set;}  
        public String ReservationID {get;set;}  
        public String HotelCode {get;set;}  
        public String NumberPoint {get;set;}    
        public String CreationDate {get;set;}
        public String Reason {get;set;}
        public String DateRS {get;set;}
    }
    
    public class TimeSpan{
        public String Start {get;set;}  
        public String EndTime {get;set;}
    }
    // end of response wrappers
    
}