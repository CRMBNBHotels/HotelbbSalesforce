global without sharing class BookingRoomLine {
    
    webservice String ExternalId;
    webservice Date Arrival;
    webservice String Booking;
    webservice String RoomLineParent;
    webservice String BookingSource;
    webservice String BusinessLead;
    webservice String ChannelCategory;
    webservice DateTime CheckInDate;
    webservice Date CheckOutDate;
    webservice String ChildrenAges;
    webservice Integer CountPromotionNight;
    webservice Date Departure;
    webservice String DistributionMode;
    webservice String HotelRoomCodeOption;
    webservice boolean IsRateIncluded;
    webservice Integer NumberOfAdults;
    webservice Integer NumberOfChildren;
    webservice String PMSArticleCode;
    webservice String PMSLineId;
    webservice double Price;
    webservice double PriceEuro;
    webservice String PromotionCode;
    webservice Integer Quantity;
    webservice String RoomCode;
    webservice double StayPrice;
    webservice double TVARateAndPrice;
    webservice String FieldsToNull;
    webservice boolean Obsolete;
    
    public Booking_Room_Line__c mapSFFields() {
        Booking_Room_Line__c bookingRoomLine = new Booking_Room_Line__c();
        Set<String> setFieldsToNull = new Set<String>();
        if(String.isNotBlank(FieldsToNull)) {
            for(String field : FieldsToNull.split(',')) {
                setFieldsToNull.add(field);
            }
        }
        
        if(String.isNotBlank(ExternalId) || setFieldsToNull.contains('ExternalId')) {
            bookingRoomLine.ExternalId__c = ExternalId;
        }
        if(Arrival != null || setFieldsToNull.contains('Arrival')) {
            bookingRoomLine.Arrival__c = Arrival;
        }
        if(String.isNotBlank(Booking) || setFieldsToNull.contains('Booking')) {
            if(Booking != null) {
                Opportunity bookingObj = new Opportunity(ExternalId__c = Booking);
                bookingRoomLine.Booking_FK__r = bookingObj;
            } else if(setFieldsToNull.contains('Booking')) {
                bookingRoomLine.Booking_FK__c = null;
            }
            
        }
        if(String.isNotBlank(RoomLineParent) || setFieldsToNull.contains('RoomLineParent')) {
            //bookingRoomLine.Booking_Room_Line_Parent__c = RoomLineParent; Removed by TMA-EI - JK - CRMSS - 173
            //Added by TMA-JK - CRMSS-173 Start
            if(String.isNotBlank(RoomLineParent)) {
                Booking_Room_Line__c bookingRLObj = new Booking_Room_Line__c(ExternalId__c = RoomLineParent);
                bookingRoomLine.Booking_Room_Line_Parent__r = bookingRLObj;    
            } else if(setFieldsToNull.contains('RoomLineParent')) {
                bookingRoomLine.Booking_Room_Line_Parent__c = null;
            }
            //Added by TMA-JK - CRMSS-173 End
        }
         if(Obsolete != null || setFieldsToNull.contains('Obsolete')) {
            bookingRoomLine.Obsolete__c = Obsolete;
        }
        if(String.isNotBlank(BookingSource) || setFieldsToNull.contains('BookingSource')) {
            bookingRoomLine.BookingSource__c = BookingSource;
        }
        if(String.isNotBlank(BusinessLead) || setFieldsToNull.contains('BusinessLead')) {
            bookingRoomLine.BuinessLead__c = BusinessLead;
        }
        if(String.isNotBlank(ChannelCategory) || setFieldsToNull.contains('ChannelCategory')) {
            bookingRoomLine.ChannelCategory__c = ChannelCategory;
        }
        if(CheckInDate != null || setFieldsToNull.contains('CheckInDate')) {
            bookingRoomLine.CheckInDate__c = CheckInDate;
        }
        if(CheckOutDate != null || setFieldsToNull.contains('CheckOutDate')) {
            bookingRoomLine.CheckoutDate__c = CheckOutDate;
        }
        if(String.isNotBlank(ChildrenAges) || setFieldsToNull.contains('ChildrenAges')) {
            bookingRoomLine.Children_ages__c = ChildrenAges;
        }
        if(CountPromotionNight != null || setFieldsToNull.contains('CountPromotionNight')) {
            bookingRoomLine.Count_Promotion_Night__c = CountPromotionNight;
        }
        if(Departure != null || setFieldsToNull.contains('Departure')) {
            bookingRoomLine.Departure__c = Departure;
        }
        if(String.isNotBlank(DistributionMode) || setFieldsToNull.contains('DistributionMode')) {
            bookingRoomLine.DistributionMode__c = DistributionMode;
        }
        
        /*Commented by TMA-EIL CG CRMSS-448 23/01/2020 Start
        if(String.isNotBlank(HotelRoomCodeOption) || setFieldsToNull.contains('HotelRoomCodeOption')) {
            bookingRoomLine.Hotel_Room_Code_Option__c = HotelRoomCodeOption;
        }
        Commented by TMA-EIL CG CRMSS-448 23/01/2020 End*/
        
        if(IsRateIncluded != null || setFieldsToNull.contains('IsRateIncluded')) {
            bookingRoomLine.Is_Rate_Included__c = IsRateIncluded;
        }
        if(NumberOfAdults != null || setFieldsToNull.contains('NumberOfAdults')) {
            bookingRoomLine.Number_of_adults__c = NumberOfAdults;
        }
        if(NumberOfChildren != null || setFieldsToNull.contains('NumberOfChildren')) {
            bookingRoomLine.Number_of_children__c = NumberOfChildren;
        }
        if(String.isNotBlank(PMSArticleCode) || setFieldsToNull.contains('PMSArticleCode')) {
            bookingRoomLine.PMS_Article_Code__c = PMSArticleCode;
        }
        if(String.isNotBlank(PMSLineId) || setFieldsToNull.contains('PMSLineId')) {
            bookingRoomLine.PMS_Line_ID__c = PMSLineId;
        }
        if(Price != null || setFieldsToNull.contains('Price')) {
            bookingRoomLine.Price__c = Price;
        }
        if(PriceEuro != null || setFieldsToNull.contains('PriceEuro')) {
            bookingRoomLine.Price_Euros__c = PriceEuro;
        }
        if(String.isNotBlank(PromotionCode) || setFieldsToNull.contains('PromotionCode')) {
            bookingRoomLine.Promotion_Code__c = PromotionCode;
        }
        if(Quantity != null || setFieldsToNull.contains('Quantity')) {
            bookingRoomLine.Quantity__c = Quantity;
        }
        if(String.isNotBlank(RoomCode) || setFieldsToNull.contains('RoomCode')) {
            bookingRoomLine.Room_code__c = RoomCode;
        }
        if(StayPrice != null || setFieldsToNull.contains('StayPrice')) {
            bookingRoomLine.Stay_Price__c = StayPrice;
        }
        if(TVARateAndPrice != null || setFieldsToNull.contains('TVARateAndPrice')) {
            bookingRoomLine.TVA_Rate_and_Price__c = TVARateAndPrice;
        }
        return bookingRoomLine;
    }
    
}