@isTest
public class TestDataFactory {
    
    /**
    * Static method that return a single user
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @return  UserMap A Map of the created users 
    *
    */  
    public static User createSingleUser(Boolean insertValue) { 
        User temp = TestDataFactory.createUsers(1).get('User1');
        if(insertValue){
            insert temp;
        }              
       return temp;
    }

    /**
     * Static method returning a user with Standard User profile
     * @author  Omar Bensouda o.bensouda@obkconsulting.com
     * @param   j the number of user to create  
     * @return  UserMap A Map of the created users 
     *
     */
    public static Map<String, User> createUsers(Integer j) {
                    
        Map<String, user> userMap = new Map<String, user>();
        
        ID standardUserProfileID = [SELECT ID, Name FROM Profile WHERE Name='System Administrator'].ID;
        
        for(Integer i=1 ; i <= j ; i++ ){                            
            User user1 = new User(FirstName         = 'John Test' + i, 
                                 LastName               = 'Doe' + i,  
                                 alias                  = 'jdoeT' + i, 
                                 email                  = 'jdoetest' + i + '@hotelbb.com', 
                                 username               = 'johnDoe93281' + i + '@testuser.com', 
                                 CommunityNickname      = 'johnDoe032193' + i, 
                                 EmailEncodingKey       = 'UTF-8',
                                 // DefaultCurrencyIsoCode = 'EUR', 
                                 LocaleSidKey           = 'en_US', 
                                 LanguageLocaleKey      = 'en_US',
                                 TimeZoneSidKey         = 'Europe/Paris', 
                                 ProfileID              = standardUserProfileID,
                                 Phone                  = '+33 23 45 67 89'
                                );      
            userMap.put('User'+ i, user1);                                
        }        
       
       return userMap;
    }
    public static List<Account> createCompanyAccounts(Integer nbrCompanyAccounts) {
        List<Account> lstCompanyAccounts = new List<Account>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
        Account company;
        for(Integer i = 1 ; i <= nbrCompanyAccounts ; i++) {
            company = new Account();
            company.Name = 'company_account_' + i;
            company.RecordTypeId = RecordTypeId;
            company.BillingCountry = 'France';
            company.BillingPostalCode = '99999';
            company.Externalid__c ='company_account_' + i;
            lstCompanyAccounts.add(company);
        }
        
        return lstCompanyAccounts;
    }
    
    public static List<Account> createGuestAccounts(Integer nbrGuestAccounts) {
        List<Account> lstGuestAccounts = new List<Account>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.PersonAccountDeveloperName).getRecordTypeId();
        Account guest;
        for(Integer i = 1 ; i <= nbrGuestAccounts ; i++) {
            guest = new Account();
            guest.LastName = 'guest_account_' + i;
            guest.RecordTypeId = RecordTypeId;
            lstGuestAccounts.add(guest);
        }
        
        return lstGuestAccounts;
    }
    
    public static List<Opportunity> createBusinessBookings(Integer nbrBookings, List<Account> lstGuestAccounts) {
        List<Opportunity> lstBookings = new List<Opportunity>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId();
        Opportunity booking;
        for(Integer i = 1 ; i <= nbrBookings; i++) {
            booking = new Opportunity();
            booking.Name = 'booking_' + i;
            booking.Externalid__c = 'booking_' + i;
            booking.RecordTypeId = recordTypeId;
            booking.CloseDate = Date.today().addMonths(2);
            booking.StageName = Label.StageChecked;
            booking.Trip_Context__c = Label.BusinessCustomerType;
            booking.Guest_Account_1__c = lstGuestAccounts[0].Id;
            booking.Min_Arrival__c = Date.today();
            booking.Max_Departure__c = Date.today().addDays(5);
            lstBookings.add(booking);
        }
        return lstBookings;
    }
    
    public static List<Hotel__c> createHotels(Integer nbrHotels) {
        List<Hotel__c> lstHotels = new List<Hotel__c>();
        Hotel__c hot;
        for(Integer i = 1 ; i <= nbrHotels; i++) {
            hot = new Hotel__c();
            hot.Commercial_Hotel_Name__c  = 'hotel_' + i;
            hot.Hotel_ID__c = 'hotel_' + i;
            hot.Country__c = 'FR';
            lstHotels.add(hot);
        }
       
        return lstHotels;
    }

    static Booking createWSBooking(Integer i, Id hotelId, Id companyAccountId, List<Id> lstGuestAccountIds) {
        Booking booking = new Booking();
        if(companyAccountId != null) {
            booking.Account = companyAccountId;
        }
        if(hotelId != null) {
           booking.Hotel = hotelId; 
        }
        booking.BookingDevice = 'Phone';
        booking.BookingCancellable = true;
        booking.BookingComment = 'No comments';
        booking.BookingSource = 'Website';
        booking.StageName = Label.StageChecked;
        booking.BookingUpdatable = false;
        booking.IncludeBreakfast = true;
        booking.BusinessLead = 'Lead_'+i;
        booking.ChannelCategory = 'Channel_'+i;
        booking.CheckInDate = Date.today();
        booking.CheckOutDate = Date.today().addDays(5);
        booking.CloseDate = Date.today().addMonths(1);
        booking.DistributionMode = 'DistributionMode';
        booking.ExternalId = 'booking_' + i;
        booking.FirstStatus = 'Checked';
        booking.CurrentStatus = 'Checked';
        booking.Guarantee = 'No Guarantee';        
        booking.MinArrival = Date.today();
        booking.MaxDeprature = Date.today().addDays(5);
        booking.Name = 'Booking_'+i;
        booking.PartnerCode = 'PC123' ;
        booking.PaymentAtBooking = false;
        booking.Status = 'Checked' ;
        booking.TripContext = Label.BusinessCustomerType;
        booking.TripReason = Label.BusinessCustomerType;
        booking.UtmSource = 'source';
        booking.UtmMedium = 'medium';
        booking.Term = 'term1';
        booking.LastNameBooking = 'Hobeika';
        booking.FirstNameBooking = 'Georges';
        booking.EmailAddressBooking = 'obk.georges@gmail.com';
        booking.ConfirmationNumber = 'CN123'; 
        booking.CheckinBySMS = true;
        //booking.InvoicedCityTax = 10;
        booking.AmountCityTax = 12.50;
        booking.WalletStatus = 'Pending';
        booking.EarnPoint = 200;
        booking.TypeCityTax = 'Exclusive';
        //booking.FieldsToNull = 'MasterBooking,InvoicedAmount,PersonAccount,PMSClientId,Rate,UtmCampaign,Content,CadStatus,PhoneNumberBooking,CancellationPolicyCode,GuarantyPolicyCode,SecondRateCode';
        if(lstGuestAccountIds != null && lstGuestAccountIds.size() == 5) {
            booking.GuestAccount1 = lstGuestAccountIds[0];
            booking.GuestAccount2 = lstGuestAccountIds[1];
            booking.GuestAccount3 = lstGuestAccountIds[2];
            booking.GuestAccount4 = lstGuestAccountIds[3];
            booking.GuestAccount5 = lstGuestAccountIds[4];
        }
        
        return booking;
    }
    
    public static WS02_BookingInfo.Bookings createWSBookingInfoBookings(Integer nbrBookings) {
        List<Account> lstGuestAccounts = createGuestAccounts(5);
        insert lstGuestAccounts;
        List<Id> lstGuestAccountIds = new List<Id>();
        for(Integer i = 0 ; i < 5 ; i++) {
            lstGuestAccountIds.add(lstGuestAccounts[i].Id);
        }
        List<Account> lstCompanyAccounts = createCompanyAccounts(100);
        upsert lstCompanyAccounts Externalid__c;

        List<Hotel__c> lstHotels = createHotels(100);
        upsert  lstHotels Hotel_ID__c;
        WS02_BookingInfo.Bookings bookings = new WS02_BookingInfo.Bookings();
        List<Booking> lstBookings = new List<Booking>();
        for(Integer i = 0; i < nbrBookings; i++) { 
            lstBookings.add(createWSBooking(i, lstHotels[i].Id, lstCompanyAccounts[i].Id, lstGuestAccountIds));
        }
        bookings.Booking = lstBookings;
        return bookings;
    }
    
    public static WS02_BookingInfo.BookingInfos createWSBookingInfos(Integer nbrMasterBookings, Integer nbrBookings) {
        WS02_BookingInfo.BookingInfos bookingInfos = new WS02_BookingInfo.BookingInfos();
        List<BookingInfo> lstBookingInfos = new List<BookingInfo>();
        BookingInfo bookingInfo;
        BookingInfo.MasterBookingWrapper masterBookingWrapper;
        List<BookingInfo.BookingWrapper> lstBookingWrapper;
        List<BookingRoomLine> lstBookingRoomLines;
        BookingInfo.BookingWrapper bookingWrapper;
        for(Integer i = 0 ; i < nbrMasterBookings ; i++) {
            bookingInfo = new BookingInfo();
            masterBookingWrapper = new BookingInfo.MasterBookingWrapper();
            masterBookingWrapper.MasterBooking = createWSMasterBooking(i);
            lstBookingWrapper = new List<BookingInfo.BookingWrapper>();
            lstBookingRoomLines = new List<BookingRoomLine>();
            for(Integer j = 0 ; j < nbrBookings ; j++) {
                bookingWrapper = new BookingInfo.BookingWrapper();
                bookingWrapper.Booking = createWSBooking(j, null, null, null);
                for(Integer k = 0 ; k < nbrBookings; k++) {
                    lstBookingRoomLines.add(createWSBookingRoomLine(k, bookingWrapper.Booking.ExternalId));
                }
                bookingWrapper.BookingRoomLines = lstBookingRoomLines;
                lstBookingWrapper.add(bookingWrapper);
            }
            
            masterBookingWrapper.BookingWrapper =  lstBookingWrapper; 
            bookingInfo.MasterBookingWrapper = masterBookingWrapper;
            lstBookingInfos.add(bookingInfo);         
        }
        
        bookingInfos.BookingInfo = lstBookingInfos;
        return bookingInfos;
    }
    
    private static MasterBooking createWSMasterBooking(Integer index) {
        MasterBooking masterBooking = new MasterBooking();
        masterBooking.BusinessLead = 'Lead ' + index;
        masterBooking.Channel = 'Channel ' + index;
        masterBooking.ChannelDescription = 'Channel ' + index;
        masterBooking.ClientFK = 'Client ' + index;
        masterBooking.CloseDate = Date.today().addMonths(1);
        masterBooking.Distribution = 'Distribution ' + index;
        masterBooking.Email = 'obk.georges@gmail.com';
        masterBooking.ExternalId = 'Master Booking ' + index;
        masterBooking.FirstName = 'Georges';
        masterBooking.LastName = 'Hobeika' ;
        masterBooking.Language = 'EN'; 
        masterBooking.Name = 'Master Booking ' + index;
        masterBooking.NbrOfAdults = 2;
        masterBooking.NbrOfChildren = 2;
        masterBooking.Source = 'Source ' + index;
        masterBooking.StageName = 'Checked';
        masterBooking.FieldsToNull = 'Contact,MinArrival,MaxDeparture,MobilePhoneNumber,PersonAccount,PhoneNumber,InvoicedCityTax';
        return masterBooking;
    }
    
    public static WS02_BookingInfo.MasterBookings createWSBookingInfoMasterBookings(Integer nbrMasterBookings) {
        WS02_BookingInfo.MasterBookings masterBookings = new WS02_BookingInfo.MasterBookings();
        List<MasterBooking> lstMasterBookings = new List<MasterBooking>();
        for(Integer i = 0; i < nbrMasterBookings; i++) { 
            lstMasterBookings.add(createWSMasterBooking(i));
        }
        masterBookings.MasterBooking = lstMasterBookings;
        return masterBookings;
    }
    
    public static WS02_BookingInfo.PersonAccounts createWSPersonAccounts(Integer nbrPersonAccounts) {
        WS02_BookingInfo.PersonAccounts personAccounts = new WS02_BookingInfo.PersonAccounts();
        List<PersonAccount> lstPersonAccount = new List<PersonAccount>();
        PersonAccount personAccount;
        for(Integer i = 0; i < nbrPersonAccounts; i++) {
            personAccount = new PersonAccount();
            personAccount.PersonBirthdate = Date.today().addYears(25); 
            personAccount.CustomerId = 'C12345';
            personAccount.DateOfEClubPurchase = Date.today().addYears(-1);
            personAccount.DeclarativeFavoriteHotel = 'B&B';
            personAccount.DeclarativeFavoriteRoomType = 'Double';
            personAccount.DeclarativeFavoritesOptionType = 'OPType';
            personAccount.DeclarativeFavortiesRestaurants = 'RD';
            personAccount.DeclarativePassion = 'Coding';
            personAccount.DeclarativePreferenceLanguage = 'EN';
            personAccount.DeclarativesFavoritesCities = 'Paris';
            personAccount.EClubCardNumber = 'EC123';
            personAccount.EClubExpirationDate = Date.today().addYears(1);
            personAccount.EClubNumberOfPoints = 1200;
            personAccount.Email = 'obk.georges@gmai.com';
            personAccount.EmailAddress2 = 'Beirut Lebanon';
            personAccount.ExternalId = 'guest_account_' + i;
            personAccount.FirstName = 'isitor';
            personAccount.Language = 'EN';
            personAccount.LastName = 'visitor';
            personAccount.Nationality = 'LB';
            personAccount.NumberOfChildren = 12;
            personAccount.Username = 'obk.georges@gmail.com';
            personAccount.HasAWebAccount = false;
            personAccount.BillingCity = 'Paris';
            personAccount.BillingCountry = 'FR'; 
            personAccount.AdditionToAddress = 'Paris Le-Valloit';
            personAccount.FieldsToNull = 'CurrentCompany,Fax,AuthorizedLogeCard,CompanyDeclarative,EClubCreationChannel,EClubSubscription,FavoriteRoomTypeLabel,FavoritesOption1Label,FavoritesOption2,FavoritesOption2Label,FavoritesOption3,FavoritesOption3Label,'+
                'LevelEClubStatus,LifeCycleStatus,LoyaltySubscription,PersonMailingCity,PersonMailingCountry,PersonMailingState,PersonMailingStreet,PersonMailingPostalCode,MaritalStatus,PersonMobilePhone,MobilePhoneNumber2,' +
                'NationalCardId,OptinBHotelsPartners,OptinCountry,OptinCreditCardStorage,OptinGoogleCalendar,OptinGroup,PersonOtherPhone,Passions,PersonalFiscalCode,Salutation,SubscriptionSatatus,BillingState,BillingStreet,' +
                'BillingPostalCode,OptinPartner,BillingCompanyName,LoyaltyCountryCode,OptinBB';
            lstPersonAccount.add(personAccount);
        }
        personAccounts.PersonAccount = lstPersonAccount;
        return personAccounts;
    }
    
    static BookingRoomLine createWSBookingRoomLine(Integer i, String bookingExternalId) {
        BookingRoomLine bookingRoomLine = new BookingRoomLine();
        bookingRoomLine.ExternalId = 'BookingRoomLine_' + i;
        bookingRoomLine.Arrival = Date.today();
        bookingRoomLine.BookingSource = 'B&BFrance';
        bookingRoomLine.BusinessLead = 'meta';
        bookingRoomLine.ChannelCategory = 'channel';
        if(bookingExternalId != null) {
            bookingRoomLine.Booking = bookingExternalId;  
        }        
        bookingRoomLine.CheckInDate = Date.today();
        bookingRoomLine.CheckOutDate = Date.today().addDays(5);
        bookingRoomLine.ChildrenAges= '12';
        bookingRoomLine.CountPromotionNight= 1;
        bookingRoomLine.Departure= Date.today().addDays(5);
        bookingRoomLine.DistributionMode= 'distribution';
        bookingRoomLine.HotelRoomCodeOption= '';
        bookingRoomLine.IsRateIncluded= false;
        bookingRoomLine.NumberOfAdults= 2;
        bookingRoomLine.NumberOfChildren= 2;
        bookingRoomLine.PMSArticleCode= 'pms';
        bookingRoomLine.PMSLineId= 'lineId';
        bookingRoomLine.Price= 30;
        bookingRoomLine.PriceEuro= 28;
        bookingRoomLine.PromotionCode = '12345';
        bookingRoomLine.Quantity= 1;
        bookingRoomLine.RoomCode= 'R123';
        bookingRoomLine.StayPrice= 50;
        bookingRoomLine.FieldsToNull= 'TVARateAndPrice';
        return bookingRoomLine;
    }
    public static WS02_BookingInfo.BookingRoomLines createWSBookingInfoBookingRoomLines(Integer nbrBookingRoomLines) {
        List<Account> lstGuestAccounts = createGuestAccounts(1);
        insert lstGuestAccounts;
        List<Opportunity> lstBookings = createBusinessBookings(nbrBookingRoomLines, lstGuestAccounts);        
        WS02_BookingInfo.BookingRoomLines bookingRoomLines = new WS02_BookingInfo.BookingRoomLines();
        List<BookingRoomLine> lstBookingRoomLine = new List<BookingRoomLine>();
        BookingRoomLine bookingRoomLine;
        for(Integer i = 0; i < nbrBookingRoomLines; i++) {
            lstBookingRoomLine.add(createWSBookingRoomLine(i, lstBookings.get(0).ExternalId__c));
        }
        bookingRoomLines.BookingRoomLine = lstBookingRoomLine;
        return bookingRoomLines;
    }

}