global without sharing virtual class MasterBooking {
    
    webservice String BusinessLead;
    webservice String Channel;
    webservice String ChannelDescription;
    webservice String ClientFK;
    webservice Date CloseDate;
    webservice String Contact;
    webservice String Distribution;
    webservice String Email;
    webservice String ExternalId;
    webservice String FirstName;
    webservice String LastName;
    webservice String Language;
    webservice Date MinArrival;
    webservice Date MaxDeparture;
    webservice String MobilePhoneNumber;
    webservice String Name;
    webservice Integer NbrOfAdults;
    webservice Integer NbrOfChildren;
    webservice String PersonAccount;
    webservice String PhoneNumber;
    webservice String Source;
    webservice String StageName;
    webservice double InvoicedCityTax;
    webservice String FieldsToNull;
    webservice double InvoicedAmount;
    webservice String CurrencyIsoCode;
     
    
    public Opportunity mapSFFields() {
        Opportunity masterBooking = new Opportunity();
        Set<String> setFieldsToNull = new Set<String>();
        if(String.isNotBlank(FieldsToNull)) {
            for(String field : FieldsToNull.split(',')) {
                setFieldsToNull.add(field);
            }
        }
        
        Id masterBookingRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.MasterBookingRTDevName).getRecordTypeId();
        masterBooking.RecordTypeId = masterBookingRT;
        
        if(String.isNotBlank(BusinessLead) || setFieldsToNull.contains('BusinessLead')) {
            masterBooking.Business_Lead__c = BusinessLead;
        }
        if(String.isNotBlank(Channel) || setFieldsToNull.contains('Channel')) {
            masterBooking.Channel__c = Channel;
        }
        if(String.isNotBlank(CurrencyIsoCode) || setFieldsToNull.contains('CurrencyIsoCode')) {
            masterBooking.CurrencyIsoCode = CurrencyIsoCode;
        }
        if(String.isNotBlank(ChannelDescription) || setFieldsToNull.contains('ChannelDescription')) {
            masterBooking.Channel_description__c = ChannelDescription;
        }
        if(String.isNotBlank(ClientFK) || setFieldsToNull.contains('ClientFK')) {
            masterBooking.Client_FK__c = ClientFK;
        }
        if(CloseDate != null || setFieldsToNull.contains('CloseDate')) {
            masterBooking.CloseDate = CloseDate;
        }
        if(String.isNotBlank(Contact) || setFieldsToNull.contains('Contact')) {
            if(Contact != null) {
                Contact contactObj = new Contact(ExternalId__c = Contact);
                masterBooking.Contact__r = contactObj;
            } else if(setFieldsToNull.contains('Contact')){
                masterBooking.Contact__c = null;
            }
        }
        if(String.isNotBlank(Distribution) || setFieldsToNull.contains('Distribution')) {
            masterBooking.Distribution__c = Distribution;
        }
        if(String.isNotBlank(Email) || setFieldsToNull.contains('Email')) {
            masterBooking.E_mail__c = Email;
        }
        if(String.isNotBlank(ExternalId) || setFieldsToNull.contains('ExternalId')) {
            masterBooking.Externalid__c = ExternalId;
        }
        if(String.isNotBlank(FirstName) || setFieldsToNull.contains('FirstName')) {
            masterBooking.First_Name__c = FirstName;
        }
        if(String.isNotBlank(LastName) || setFieldsToNull.contains('LastName')) {
            masterBooking.Last_Name__c = LastName;
        }
        if(String.isNotBlank(Language) || setFieldsToNull.contains('Language')) {
            masterBooking.Language__c = Language;
        }
        if(MinArrival != null || setFieldsToNull.contains('MinArrival')) {
            masterBooking.Min_Arrival__c = MinArrival;
        }
        if(MaxDeparture != null || setFieldsToNull.contains('MaxDeparture')) {
            masterBooking.Max_Departure__c = MaxDeparture;
        }
        if(String.isNotBlank(MobilePhoneNumber) || setFieldsToNull.contains('MobilePhoneNumber')) {
            masterBooking.Mobile_Phone_Number__c = MobilePhoneNumber;
        }
        if(String.isNotBlank(Name) || setFieldsToNull.contains('Name')) {
            masterBooking.Name = Name;
        }
        if(String.isNotBlank(PersonAccount) || setFieldsToNull.contains('PersonAccount')) {
            if(PersonAccount != null) {
                Account personAccountObj = new Account(ExternalId__c = PersonAccount);
                masterBooking.Person_Account__r = personAccountObj;
            } else if(setFieldsToNull.contains('PersonAccount')) {
                masterBooking.Person_Account__c = null;
            }            
        }
        if(String.isNotBlank(PhoneNumber) || setFieldsToNull.contains('PhoneNumber')) {
            masterBooking.Phone_Number__c = PhoneNumber;
        }
        if(String.isNotBlank(Source) || setFieldsToNull.contains('Source')) {
            masterBooking.Source__c = Source;
        }
        if(String.isNotBlank(StageName) || setFieldsToNull.contains('StageName')) {
            masterBooking.StageName = StageName;
        }
        if(NbrOfAdults != null || setFieldsToNull.contains('NbrOfAdults')) {
            masterBooking.NB_Adults__c = NbrOfAdults;
        }
        if(NbrOfChildren != null || setFieldsToNull.contains('NbrOfChildren')) {
            masterBooking.NB_Children__c = NbrOfChildren;
        }
        if(InvoicedCityTax != null || setFieldsToNull.contains('InvoicedCityTax')) {
            masterBooking.Invoiced_city_tax__c = InvoicedCityTax;
        }
        if(InvoicedAmount != null || setFieldsToNull.contains('InvoicedAmount')) {
            masterBooking.Invoiced_amount__c = InvoicedAmount;
        }
        return masterBooking;
    }  
}