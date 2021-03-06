public without sharing class BB_BookingObject extends BB_Object implements BB_Object_Interface{
    
    public String initializeRequestEndpointUpdate() {
        //String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_BookingEndpoint;
        //return endPoint;
        return null;
    }
    
     public String initializeRequestEndpoint() {
        String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_BookingEndpoint;
        return endPoint;
        
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey, Id sfdcId,set<String> setfieldtoInclude, String PageDateKey){
        Opportunity oppObj = [Select Id, Externalid__c, RecordType.Name
                              FROM Opportunity
                              WHERE Id =:sfdcId];
        string typeOpp = '';
        if(oppObj.RecordType.Name == 'Booking'){
            typeOpp = '14';
        }
        else if(oppObj.RecordType.Name == 'Master Booking'){
            typeOpp = '34';
        }
        string resValue = oppObj.Externalid__c;
        
        // HotelReservationIDObj.ResID_Type = '14';
        //HotelReservationIDObj.ResID_Value = '494324';
        BBVoucherRequestWrapper bookingWrapper = new BBVoucherRequestWrapper();
        bookingWrapper.headers = new Headers();
        bookingWrapper.headers.ApiKey = Label.BBUS_BookingAPIKey;
        bookingWrapper.GetBooking = new BookingInfo();
        bookingWrapper.GetBooking.HotelReservations = new HotelReservations();
        bookingWrapper.GetBooking.HotelReservations.HotelReservation = new List<HotelReservation>();
        HotelReservation HotelReservationObj = new HotelReservation();
        HotelReservationObj.ResGlobalInfo = new ResGlobalInfo();
        HotelReservationObj.ResGlobalInfo.HotelReservationIDs = new HotelReservationIDs();
        HotelReservationObj.ResGlobalInfo.HotelReservationIDs.HotelReservationID = new List<HotelReservationID>();
        HotelReservationID HotelReservationIDObj = new HotelReservationID();
        HotelReservationIDObj.ResID_Type = typeOpp;
        HotelReservationIDObj.ResID_Value = resValue;
        HotelReservationObj.ResGlobalInfo.HotelReservationIDs.HotelReservationID.add(HotelReservationIDObj);
        bookingWrapper.GetBooking.HotelReservations.HotelReservation.add(HotelReservationObj);
        bookingWrapper.GetBooking.Version = '1';
        String strBody = JSON.serialize(bookingWrapper);
        strBody = strBody.replace('headers', 'bb:Headers');
        strBody = strBody.replace('ApiKey', '@ApiKey');
        strBody = strBody.replace('GetBooking', 'bb:GetBooking');
        strBody = strBody.replace('HotelReservation', 'bb:HotelReservation');
        strBody = strBody.replace('ResGlobalInfo', 'bb:ResGlobalInfo');
        strBody = strBody.replace('ResID_Type', '@ResID_Type');
        strBody = strBody.replace('ResID_Value', '@ResID_Value');
        strBody = strBody.replace('Version', '@Version');
        return strBody;
    }
    
    public DataTableWrapper createTableFromResponse(String strResponse) {
        DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
        system.debug('###strResponse ' + strResponse);
        BBBookingResponseWrapper responseWrapper = (BBBookingResponseWrapper)JSON.deserialize(strResponse, BBBookingResponseWrapper.class);
        system.debug('deserialize done');
        // check for Success
        
        if(responseWrapper.GetBookingRS.Warnings == null){
            // start creating the table
            // fill list of headers
            tableWrapper.listHeaders = fillListHeaders();
            
            // fill records
            tableWrapper.listRecords = new List<DataTableWrapper.TableRecord>();
            DataTableWrapper.TableRecord record = new DataTableWrapper.TableRecord();
            List<DataTableWrapper.TableField> listFields = null;
            Date statusDate;
            String strStatusDate;
            for(HotelReservationResponse hotelReservation : responseWrapper.GetBookingRS.HotelReservations.HotelReservation){
                for(ListBookingStatuts bookingStatus : hotelReservation.TPA_Extensions.ListBookingStatuts) {
                    record = new DataTableWrapper.TableRecord();
                    statusDate = null;
                    listFields = new List<DataTableWrapper.TableField>();
                    if(bookingStatus.Status_Date != null) {
                        statusDate = Date.valueOf(bookingStatus.Status_Date);
                        if(statusDate != null) {
                            strStatusDate = statusDate.format();
                        }
                    }
                    listFields.add(new DataTableWrapper.TableField(strStatusDate, null, null));
                    listFields.add(new DataTableWrapper.TableField(bookingStatus.E_Num_Channel, null, null));
                    listFields.add(new DataTableWrapper.TableField(bookingStatus.Enum_Status, null, null));
                    listFields.add(new DataTableWrapper.TableField(bookingStatus.Description, null, null));
                    record.listFields = listFields;
                    tableWrapper.listRecords.add(record);
                }
            }
        }
        else {
            if(responseWrapper.GetBookingRS.Warnings.Warning.size()>0){
                for(Warning errorObj : responseWrapper.GetBookingRS.Warnings.Warning){
                    if(errorObj.body.contains('No results for this request.')){
                        tableWrapper.errorMessage = 'No results for this request.';
                    }
                }
            }
        }
        return tableWrapper;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        DataTableWrapper tableWrapper = new DataTableWrapper();
        strResponse = cleanResponse(strResponse);
        BBBookingResponseWrapper responseWrapper = (BBBookingResponseWrapper)JSON.deserialize(strResponse, BBBookingResponseWrapper.class);
        system.debug('wrapper: ' + responseWrapper);
        
        if(errorCode == 400 && responseWrapper.GetBookingRS.Errors.Error.size()>0){
            for(Error errorObj : responseWrapper.GetBookingRS.Errors.Error){
                if(errorObj.body.contains('Booking reference invalid')){
                    tableWrapper.errorMessage = 'Booking reference invalid.';
                }
                else if(errorObj.body.contains('Value does not match pattern(s)')){
                    tableWrapper.errorMessage = 'Value does not match pattern(s).';
                }
                else if(errorObj.body.contains('Value is shorter than minimum length')){
                    tableWrapper.errorMessage = 'Value is shorter than minimum length.';
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
        lstHeaders.add('Channel');
        lstHeaders.add('Status');
        lstHeaders.add('Description');
        return lstHeaders;
    } 
    
    // request wrappers
    public class BBVoucherRequestWrapper{
        public Headers headers {get;set;}
        public BookingInfo GetBooking {get;set;}
    }
    public class Headers {
        public String ApiKey {get;set;}
    }
    
    public class BookingInfo {
        public HotelReservations HotelReservations {get;set;}
        public String Version {get;set;}
    }
    
    public class HotelReservations {
        public List<HotelReservation> HotelReservation {get;set;}
    }
    
    public class HotelReservation {
        public ResGlobalInfo ResGlobalInfo {get;set;}
    }
    
    public class ResGlobalInfo {
        public HotelReservationIDs HotelReservationIDs {get;set;}
    }
    
    public class HotelReservationIDs {
        public List<HotelReservationID> HotelReservationID {get;set;}
    }
    
    public class HotelReservationID {
        public string ResID_Type {get;set;}
        public string ResID_Value {get;set;}
    }
    // end of request wrappers
    
    // response wrappers
    public class BBBookingResponseWrapper {
        public GetBookingRS GetBookingRS {get;set;}
    }
    
    public class GetBookingRS {
        public String PrimaryLangID {get;set;}
        public Success Success {get;set;}
        public Errors Errors {get;set;}
        public Warnings Warnings {get;set;}
        public string TimeStamp {get;set;}
        public HotelReservationsResponse HotelReservations {get;set;}
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
    
    public class Warnings {
        public List<Warning> Warning {get;set;}
    }
    
    public class Warning {
        public string body {get;set;}
    }
    
    public class HotelReservationsResponse{
        public List<HotelReservationResponse> HotelReservation {get;set;}
    }
    
    public class HotelReservationResponse {
        public String CreateDateTime {get;set;}
        public String ResStatus {get;set;}
        public POS POS {get;set;}
        public List<UniqueID> UniqueID {get;set;}
        public RoomStays RoomStays {get;set;}
        public ResGuests ResGuests {get;set;}
        public ResGlobalInfoResponse ResGlobalInfo {get;set;}
        public TPA_Extensions TPA_Extensions {get;set;}
    }
    
    public class POS {
        public List<Source> Source {get;set;}
    }
    
    public class Source {
        public RequestorID RequestorID {get;set;}
        public BookingChannel BookingChannel {get;set;}
    }
    
    public class RequestorID {
        public CompanyName CompanyName {get;set;}
    }
    
    public class CompanyName {
        public String CompanyShortName {get;set;}
        public String Code {get;set;}
        public String CodeContext {get;set;}
        public string body {get;set;}
    }
    
    public class BookingChannel {
        public String Type {get;set;}
        public CompanyName CompanyName {get;set;}
    }
    
    public class UniqueID {
        public String ID {get;set;}
        public String Type {get;set;}
    }
    
    public class RoomStays {
        public List<RoomStay> RoomStay {get;set;}
    }
    
    public class RoomStay {
        public RoomTypes RoomTypes {get;set;}
        public RatePlans RatePlans {get;set;}
        public RoomRates RoomRates {get;set;}
        public GuestCounts GuestCounts {get;set;}
        public DepositPayments DepositPayments {get;set;}
        public CancelPenalties CancelPenalties {get;set;}
        public Discount Discount {get;set;}
        public Total Total {get;set;}
        public BasicPropertyInfo BasicPropertyInfo {get;set;}
        public TPA_Extensions TPA_Extensions {get;set;}
        public ResGuestRPHs ResGuestRPHs {get;set;}
        public BookingRules BookingRules {get;set;}
    }
    
    public class RoomTypes {
        public List<RoomType> RoomType {get;set;}
    }
    
    public class RoomType {
        public String NumberOfUnits {get;set;}
        public String RoomTypeCode {get;set;}
    }
    
    public class RatePlans {
        public List<RatePlan> RatePlan {get;set;}
    }
    
    public class RatePlan {
        public String RatePlanCode {get;set;}
    }
    
    public class RoomRates {
        public List<RoomRate> RoomRate {get;set;}
    }
    
    public class RoomRate {
        public String EffectiveDate {get;set;}
        public String ExpireDate {get;set;}
        public String RatePlanCode {get;set;}
        public Rates Rates {get;set;}
    }
    
    public class Rates {
        public List<Rate> Rate {get;set;}
    }
    
    public class Rate {
        public String EffectiveDate {get;set;}
        public String ExpireDate {get;set;}
        public Base Base {get;set;}
        public Total Total {get;set;}
    }
    
    public class Base {
        public String AmountAfterTax {get;set;}
        public String CurrencyCode {get;set;}
        public Taxes Taxes {get;set;}
    }
    
    public class Taxes {
        public String Amount {get;set;}
        public String CurrencyCode {get;set;}
        public List<Tax> Tax {get;set;}
    }
    
    public class Tax {
        public String Type {get;set;}
        public String Code {get;set;}
        public String Amount {get;set;}
        public String CurrencyCode {get;set;}
    }
    
    public class Total {
        public String AmountAfterTax {get;set;}
        public String CurrencyCode {get;set;}
        public string AmountIncludingMarkup {get;set;}
        public Taxes Taxes {get;set;}
    }
    
    public class GuestCounts {
        public List<GuestCount> GuestCount {get;set;}
    }
    
    public class GuestCount {
        public String AgeQualifyingCode {get;set;}
        public String Count {get;set;}
    }
    
    public class DepositPayments {
        public List<GuaranteePayment> GuaranteePayment {get;set;}
    }
    
    public class GuaranteePayment {
        public AcceptedPayments AcceptedPayments {get;set;}
        public AmountPercent AmountPercent {get;set;}
        public String PaymentCode {get;set;}
        public string GuaranteeType {get;set;}
        public string PolicyCode {get;set;}
    }
    public class AmountPercent {
        public string Percent {get;set;}
    }
    
    public class AcceptedPayments {
        public List<AcceptedPayment> AcceptedPayment {get;set;}
    }
    
    public class AcceptedPayment {
        public PaymentCard PaymentCard {get;set;}
    }
    
    public class PaymentCard {
        public String MaskedCardNumber {get;set;}
        public String CompanyCardReference {get;set;}
        public String Remark {get;set;}
        public String EncryptionKey {get;set;}
        public String CardHolderName {get;set;}
        public CardIssuerName CardIssuerName {get;set;}
        public List<CustLoyalty> CustLoyalty {get;set;}
    }
    
    public class CardIssuerName {
        public String BankID {get;set;}
    }
    
    public class CustLoyalty {
        public String LoyalLevel {get;set;}
        public String LoyalLevelCode {get;set;}
        public String EffectiveDate {get;set;}
        public String VendorCode {get;set;}
        public String CustomerValue {get;set;}
    }
    
    public class CancelPenalties {
        public List<CancelPenalty> CancelPenalty {get;set;}
    }
    
    public class CancelPenalty {
        public String ConfirmClassCode {get;set;}
    }
    
    public class Discount {
        public String AmountBeforeTax {get;set;}
        public String AmountAfterTax {get;set;}
        public String CurrencyCode {get;set;}
        public String Percent {get;set;}
        public DiscountReason DiscountReason {get;set;}
    }
    
    public class DiscountReason {
        public String Name {get;set;}
    }
    
    public class BasicPropertyInfo {
        public String HotelCode {get;set;}
    }
    
    public class TPA_Extensions {
        public List<ListBookingStatuts> ListBookingStatuts {get;set;}
        public UniqueID UniqueID {get;set;}
        public string Is_Rate_Included {get;set;}
    }
    
    public class ListBookingStatuts {
        public String Description {get;set;}
        public String E_Num_Channel {get;set;}
        public String Enum_Status {get;set;}
        public String ID {get;set;}
        public String Status_Date {get;set;}
    }
    
    public class ResGuestRPHs {
        public List<ResGuestRPH> ResGuestRPH {get;set;}
    }
    
    public class ResGuestRPH {
        public String RPH {get;set;}
    }
    
    public class BookingRules {
        public List<BookingRule> BookingRule {get;set;}
    }
    
    public class BookingRule {
        public AddtionalRules AddtionalRules {get;set;}
        public String Code {get;set;}
        public String CodeContext {get;set;}
    }
    public class AddtionalRules {
        public List<AdditionalRule> AdditionalRule {get;set;}
    }
    public class AdditionalRule {
        public string AdditionalRule {get;set;}
    }
    
    public class ResGuests {
        public List<ResGuest> ResGuest {get;set;}
    }
    
    public class ResGuest {
        public String ResGuestRPH {get;set;}
        public String AgeQualifyingCode {get;set;}
        public Profiles Profiles {get;set;}
    }
    
    public class Profiles {
        public List<ProfileInfo> ProfileInfo {get;set;}
    }
    
    public class ProfileInfo {
        public Profile Profile {get;set;}
    }
    
    public class Profile {
        public Customer Customer {get;set;}
        public List<UserID> UserID {get;set;}
    }
    
    public class Customer {
        public List<PersonName> PersonName {get;set;}
        public List<Telephone> Telephone {get;set;}
        public List<Email> Email {get;set;}
    }
    
    public class PersonName {
        public List<String> GivenName {get;set;}
        public String Surname {get;set;}
    }
    
    public class Telephone {
        public String PhoneLocationType {get;set;}
        public String PhoneNumber {get;set;}
        public string RPH {get;set;}
    }
    
    public class Email {
        public String body {get;set;}
        public string RPH {get;set;}
    }
    
    public class UserID {
        public String ID {get;set;}
    }
    
    public class ResGlobalInfoResponse{
        public GuestCounts GuestCounts {get;set;}
        public TimeSpan TimeSpan {get;set;}
        public Comments Comments {get;set;}
        public DepositPayments DepositPayments {get;set;}
        public Total Total {get;set;}
        public HotelReservationIDs HotelReservationIDs {get;set;}
        public Profiles Profiles {get;set;}
        public BookingRules BookingRules {get;set;}
    }
    
    public class TimeSpan {
        public String Start {get;set;}
        public String Duration {get;set;}
        public String EndTime {get;set;}
    }
    
    public class Comments {
        public List<Comment> Comment {get;set;}
    }
    
    public class Comment {
        public List<Text> Text {get;set;}
    }
    
    public class Text {
        public string body {get;set;}
    }
    // end of response wrappers
    
}