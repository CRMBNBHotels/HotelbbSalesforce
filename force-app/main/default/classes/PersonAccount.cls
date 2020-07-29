global without sharing class PersonAccount {

    webservice boolean OptinNL;
    webservice String OptinEmail;
    webservice String OptinSMS;
    webservice String Fax;
    webservice boolean AuthorizedLogeCard;
    webservice Date PersonBirthdate;
    webservice String CompanyDeclarative;
    webservice String CurrentCompany;
    webservice String CustomerId;
    webservice Date DateOfEClubPurchase;
    webservice String DeclarativeFavoriteHotel;
    webservice String DeclarativeFavoriteRoomType;
    webservice String DeclarativeFavoritesOptionType;
    webservice String DeclarativeFavortiesRestaurants;
    webservice String DeclarativePassion;
    webservice String DeclarativePreferenceLanguage;
    webservice String DeclarativesFavoritesCities;
    webservice String EClubCardNumber;
    webservice String EClubCreationChannel;
    webservice Date EClubExpirationDate;
    webservice Integer EClubNumberOfPoints;
    webservice boolean EClubSubscription;
    webservice String Email;
    webservice String EmailAddress2;
    webservice String ExternalId;
    webservice String FavoriteRoomTypeLabel;
    webservice String FavoritesOption1Label;
    webservice String FavoritesOption2;
    webservice String FavoritesOption2Label;
    webservice String FavoritesOption3;
    webservice String FavoritesOption3Label;
    webservice String FirstName;
    webservice String Language;
    webservice String LastName;
    webservice String LevelEClubStatus;
    webservice String LifeCycleStatus;
    webservice boolean LoyaltySubscription;
    webservice String PersonMailingCity;
    webservice String PersonMailingCountry;
    webservice String PersonMailingState;
    webservice String PersonMailingStreet;
    webservice String PersonMailingPostalCode;
    webservice String MaritalStatus;
    webservice String PersonMobilePhone;
    webservice String MobilePhoneNumber2;
    webservice String NationalCardId;
    webservice String Nationality;
    webservice Integer NumberOfChildren;
    webservice boolean OptinBHotelsPartners;
    webservice boolean OptinCountry;
    webservice boolean OptinCreditCardStorage;
    webservice boolean OptinGoogleCalendar;
    webservice boolean OptinGroup;
    webservice String PersonOtherPhone;
    webservice String Passions;
    webservice String PassportId;
    webservice String PersonalFiscalCode;
    webservice String Salutation;
    webservice String SubscriptionSatatus;
    webservice String Username;
    webservice boolean HasAWebAccount;
    webservice String BillingCity;
    webservice String BillingCountry;
    webservice String BillingState;
    webservice String BillingStreet;
    webservice String BillingPostalCode;
    webservice String OptinBB;
    webservice String OptinPartner;
    webservice String BillingCompanyName;
    webservice String LoyaltyCountryCode;
    webservice String AdditionToAddress;
    webservice String FieldsToNull;
    webservice Date DateOfFirstClubPurchase;
    
    //Added by TMA Cynthia Geagea - CRMSS-237 - 22/07/2019 - Start
    
    webservice String EClubCountryCode;
    webservice String HotelidClubSubscription;
    
    //Added by TMA Cynthia Geagea - CRMSS-237 - 22/07/2019 - End
    
    
    public Account mapSFFields() {
        Account account = new Account();
        Set<String> setFieldsToNull = new Set<String>();
        if(String.isNotBlank(FieldsToNull)) {
            for(String field : FieldsToNull.split(',')) {
                setFieldsToNull.add(field);
            }
        }
        
        Id personAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.PersonAccountDeveloperName).getRecordTypeId();
        account.RecordTypeId = personAccountRT;
        
        if(OptinNL != null || setFieldsToNull.contains('OptinNL')) {
            account.Optin_NL__c = OptinNL;
        }
        if(String.isNotBlank(OptinEmail) || setFieldsToNull.contains('OptinEmail')) {
            account.OptinEmail__c = OptinEmail;
        }
        if(String.isNotBlank(OptinSMS) || setFieldsToNull.contains('OptinSMS')) {
            account.OptinSms__c = OptinSMS;
        }
        
        if(String.isNotBlank(Fax) || setFieldsToNull.contains('Fax')) {
            account.Fax = Fax;
        }
        //CRMSS TMA-EI JK Start
        if(DateOfFirstClubPurchase != null || setFieldsToNull.contains('DateOfFirstClubPurchase')) {
            account.DateOfFirstClubPurchase__pc = DateOfFirstClubPurchase;
        }
        //CRMSS TMA-EI JK End
        if(AuthorizedLogeCard != null || setFieldsToNull.contains('AuthorizedLogeCard')) {
            account.Authorized_Loge_Card__pc = AuthorizedLogeCard;
        }
        if(PersonBirthdate != null || setFieldsToNull.contains('PersonBirthdate')) {
            account.PersonBirthdate = PersonBirthdate;
        }
        if(String.isNotBlank(CompanyDeclarative) || setFieldsToNull.contains('CompanyDeclarative')) {
            account.Company_declarative__pc = CompanyDeclarative;
        }
        if(String.isNotBlank(CurrentCompany) || setFieldsToNull.contains('CurrentCompany')) {
            Account currentCompanyObj = new Account(ExternalId__c = CurrentCompany);
            account.Current_Compagny__pr = currentCompanyObj;
        }
        if(String.isNotBlank(CustomerId) || setFieldsToNull.contains('CustomerId')) {
            account.Customer_ID__pc = CustomerId;
        }
        if(DateOfEClubPurchase != null || setFieldsToNull.contains('DateOfEClubPurchase')) {
            account.Date_of_e_club_purchase__pc = DateOfEClubPurchase;
        }
        if(String.isNotBlank(DeclarativeFavoriteHotel) || setFieldsToNull.contains('DeclarativeFavoriteHotel')) {
            account.Declarative_favorite_hotel__pc = DeclarativeFavoriteHotel;
        } 
        if(String.isNotBlank(FavoriteRoomTypeLabel) || setFieldsToNull.contains('FavoriteRoomTypeLabel')) {
            account.Favorite_Room_type_Label__pc = FavoriteRoomTypeLabel;
        }
        if(String.isNotBlank(DeclarativeFavoriteRoomType) || setFieldsToNull.contains('DeclarativeFavoriteRoomType')) {
            account.Declarative_Favorite_Room_type__pc = DeclarativeFavoriteRoomType;
        }
        if(String.isNotBlank(DeclarativeFavoritesOptionType) || setFieldsToNull.contains('DeclarativeFavoritesOptionType')) {
            account.Declarative_favorites_option_type__pc = DeclarativeFavoritesOptionType;
        }
        if(String.isNotBlank(DeclarativeFavortiesRestaurants) || setFieldsToNull.contains('DeclarativeFavortiesRestaurants')) {
            account.Declarative_favorites_restaurants__pc = DeclarativeFavortiesRestaurants;
        }
        if(String.isNotBlank(DeclarativePassion) || setFieldsToNull.contains('DeclarativePassion')) {
            account.Declarative_passion__pc = DeclarativePassion;
        }
        if(String.isNotBlank(DeclarativePreferenceLanguage) || setFieldsToNull.contains('DeclarativePreferenceLanguage')) {
            account.Declarative_preference_language__pc = DeclarativePreferenceLanguage;
        }
        if(String.isNotBlank(DeclarativesFavoritesCities) || setFieldsToNull.contains('DeclarativesFavoritesCities')) {
            account.Declaratives_favorites_cities__pc = DeclarativesFavoritesCities;
        }
        if(String.isNotBlank(EClubCardNumber) || setFieldsToNull.contains('EClubCardNumber')) {
            account.E_club_card_number__pc = EClubCardNumber;
        }
        if(String.isNotBlank(EClubCreationChannel) || setFieldsToNull.contains('EClubCreationChannel')) {
            account.E_club_Creation_channel__pc = EClubCreationChannel;
        }
        if(EClubExpirationDate != null || setFieldsToNull.contains('EClubExpirationDate')) {
            account.E_club_Expiration_date__pc = EClubExpirationDate;
        }
        if(EClubNumberOfPoints != null || setFieldsToNull.contains('EClubNumberOfPoints')) {
            account.E_club_Number_of_points__pc = EClubNumberOfPoints;
        }
        if(EClubSubscription != null || setFieldsToNull.contains('EClubSubscription')) {
            account.E_club_subscription__pc = EClubSubscription;
        }
        if(String.isNotBlank(Email) || setFieldsToNull.contains('Email')) {
            account.Email__pc = Email;
        }
        if(String.isNotBlank(EmailAddress2) || setFieldsToNull.contains('EmailAddress2')) {
            account.E_mail_address_2__pc = EmailAddress2;
        }
        if(String.isNotBlank(ExternalId) || setFieldsToNull.contains('ExternalId')) {
            account.ExternalId__c = ExternalId;
        }
        if(String.isNotBlank(FavoritesOption1Label) || setFieldsToNull.contains('FavoritesOption1Label')) {
            account.Favorites_option_1_Label__pc = FavoritesOption1Label;
        }
        if(String.isNotBlank(FavoritesOption2) || setFieldsToNull.contains('FavoritesOption2')) {
            account.Favorites_option_2__pc = FavoritesOption2;
        }
        if(String.isNotBlank(FavoritesOption2Label) || setFieldsToNull.contains('FavoritesOption2Label')) {
            account.Favorites_option_2_Label__pc = FavoritesOption2Label;
        }
        if(String.isNotBlank(FavoritesOption3) || setFieldsToNull.contains('FavoritesOption3')) {
            account.Favorites_option_type_3__pc = FavoritesOption3;
        }
        if(String.isNotBlank(FavoritesOption3Label) || setFieldsToNull.contains('FavoritesOption3Label')) {
            account.Favorites_option_3_label__pc = FavoritesOption3Label;
        }
        if(String.isNotBlank(FirstName) || setFieldsToNull.contains('FirstName')) {
            account.FirstName = FirstName;
        }
        if(String.isNotBlank(Language) || setFieldsToNull.contains('Language')) {
            account.Language__pc = Language;
        }
        if(String.isNotBlank(LastName) || setFieldsToNull.contains('LastName')) {
            account.LastName = LastName;
        }
        if(String.isNotBlank(LevelEClubStatus) || setFieldsToNull.contains('LevelEClubStatus')) {
            account.Level_e_club_status__pc = LevelEClubStatus;
        }
        if(String.isNotBlank(LifeCycleStatus) || setFieldsToNull.contains('LifeCycleStatus')) {
            account.Lifecycle_status__pc = LifeCycleStatus;
        }
        if(LoyaltySubscription != null || setFieldsToNull.contains('LoyaltySubscription')) {
            account.Loyalty_Subscriptions__pc = LoyaltySubscription;
        }
        if(String.isNotBlank(PersonMailingCity) || setFieldsToNull.contains('PersonMailingCity')) {
            account.PersonMailingCity = PersonMailingCity;
        }
        if(String.isNotBlank(PersonMailingCountry) || setFieldsToNull.contains('PersonMailingCountry')) {
            account.PersonMailingCountry = PersonMailingCountry;
        }
        if(String.isNotBlank(PersonMailingState) || setFieldsToNull.contains('PersonMailingState')) {
            account.PersonMailingState = PersonMailingState;
        }
        if(String.isNotBlank(PersonMailingStreet) || setFieldsToNull.contains('PersonMailingStreet')) {
            account.PersonMailingStreet = PersonMailingStreet;
        }
        if(String.isNotBlank(PersonMailingPostalCode) || setFieldsToNull.contains('PersonMailingPostalCode')) {
            account.PersonMailingPostalCode = PersonMailingPostalCode;
        }
        if(String.isNotBlank(MaritalStatus) || setFieldsToNull.contains('MaritalStatus')) {
            account.Marital_Status__pc = MaritalStatus;
        }
        if(String.isNotBlank(PersonMobilePhone) || setFieldsToNull.contains('PersonMobilePhone')) {
            account.PersonMobilePhone = PersonMobilePhone;
        }
        if(String.isNotBlank(MobilePhoneNumber2) || setFieldsToNull.contains('MobilePhoneNumber2')) {
            account.Mobile_Phone_Number_2__pc = MobilePhoneNumber2;
        }
        if(String.isNotBlank(NationalCardId) || setFieldsToNull.contains('NationalCardId')) {
            account.National_Card_ID__pc = NationalCardId;
        }
        if(String.isNotBlank(Nationality) || setFieldsToNull.contains('Nationality')) {
            account.Nationality__pc = Nationality;
        }
        if(NumberOfChildren != null || setFieldsToNull.contains('NumberOfChildren')) {
            account.Number_of_children__pc = NumberOfChildren;
        }
        if(OptinBHotelsPartners != null || setFieldsToNull.contains('OptinBHotelsPartners')) {
            account.OptinB_B_Hotels_partners__pc = OptinBHotelsPartners;
        }
        if(OptinCountry != null || setFieldsToNull.contains('OptinCountry')) {
            account.Optincountry__pc = OptinCountry;
        }
        if(OptinCreditCardStorage != null || setFieldsToNull.contains('OptinCreditCardStorage')) {
            account.OptinCredit_card_storage__pc = OptinCreditCardStorage;
        }
        if(OptinGoogleCalendar != null || setFieldsToNull.contains('OptinGoogleCalendar')) {
            account.Optingoogle_Calendar__pc = OptinGoogleCalendar;
        }
        if(OptinGroup != null || setFieldsToNull.contains('OptinGroup')) {
            account.Optingroup__pc = OptinGroup;
        }
        if(String.isNotBlank(PersonOtherPhone) || setFieldsToNull.contains('PersonOtherPhone')) {
            account.PersonOtherPhone = PersonOtherPhone;
        }
        if(String.isNotBlank(Passions) || setFieldsToNull.contains('Passions')) {
            account.Passions__pc = Passions;
        }
        if(String.isNotBlank(PassportId) || setFieldsToNull.contains('PassportId')) {
            account.Passeport_ID__pc = PassportId;
        }
        if(String.isNotBlank(PersonalFiscalCode) || setFieldsToNull.contains('PersonalFiscalCode')) {
            account.Personal_Fiscal_Code__pc = PersonalFiscalCode;
        }
        if(String.isNotBlank(Salutation) || setFieldsToNull.contains('Salutation')) {
            account.Salutation = Salutation;
        }
        if(String.isNotBlank(SubscriptionSatatus) || setFieldsToNull.contains('SubscriptionSatatus')) {
            account.Subscription_status__pc = SubscriptionSatatus;
        }
        if(String.isNotBlank(Username) || setFieldsToNull.contains('Username')) {
            account.Username__pc = Username;
        }
        if(String.isNotBlank(BillingCity) || setFieldsToNull.contains('BillingCity')) {
            account.BillingCity = BillingCity;
        }
        if(String.isNotBlank(BillingCountry) || setFieldsToNull.contains('BillingCountry')) {
            account.BillingCountry = BillingCountry;
        }
        if(String.isNotBlank(BillingState) || setFieldsToNull.contains('BillingState')) {
            account.BillingState = BillingState;
        }
        if(String.isNotBlank(BillingStreet) || setFieldsToNull.contains('BillingStreet')) {
            account.BillingStreet = BillingStreet;
        }
        if(String.isNotBlank(BillingPostalCode) || setFieldsToNull.contains('BillingPostalCode')) {
            account.BillingPostalCode = BillingPostalCode;
        }
        if(String.isNotBlank(OptinBB) || setFieldsToNull.contains('OptinBB')) {
            account.Opt_in_B_B__pc = OptinBB;
        }
        if(String.isNotBlank(OptinPartner) || setFieldsToNull.contains('OptinPartner')) {
            account.Opt_in_partner__pc = OptinPartner;
        }
        if(String.isNotBlank(BillingCompanyName) || setFieldsToNull.contains('BillingCompanyName')) {
            account.Billing_Company_Name__pc = BillingCompanyName;
        }
        if(String.isNotBlank(LoyaltyCountryCode) || setFieldsToNull.contains('LoyaltyCountryCode')) {
            account.Loyalty_country_code__pc = LoyaltyCountryCode;
        }
        if(String.isNotBlank(AdditionToAddress) || setFieldsToNull.contains('AdditionToAddress')) {
            account.Addition_to_address__c = AdditionToAddress;
        }
        if(HasAWebAccount != null || setFieldsToNull.contains('HasAWebAccount')) {
            account.Has_a_Web_Account__pc = HasAWebAccount;
        }
        
        //Added by TMA Cynthia Geagea - 22/07/2019 - Start
        
        if(String.isNotBlank(EClubCountryCode)  || setFieldsToNull.contains('EClubCountryCode')) {
            account.E_club_country_code__c = EClubCountryCode;
        }
        if(String.isNotBlank(HotelidClubSubscription) || setFieldsToNull.contains('HotelidClubSubscription')) {
            account.Hotelid_club_subscription__c = HotelidClubSubscription;
        }
        
        //Added by TMA Cynthia Geagea - 22/07/2019 - End
        
        return account;
    }
}