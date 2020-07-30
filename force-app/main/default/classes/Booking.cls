//test class: WS02_BookingInfo_Test
global class Booking {
     
    webservice String Account;
    webservice String BookingDevice;
    webservice boolean BookingCancellable;
    webservice String BookingComment;
    webservice String BookingSource;
    webservice String StageName;
    webservice boolean BookingUpdatable;
    webservice boolean IncludeBreakfast;
    webservice String BusinessLead;
    webservice String ChannelCategory;
    webservice Date CheckInDate;
    webservice Date CheckOutDate;
    webservice Date CloseDate;
    webservice String DistributionMode;
    webservice String ExternalId;
    webservice String MasterBooking;
    webservice String FirstStatus;
    webservice String CurrentStatus;
    webservice String Guarantee;
    webservice String Hotel;
    webservice double InvoicedAmount;
    webservice Date MinArrival;
    webservice Date MaxDeprature;
    webservice String Name;
    webservice String PartnerCode;
    webservice boolean PaymentAtBooking;
    webservice String PersonAccount;
    webservice String PMSClientId;
    webservice String Rate;
    webservice String Status;
    webservice String TripContext;
    webservice String TripReason;
    webservice String UtmSource;
    webservice String UtmMedium;
    webservice String UtmCampaign;
    webservice String Term;
    webservice String Content;
    webservice String CadStatus;
    webservice String LastNameBooking;
    webservice String FirstNameBooking;
    webservice String EmailAddressBooking;
    webservice String PhoneNumberBooking;
    webservice String CancellationPolicyCode;
    webservice String GuarantyPolicyCode;
    webservice String ConfirmationNumber;
    webservice String SecondRateCode;
    webservice boolean CheckinBySMS;
    webservice double InvoicedCityTax;
    webservice double AmountCityTax;
    webservice String WalletStatus;
    webservice Integer EarnPoint;
    webservice String TypeCityTax;
    webservice String FieldsToNull;
    webservice String GuestAccount1;
    webservice String GuestAccount2;
    webservice String GuestAccount3;
    webservice String GuestAccount4;
    webservice String GuestAccount5;
    webservice String CurrencyIsoCode;
    
    public Opportunity mapSFFields() {
        Opportunity booking = new Opportunity();
        Set<String> setFieldsToNull = new Set<String>();
        if(String.isNotBlank(FieldsToNull)) {
            for(String field : FieldsToNull.split(',')) {
                setFieldsToNull.add(field);
            }
        }
        
        Id bookingRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId();
        booking.RecordTypeId = bookingRT;
        
        Account accountObj = null;
        if(String.isNotBlank(Account) || setFieldsToNull.contains('Account')) {
            accountObj = new Account(ExternalId__c = Account);
            booking.Account = accountObj;
        }
        if(String.isNotBlank(BookingDevice) || setFieldsToNull.contains('BookingDevice')) {
            booking.BookerDevice__c = BookingDevice;
        }
            if(String.isNotBlank(CurrencyIsoCode) || setFieldsToNull.contains('CurrencyIsoCode')) {
                booking.CurrencyIsoCode = CurrencyIsoCode;
            }
        if(String.isNotBlank(BookingComment) || setFieldsToNull.contains('BookingComment')) {
            booking.BookingComment__c = BookingComment;
        }
        if(String.isNotBlank(BookingSource) || setFieldsToNull.contains('BookingSource')) {
            booking.BookingSource__c = BookingSource;
        }
        if(String.isNotBlank(StageName) || setFieldsToNull.contains('StageName')) {
            booking.StageName = StageName;
        }
        if(String.isNotBlank(BusinessLead) || setFieldsToNull.contains('BusinessLead')) {
            booking.Business_Lead__c = BusinessLead;
        }
        if(String.isNotBlank(ChannelCategory) || setFieldsToNull.contains('ChannelCategory')) {
            booking.ChannelCategory__c = ChannelCategory;
        }
        if(String.isNotBlank(DistributionMode) || setFieldsToNull.contains('DistributionMode')) {
            booking.DistributionMode__c = DistributionMode;
        }
        if(String.isNotBlank(ExternalId) || setFieldsToNull.contains('ExternalId')) {
            booking.ExternalId__c = ExternalId;
        }
        if(String.isNotBlank(MasterBooking) || setFieldsToNull.contains('MasterBooking')) {
            if(MasterBooking != null) {
                Opportunity masterBookingObj = new Opportunity(ExternalId__c = MasterBooking);
                booking.Master_Booking_FK__r = masterBookingObj;
            } else if(setFieldsToNull.contains('MasterBooking')) {
                booking.Master_Booking_FK__c = null;
            }
            
        }
        if(String.isNotBlank(FirstStatus) || setFieldsToNull.contains('FirstStatus')) {
            booking.First_Status_FK__c = FirstStatus;
        }
        if(String.isNotBlank(CurrentStatus) || setFieldsToNull.contains('CurrentStatus')) {
            booking.Current_Status_FK__c = CurrentStatus;
        }
        if(String.isNotBlank(Guarantee) || setFieldsToNull.contains('Guarantee')) {
            booking.Guarentee__c = Guarantee;
        }
        if(String.isNotBlank(Hotel) || setFieldsToNull.contains('Hotel')) {
            if(Hotel != null) {                
                Hotel__c hotelObj = new Hotel__c(Hotel_ID__c = Hotel);
                booking.Hotel__r = hotelObj;
            } else if(setFieldsToNull.contains('Hotel')) {
                booking.Hotel__c = null;
            }
        }
        if(String.isNotBlank(Name) || setFieldsToNull.contains('Name')) {
            booking.Name = Name;
        }        
        if(String.isNotBlank(PartnerCode) || setFieldsToNull.contains('PartnerCode')) {
            system.debug('else remove ______ +++++');
            //booking.Partner_Code__c = PartnerCode;
            //Ticket CRMSS-286 Start
            if(PartnerCode != null) { 
                accountObj = new Account(Partner_Code__c = PartnerCode);
                booking.PartnerCode__r = accountObj;
                system.debug('#### accountObj ' + accountObj);
                //Ticket CRMSS-286 End
            }else if(setFieldsToNull.contains('PartnerCode')) {
                system.debug('else remove ______');
                booking.PartnerCode__c = null;
            }
        }
        if(String.isNotBlank(PersonAccount) || setFieldsToNull.contains('PersonAccount')) {
            if(PersonAccount != null) {
                accountObj = new Account(ExternalId__c = PersonAccount);
                booking.Person_Account__r = accountObj;
            } else if(setFieldsToNull.contains('PersonAccount')) {
                booking.Person_Account__c = null;
            }
            
        }
        if(String.isNotBlank(PMSClientId) || setFieldsToNull.contains('PMSClientId')) {
            booking.PMSClientId__c = PMSClientId;
        }
        if(String.isNotBlank(Rate) || setFieldsToNull.contains('Rate')) {
            booking.Rate__c = Rate;
        }
        if(String.isNotBlank(Status) || setFieldsToNull.contains('Status')) {
            booking.Status__c = Status;
        }
        if(String.isNotBlank(TripContext) || setFieldsToNull.contains('TripContext')) {
            booking.Trip_Context__c = TripContext;
        }
        if(String.isNotBlank(TripReason) || setFieldsToNull.contains('TripReason')) {
            booking.Trip_Reason__c = TripReason;
        }
        if(String.isNotBlank(UtmSource) || setFieldsToNull.contains('UtmSource')) {
            booking.utm_source__c = UtmSource;
        }
        if(String.isNotBlank(UtmMedium) || setFieldsToNull.contains('UtmMedium')) {
            booking.utm_medium__c = UtmMedium;
        }
        if(String.isNotBlank(UtmCampaign) || setFieldsToNull.contains('UtmCampaign')) {
            booking.utm_campaign__c = UtmCampaign;
        }
        if(String.isNotBlank(Term) || setFieldsToNull.contains('Term')) {
            booking.utm_term__c = Term;
        }
        if(String.isNotBlank(Content) || setFieldsToNull.contains('Content')) {
            booking.utm_content__c = Content;
        }
        if(String.isNotBlank(CadStatus) || setFieldsToNull.contains('CadStatus')) {
            booking.cad_status__c = CadStatus;
        }
        if(String.isNotBlank(LastNameBooking) || setFieldsToNull.contains('LastNameBooking')) {
            booking.LastNameBooking__c = LastNameBooking;
        }
        if(String.isNotBlank(FirstNameBooking) || setFieldsToNull.contains('FirstNameBooking')) {
            booking.FirstNameBooking__c = FirstNameBooking;
        }
        if(String.isNotBlank(EmailAddressBooking) || setFieldsToNull.contains('EmailAddressBooking')) {
            booking.Email_AddressBooking__c = EmailAddressBooking;
        }
        if(String.isNotBlank(PhoneNumberBooking) || setFieldsToNull.contains('PhoneNumberBooking')) {
            booking.Phone_NumberBooking__c = PhoneNumberBooking;
        }
        if(String.isNotBlank(CancellationPolicyCode) || setFieldsToNull.contains('CancellationPolicyCode')) {
            booking.Cancellation_policy_Code__c = CancellationPolicyCode;
        }
        if(String.isNotBlank(GuarantyPolicyCode) || setFieldsToNull.contains('GuarantyPolicyCode')) {
            booking.Guaranty_policy_code__c = GuarantyPolicyCode;
        }
        if(String.isNotBlank(ConfirmationNumber) || setFieldsToNull.contains('ConfirmationNumber')) {
            booking.Confirmation_Number__c = ConfirmationNumber;
        }
        if(String.isNotBlank(SecondRateCode) || setFieldsToNull.contains('SecondRateCode')) {
            booking.Second_Rate_Code__c = SecondRateCode;
        }
        if(String.isNotBlank(GuestAccount1) || setFieldsToNull.contains('GuestAccount1')) {
            if(GuestAccount1 != null) {
                accountObj = new Account(ExternalId__c = GuestAccount1);
                booking.Guest_Account_1__r = accountObj;
            } else if(setFieldsToNull.contains('GuestAccount1')) {
                booking.Guest_Account_1__c = null;
            }
            
        }
        if(String.isNotBlank(GuestAccount2) || setFieldsToNull.contains('GuestAccount2')) {
           if(GuestAccount2 != null) {
                accountObj = new Account(ExternalId__c = GuestAccount2);
                booking.Guest_Account_2__r = accountObj;
            } else if(setFieldsToNull.contains('GuestAccount2')) {
                booking.Guest_Account_2__c = null;
            }
        }
        if(String.isNotBlank(GuestAccount3) || setFieldsToNull.contains('GuestAccount3')) {
            if(GuestAccount3 != null) {
                accountObj = new Account(ExternalId__c = GuestAccount3);
                booking.Guest_Account_3__r = accountObj;
            } else if(setFieldsToNull.contains('GuestAccount3')) {
                booking.Guest_Account_3__c = null;
            }
        }
        if(String.isNotBlank(GuestAccount4) || setFieldsToNull.contains('GuestAccount4')) {
            if(GuestAccount4 != null) {
                accountObj = new Account(ExternalId__c = GuestAccount4);
                booking.Guest_Account_4__r = accountObj;
            } else if(setFieldsToNull.contains('GuestAccount4')) {
                booking.Guest_Account_4__c = null;
            }
        }
        if(String.isNotBlank(GuestAccount5) || setFieldsToNull.contains('GuestAccount5')) {
            if(GuestAccount5 != null) {
                accountObj = new Account(ExternalId__c = GuestAccount5);
                booking.Guest_Account_5__r = accountObj;
            } else if(setFieldsToNull.contains('GuestAccount5')) {
                booking.Guest_Account_5__c = null;
            }
        }
        if(String.isNotBlank(WalletStatus) || setFieldsToNull.contains('WalletStatus')) {
            booking.Wallet_Status__c = WalletStatus;
        }
        if(String.isNotBlank(TypeCityTax) || setFieldsToNull.contains('TypeCityTax')) {
            booking.Type_city_tax__c = TypeCityTax;
        }        
        if(BookingCancellable != null || setFieldsToNull.contains('BookingCancellable')) {
            booking.BookingCancellable__c = BookingCancellable;
        }
        if(BookingUpdatable != null || setFieldsToNull.contains('BookingUpdatable')) {
            booking.BookingUpdatable__c = BookingUpdatable;
        }
        if(IncludeBreakfast != null || setFieldsToNull.contains('IncludeBreakfast')) {
            booking.Include_Breakfast__c = IncludeBreakfast;
        }
        if(CheckInDate != null || setFieldsToNull.contains('CheckInDate')) {
            booking.CheckInDate__c = CheckInDate;
        }
        if(CheckOutDate != null || setFieldsToNull.contains('CheckOutDate')) {
            booking.CheckOutDate__c = CheckOutDate;
        }
        if(CloseDate != null || setFieldsToNull.contains('CloseDate')) {
            booking.CloseDate = CloseDate;
        }
        if(InvoicedAmount != null || setFieldsToNull.contains('InvoicedAmount')) {
            booking.Invoiced_amount__c = InvoicedAmount;
        }
        if(MinArrival != null || setFieldsToNull.contains('MinArrival')) {
            booking.Min_Arrival__c = MinArrival;
        }
        if(MaxDeprature != null || setFieldsToNull.contains('MaxDeprature')) {
            booking.Max_Departure__c = MaxDeprature;
        }
        if(PaymentAtBooking != null || setFieldsToNull.contains('PaymentAtBooking')) {
            booking.Payment_at_Booking__c = PaymentAtBooking;
        }
        if(CheckinBySMS != null || setFieldsToNull.contains('CheckinBySMS')) {
            booking.CheckinbySMS__c = CheckinBySMS;
        }
        if(InvoicedCityTax != null || setFieldsToNull.contains('InvoicedCityTax')) {
            booking.Invoiced_city_tax__c = InvoicedCityTax;
        }
        if(AmountCityTax != null || setFieldsToNull.contains('AmountCityTax')) {
           // booking.Amount_City_Tax__c = AmountCityTax;
        }
        if(EarnPoint != null || setFieldsToNull.contains('EarnPoint')) {
            booking.Earn_Point__c = EarnPoint;
        }
        
        return booking;
    }
    
}