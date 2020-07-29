/*
* Description: Class to initialise all info used in the WS and the actions on error/success
* Ticket NB: CRMSS-96
* @author: TMA JK
* @date: 01/05/2019
* @Test class: BB_AccountObject_Test
*/
public class BB_AccountObject extends BB_Object implements BB_Object_Interface,BB_Object_Sync_Interface{
    public String initializeRequestEndpointUpdate() {
        String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_UpdateAccountEndpoint;
        return endPoint;
    }
    
    public String initializeRequestEndpoint() {
        //String endPoint = Label.BBUS_WebservicesLink + Label.BBUS_UpdateAccountEndpoint;
        return null;
        
    }
    
    public String initializeRequestBody(boolean includePaging, String pageKey, String sfdcId,set<String> setfieldtoInclude, String PageDateKey) {
        
        BBAccountRequestWrapper AccountWrapper = new BBAccountRequestWrapper();
        AccountWrapper.headers = new Headers();
        AccountWrapper.headers.ApiKey = Label.BBUS_HeaderAPIKey;
        AccountWrapper.UpdateClient = new UpdateClient();
        AccountWrapper.UpdateClient.version = '1';
        AccountWrapper.UpdateClient.Profile = new Profile();
        AccountWrapper.UpdateClient.Profile.UserID = new List<User>();
        User us = new User();
        AccountWrapper.UpdateClient.Profile.UserID.add(us);
        AccountWrapper.UpdateClient.Profile.UserID[0].ID = sfdcId;
        AccountWrapper.UpdateClient.Profile.Customer = new Customer();
      
        String JsonNotCompleted = JSON.serialize(AccountWrapper);
        String JsonToReturn;

        if(setfieldtoInclude != null && setfieldtoInclude.size()>0){
            JsonToReturn = FillField(JsonNotCompleted, setfieldtoInclude,sfdcId);
        }
        return JsonToReturn;
    }
    
    public String FillField(String JsonObject, Set<String> setfieldtoInclude,String sfdcId) {
       
        String Query = 'Select ';
        for(String field : setfieldtoInclude){
            query = query + field + ',';
        }
        query = query.removeEnd(',');
        query = query + ' from account where externalID__c = \'' + sfdcId + '\' limit 1';
        system.debug('Query ' + query);
        Account acc = Database.query(query);
        BBAccountRequestWrapper AccountWrapper = new BBAccountRequestWrapper();
        System.debug('## befoe account wrapper ' + JsonObject);
        AccountWrapper = (BBAccountRequestWrapper)JSON.deserializeStrict(JsonObject,BBAccountRequestWrapper.Class);
        System.debug('## setfieldtoInclude 1 ' + setfieldtoInclude);
        if(setfieldtoInclude != null && setfieldtoInclude.size()>0){
             System.debug('## place 1');
              if(setfieldtoInclude.contains('PersonMailingCountryCode') || setfieldtoInclude.contains('PersonMailingStreet') || setfieldtoInclude.contains('PersonMailingCity') 
               || setfieldtoInclude.contains('PersonMailingState') || setfieldtoInclude.contains('PersonMailingPostalCode')){
                   AccountWrapper.UpdateClient.Profile.Customer.Address = new List<Address>();
                   Address add = new Address();
                   add.UseType = '1';
                   AccountWrapper.UpdateClient.Profile.Customer.Address.add(add);
                   
                   if(setfieldtoInclude.contains('PersonMailingStreet')){
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].AddressLine = new List<String>();
                       String PersonMailingStreet = acc.PersonMailingStreet;
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].AddressLine.add(PersonMailingStreet);
                   }
                   if(setfieldtoInclude.contains('PersonMailingCity')){
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].CityName = acc.PersonMailingCity;
                   }
                   if(setfieldtoInclude.contains('PersonMailingCountryCode')){
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].CountryName = new CountryName();
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].CountryName.body = acc.PersonMailingCountryCode;
                   }
                  if(setfieldtoInclude.contains('PersonMailingState')){
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].StateProv = new StateProv();
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].StateProv.body = acc.PersonMailingState;
                   }
                   if(setfieldtoInclude.contains('PersonMailingPostalCode')){
                       AccountWrapper.UpdateClient.Profile.Customer.Address[0].PostalCode = acc.PersonMailingPostalCode;
                   }
                   
               }
             System.debug('## place 2');
            if(setfieldtoInclude.contains('email__pc') || setfieldtoInclude.contains('E_mail_address_2__pc')){
                AccountWrapper.UpdateClient.Profile.Customer.Email = new List<Email>();
                if(setfieldtoInclude.contains('email__pc')){
                    Email emailToAdd = new Email();
                    emailToAdd.body = acc.email__pc;
                    emailToAdd.RPH = '1';
                    AccountWrapper.UpdateClient.Profile.Customer.Email.add(emailToAdd);
                }
                if(setfieldtoInclude.contains('E_mail_address_2__pc')){
                    Email emailToAdd = new Email();
                    emailToAdd.body = acc.E_mail_address_2__pc;
                    emailToAdd.RPH = '2';
                    AccountWrapper.UpdateClient.Profile.Customer.Email.add(emailToAdd);
                }
            }
             System.debug('## place 4');
            if(setfieldtoInclude.contains('firstname') || setfieldtoInclude.contains('lastname')){
                AccountWrapper.UpdateClient.Profile.Customer.PersonName = new List<Person>();
                Person ps = new Person();
                AccountWrapper.UpdateClient.Profile.Customer.PersonName.add(ps);
                AccountWrapper.UpdateClient.Profile.Customer.PersonName[0] = new Person();
                if(setfieldtoInclude.contains('firstname')){
                    AccountWrapper.UpdateClient.Profile.Customer.PersonName[0].GivenName = new List<String>();
                    String firstName = acc.firstname;
                    AccountWrapper.UpdateClient.Profile.Customer.PersonName[0].GivenName.add(firstName); 
                }
                if(setfieldtoInclude.contains('lastname')){
                    AccountWrapper.UpdateClient.Profile.Customer.PersonName[0].Surname = acc.lastname;
                }
            }
             System.debug('## place 5');
            if(setfieldtoInclude.contains('PersonMobilePhone') || setfieldtoInclude.contains('Mobile_Phone_Number_2__pc')){
                AccountWrapper.UpdateClient.Profile.Customer.telephon = new List<telephone>();
                if(setfieldtoInclude.contains('PersonMobilePhone')){
                    telephone tel = new telephone();
                    tel.PhoneLocationType = '6';
                    
                    //Added by TMA - Cynthia Geagea - CRMSS 220 - Start
                    if(acc.PersonMobilePhone == null){
                        acc.PersonMobilePhone = '';
                    }
                    //Added by TMA - Cynthia Geagea - CRMSS 220 - End
                    
                    tel.PhoneNumber = acc.PersonMobilePhone;
                    tel.RPH = '1';
                    AccountWrapper.UpdateClient.Profile.Customer.telephon.add(tel);
                }
                if(setfieldtoInclude.contains('Mobile_Phone_Number_2__pc')){
                    telephone tel = new telephone();
                    tel.PhoneLocationType = '6';
                    
                    //Added by TMA - Cynthia Geagea - CRMSS 220 - Start
                    if(acc.Mobile_Phone_Number_2__pc == null){
                        acc.Mobile_Phone_Number_2__pc = '';
                    }
                    //Added by TMA - Cynthia Geagea - CRMSS 220 - End
                    
                    tel.PhoneNumber = acc.Mobile_Phone_Number_2__pc;
                    tel.RPH = '2';
                    AccountWrapper.UpdateClient.Profile.Customer.telephon.add(tel);
                }
                
            }
              
          
            
        }
        System.debug('## place 3s');
        String strBody = JSON.serialize(AccountWrapper,true);
        system.debug('!!!!! Json before replace ' + strBody);
        strBody = strBody.replace('"headers":', '"bb:Headers":');
        strBody = strBody.replace('"ApiKey":', '"@ApiKey":');
        strBody = strBody.replace('"UpdateClient":', '"bb:UpdateClient":');
        strBody = strBody.replace('"Profile":', '"bb:Profile":');
        strBody = strBody.replace('"Customer":', '"bb:Customer":');
        strBody = strBody.replace('"Version":', '"@Version":');
        strBody = strBody.replace('"ID":', '"@ID":');
        strBody = strBody.replace('"UserID":', '"bb:UserID":');
        if(strBody.contains('"PersonName":')){
            strBody = strBody.replace('"PersonName":', '"bb:PersonName":');
        }
        if(strBody.contains('"GivenName":')){
            strBody = strBody.replace('"GivenName":', '"bb:GivenName":');
        }
        if(strBody.contains('"Surname":')){
            strBody = strBody.replace('"Surname":', '"bb:Surname":');
        }
        if(strBody.contains('"telephon":')){
            strBody = strBody.replace('"telephon":', '"bb:Telephone":');
        }
        if(strBody.contains('"PhoneLocationType":')){
            strBody = strBody.replace('"PhoneLocationType":', '"@PhoneLocationType":');
        }
        if(strBody.contains('"PhoneNumber":')){
            strBody = strBody.replace('"PhoneNumber":', '"@PhoneNumber":');
        }
        if(strBody.contains('"Email":')){
            strBody = strBody.replace('"Email":', '"bb:Email":');
        }
        if(strBody.contains('"body":')){
            strBody = strBody.replace('"body":', '"*body":');
        }
        if(strBody.contains('"RPH":')){
            strBody = strBody.replace('"RPH":', '"@RPH":');
        }
        
        if(strBody.contains('"Address":')){
            strBody = strBody.replace('"Address":', '"bb:Address":');
        }
        
        if(strBody.contains('"AddressLine":')){
            strBody = strBody.replace('"AddressLine":', '"bb:AddressLine":');
        }
        
        if(strBody.contains('"UseType":')){
            strBody = strBody.replace('"UseType":', '"@UseType":');
        }
        
        if(strBody.contains('"CityName":')){
            strBody = strBody.replace('"CityName":', '"bb:CityName":');
        }
        if(strBody.contains('"CountryName":')){
            strBody = strBody.replace('"CountryName":', '"bb:CountryName":');
        }
        if(strBody.contains('"StateProv":')){
            strBody = strBody.replace('"StateProv":', '"bb:StateProv":');
        }
        if(strBody.contains('"PostalCode":')){
            strBody = strBody.replace('"PostalCode":', '"bb:PostalCode":');
        }
        system.debug('!!!!! Json after replace ' + strBody);
        return strBody;
    }

    
    public DataTableWrapper createTableFromResponse(String strResponse) {
        return null;
    }
    
    public DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode) {
        return null;
    } 
    
    public Account actionBadResponse(String strResponse, String sfdcId,set<String> listField) {
        String Query = 'Select id,Tech_Data__c,';
        for(String field : listField){
            query = query + field + ',';
        }
        query = query.removeEnd(',');
        query = query + ' from account where id = \'' + sfdcId + '\' limit 1';
        
        Account acc = Database.query(query);
        acc.Syncstatus__c = 'Error : ';
        
        String oldDataJson = acc.Tech_Data__c;
        AP02_SObject_WS.SerializeObject OldDataWrapper = (AP02_SObject_WS.SerializeObject)JSON.deserialize(oldDataJson, AP02_SObject_WS.SerializeObject.class);
   
        if(listField != null && listField.size()>0){
            
            if(OldDataWrapper.sobj == null || OldDataWrapper.sobj.get('email__pc') == null || OldDataWrapper.sobj.get('E_mail_address_2__pc') == null 
               || OldDataWrapper.sobj.get('firstname') == null || OldDataWrapper.sobj.get('lastname') == null || OldDataWrapper.sobj.get('PersonMobilePhone') == null 
               || OldDataWrapper.sobj.get('Mobile_Phone_Number_2__pc') == null || OldDataWrapper.sobj.get('PersonMailingCity') == null 
               || OldDataWrapper.sobj.get('PersonMailingCountry') == null || OldDataWrapper.sobj.get('PersonMailingPostalCode') == null
               || OldDataWrapper.sobj.get('PersonMailingState') == null || OldDataWrapper.sobj.get('PersonMailingStreet') == null){
                   
                   if(listField.contains('email__pc')){
                       acc.Email__pc = (String)OldDataWrapper.sobj.get('email__pc');
                   }
                   if(listField.contains('E_mail_address_2__pc')){
                       acc.E_mail_address_2__pc = (String)OldDataWrapper.sobj.get('E_mail_address_2__pc');
                   }
                   if(listField.contains('firstname')){
                       acc.firstname = (String)OldDataWrapper.sobj.get('firstname');
                   }
                   if(listField.contains('lastname')){
                       acc.lastname =(String) OldDataWrapper.sobj.get('lastname');
                   }
                   
                   if(listField.contains('PersonMobilePhone')){
                       acc.PersonMobilePhone = (String)OldDataWrapper.sobj.get('PersonMobilePhone');
                   }
                   if(listField.contains('Mobile_Phone_Number_2__pc')){
                       acc.Mobile_Phone_Number_2__pc = (String)OldDataWrapper.sobj.get('Mobile_Phone_Number_2__pc');
                   }       
                   if(listField.contains('PersonMailingCity')){
                       acc.PersonMailingCity = (String)OldDataWrapper.sobj.get('Mobile_Phone_Number_2__pc');
                   }
                   if(listField.contains('PersonMailingCountry')){
                       acc.PersonMailingCountry = (String)OldDataWrapper.sobj.get('PersonMailingCountry');
                   }
                   if(listField.contains('PersonMailingPostalCode')){
                       acc.PersonMailingPostalCode = (String)OldDataWrapper.sobj.get('PersonMailingPostalCode');
                   }
                   if(listField.contains('PersonMailingState')){
                       acc.PersonMailingState = (String)OldDataWrapper.sobj.get('PersonMailingState');
                   }
                   if(listField.contains('PersonMailingStreet')){
                       acc.PersonMailingStreet = (String)OldDataWrapper.sobj.get('PersonMailingStreet');
                   }
               }
                   
               
            
            if(OldDataWrapper.sobj != null){
                if(listField.contains('email__pc') && OldDataWrapper.sobj.get('email__pc') != null){
                    acc.Email__pc = (String)OldDataWrapper.sobj.get('email__pc');
                }
                if(listField.contains('E_mail_address_2__pc') && OldDataWrapper.sobj.get('E_mail_address_2__pc') != null){
                    acc.E_mail_address_2__pc = (String)OldDataWrapper.sobj.get('E_mail_address_2__pc');
                }
                if(listField.contains('firstname') && OldDataWrapper.sobj.get('firstname') != null){
                    acc.firstname = (String)OldDataWrapper.sobj.get('firstname');
                }
                if(listField.contains('lastname') && OldDataWrapper.sobj.get('lastname') != null){
                    acc.lastname =(String) OldDataWrapper.sobj.get('lastname');
                }
                
                if(listField.contains('PersonMobilePhone') && OldDataWrapper.sobj.get('PersonMobilePhone') != null){
                    acc.PersonMobilePhone = (String)OldDataWrapper.sobj.get('PersonMobilePhone');
                }
                if(listField.contains('Mobile_Phone_Number_2__pc') && OldDataWrapper.sobj.get('Mobile_Phone_Number_2__pc') != null){
                    acc.Mobile_Phone_Number_2__pc = (String)OldDataWrapper.sobj.get('Mobile_Phone_Number_2__pc');
                }       
                if(listField.contains('PersonMailingCity') && OldDataWrapper.sobj.get('PersonMailingCity') != null){
                    acc.PersonMailingCity = (String)OldDataWrapper.sobj.get('Mobile_Phone_Number_2__pc');
                }
                if(listField.contains('PersonMailingCountry') && OldDataWrapper.sobj.get('PersonMailingCountry') != null){
                    acc.PersonMailingCountry = (String)OldDataWrapper.sobj.get('PersonMailingCountry');
                }
                if(listField.contains('PersonMailingPostalCode') && OldDataWrapper.sobj.get('PersonMailingPostalCode') != null){
                    acc.PersonMailingPostalCode = (String)OldDataWrapper.sobj.get('PersonMailingPostalCode');
                }
                if(listField.contains('PersonMailingState') && OldDataWrapper.sobj.get('PersonMailingState') != null){
                    acc.PersonMailingState = (String)OldDataWrapper.sobj.get('PersonMailingState');
                }
                if(listField.contains('PersonMailingStreet') && OldDataWrapper.sobj.get('PersonMailingStreet') != null){
                    acc.PersonMailingStreet = (String)OldDataWrapper.sobj.get('PersonMailingStreet');
                }
            }
            
        }
        
        if(strResponse != null && strResponse != ''){
            
            strResponse = cleanResponse(strResponse);
            AccountResponse responseWrapper = (AccountResponse)JSON.deserialize(strResponse, AccountResponse.class);  
            
            //Check if error
            if(responseWrapper.UpdateClientRS.Errors != null){
                
                acc.Syncstatus__c = 'Error : ' + responseWrapper.UpdateClientRS.Errors.error[0].ShortText + ' ' + String.valueOf(DateTime.now().format());
                
            }
        }
        return acc;
    }
    
    public void actionGoodResponse(String strResponse) {
        strResponse = cleanResponse(strResponse); 
        AccountResponse responseWrap = (AccountResponse)JSON.deserialize(strResponse, AccountResponse.class);        // check for Success
        if(responseWrap.UpdateClientRS.success == null) {
            System.debug('Success');
        }
    }
    
    // request wrappers
    public class BBAccountRequestWrapper{
        public Headers headers {get;set;}
        public UpdateClient UpdateClient {get;set;}
    }
    public class Headers {
        public String ApiKey {get;set;}
    }
    public class UpdateClient {
        public String Version {get;set;}	
        public Profile Profile {get;set;}
    }
    public class Profile {
        public Customer Customer {get;set;}	
        public List<User> UserID {get;set;}
        public String StatusCode {get;set;}
    }
    public class Customer {
        public List<Person> PersonName {get;set;}	
        public List<Telephone> telephon {get;set;}
        public List<Email> Email {get;set;} 
        public List<CustLoyalty> CustLoyalty {get;set;} 
        Public List<Address> Address {get;set;}
    }
    public class User {
        public String ID {get;set;}	
    }
    public class Person {
        public List<String> GivenName {get;set;}
        public String Surname {get;set;}
    }
    public class Telephone {
        public String PhoneLocationType {get;set;}
        public String PhoneNumber {get;set;}
        public String RPH {get;set;}
    }
    public class Address {
        public List<String> AddressLine {get;set;}
        public string CityName {get;set;}
        public String PostalCode {get;set;}
        public CountryName CountryName {get;set;}
        public StateProv StateProv {get;set;}
        public String UseType{get;set;}  
    }
    public class Email {
        public String body {get;set;}
        public String RPH {get;set;}
    }
    public class CountryName {
        public String body {get;set;}
    }
    public class StateProv {
        public String body {get;set;}
    }
    // end of request wrappers
    
    // response wrappers
   
    public class AccountResponse{
        public UpdateClientRS UpdateClientRS {get;set;}
        public String startTimer {get;set;}
    }
    public class UpdateClientRS {
        public Profile Profile {get;set;}
        public Success Success {get;set;}
        Public String TimeStamp {get;set;}
        Public errors Errors {get;set;}
    } 
    public class CustLoyalty {
        public String ProgramID {get;set;}
        public String PrimaryLoyaltyIndicator {get;set;}
        public String LoyalLevel {get;set;}
        public String CustomerValue {get;set;}
        public String Remark {get;set;}
        public String TravelSector {get;set;}
    }  
    public class PrefCollections {
        public List<PrefCollection> Voucher {get;set;}
    }
    public class PrefCollection {
        public List<CommonPref> CommonPref {get;set;}
        public List<OtherSrvcPref> OtherSrvcPref {get;set;}
    }
    public class CommonPref {
        public String AltLangID {get;set;}
    }
    public class OtherSrvcPref {
        public String PreferLevel {get;set;}
        public String OtherSrvcName {get;set;}
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