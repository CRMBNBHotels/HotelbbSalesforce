@isTest
public class AP01_Sobject_Test {
    public static testMethod void InsertUpdateDeleteBookingRoomLine()
    {
        
        //Trigger before update account
        Account Partner = Utils.CreatePartnerAccount('Partner','123');
        Partner.fromSalesforce__c = false;
        insert Partner;
        
        Partner.name = 'Partner 1';
        update Partner;
        
        Account Partner2 = Utils.CreatePartnerAccount('Partner 3','1234');
        Partner2.fromSalesforce__c = false;
        insert Partner2;
        
        Partner.name = 'Partner 2';
        update Partner2;
        
        //Trigger before update contact
        contact cont = new contact();
        cont.LastName='test';
        cont.MobilePhone='+33 777';
        cont.fromSalesforce__c = false;
        insert cont ;
        
        cont.MobilePhone='+32 777';
        update cont;
        
        //Trigger before update contract
        Contract cont1 = Utils.CreateContract();
        cont1.AccountId = Partner.Id;
        cont1.fromSalesforce__c = false;
        insert cont1 ;
        
        cont1.AccountId=Partner2.id;
        update cont1;
        
        //Trigger before update Hotel
        Hotel__c hotel = Utils.CreateHotel('Hotel 1');
        hotel.fromSalesforce__c = false;
        hotel.Email__c = 'hotel1@gmail.com';
        hotel.Country__c = label.FR;
        insert hotel;
        
        hotel.Email__c = 'hotelTest@gmail.com';
        update hotel;
        
        //Trigger before update case
        Case cas = Utils.CreateCase();
        cas.Origin = 'Web';
        cas.Type = label.Information_request;
        cas.Hotel_ID__c = hotel.Hotel_ID__c;
        cas.SuppliedEmail = 'customer1@gmail.com';
        cas.First_Name__c = 'First1';
        cas.Last_Name__c = 'Last1';
        insert cas;
        
        cas.Last_Name__c = 'Last Name';
        update cas;
        
        //Trigger before update Opportunity
        Opportunity opp1 = Utils.CreateBookingOpportunity('B1');                                         
        opp1.Trip_Context__c = Label.BusinessCustomerType;    
        opp1.StageName = label.ClosedWonStage;
        insert opp1;
        
        Opportunity opp2 = Utils.CreateBookingOpportunity('B2');                
        opp2.Trip_Context__c = Label.LeisureCustomerType;
        opp2.StageName = label.ClosedWonStage;
        insert opp2;
        
        opp1.name = 'Test Booking';
        update opp1;
        
        //Trigger before update Stay
        Account testAccount = Utils.CreatePersonAccount('Person', null); 
        insert testAccount;
        
        //Stay__c stay = Utils.CreateStay(testAccount.Id,opp1.Id);
        //insert stay;
        
        //stay.Booking__c = opp2.id;
        //update stay;
        
        
        //Trigger before update Booking Room Line
        Booking_Room_Line__c TestBRL = Utils.CreateBookingRoomLine(opp1.id);
        insert TestBRL;
        
        TestBRL.BookingSource__c = 'Test';
        update TestBRL;
        
        //Trigger before update Booking Room Line Price
        //Booking_Room_Line_Price__c TestBRLP = Utils.CreateBookingRoomLinePrice(TestBRL.id,2);
        //insert TestBRLP;
        
        //TestBRLP.Price__c = 5;
        //update TestBRLP;
        
        
        //Trigger before update Consent
        Consent__c TestConsent = new Consent__c();
        TestConsent.Person_Account__c = testAccount.id;
        insert TestConsent;
        
        TestConsent.Status__c = 'test';
        update TestConsent;
        
        //Trigger before update Custom Preference
        Custom_preference__c TestCP = new Custom_preference__c();
        insert TestCP;
        
        TestCP.Value__c = 'test';
        update TestCP;
        
      
        
        //Trigger before update Hotel Alert 
        Hotel_Alert__c TestHA = new Hotel_Alert__c();
        TestHA.Name = 'Test';
        insert TestHA;
        
        TestHA.Name = 'test 2';
        update TestHA;
        
        //Trigger before update Hotel Alert Junction
        Hotel_Alert_Junction__c TestHAJ = new Hotel_Alert_Junction__c();
        TestHAJ.Hotel__c = hotel.id;
        TestHAJ.Hotel_Alert__c = TestHA.id;
        insert TestHAJ;
        
        TestHAJ.Externalid__c = '112';
        update TestHAJ;
        
        //Trigger before update Hotel room option
        Hotel_Room_Option__c hotelRoomOptionAndCode = Utils.CreateHotelRoomOptionAndCode();
        hotelRoomOptionAndCode.Type_code__c = label.TypeCodeRoom;
        hotelRoomOptionAndCode.Room_code__c = 'R1';
        hotelRoomOptionAndCode.Room_Type__c = 'RT1';
        hotelRoomOptionAndCode.Room_Type_Label__c = label.TypeCodeRoom;
        insert hotelRoomOptionAndCode;
        
        hotelRoomOptionAndCode.Room_Type__c = 'RT2';
        update hotelRoomOptionAndCode;
        
        //Trigger before update Hotel room code junction
        Hotel_Room_code_junction__c hotelRoomCodeJunction = new Hotel_Room_code_junction__c();
        hotelRoomCodeJunction.Hotel__c = hotel.id;
        hotelRoomCodeJunction.Hotel_Room_Code_Option__c = hotelRoomOptionAndCode.id;
        insert hotelRoomCodeJunction;
        
        hotelRoomCodeJunction.Externalid__c = '123';
        update hotelRoomCodeJunction;
         
        //Trigger before update Voucher
        Voucher__c TestVoucher = new Voucher__c();
        insert TestVoucher;
        
        TestVoucher.code__c = 'Voucher';
        update TestVoucher;
        
       /* //TMABNB-116
        //Trigger before update Voucher Catalog
        Voucher_Catalog__c TestVoucherCat = new Voucher_Catalog__c();
        insert TestVoucherCat;
        
        TestVoucherCat.Points__c = 2;
        update TestVoucherCat;
        
        //Trigger before update Voucher Country
        Voucher_Country__c TestVoucherCountry = new Voucher_Country__c();
        insert TestVoucherCountry;
        
        TestVoucherCountry.Holidays__c = true;
        update TestVoucherCountry;
        
        //Trigger before update Prestation
        Prestation__c TestPrest = new Prestation__c();
        insert TestPrest;
        
        TestPrest.Code_Prestation__c = 'test';
        update TestPrest;
        
       
        //Trigger before update Country
        Country__c TestCountry = new Country__c();
        insert TestCountry;
        
        TestCountry.Currency__c = 'AED';
        update TestCountry;
        
        TestLoyaltyCard.E_Club_Card_Number__c = 'test';
        update TestLoyaltyCard;*/
    }
}