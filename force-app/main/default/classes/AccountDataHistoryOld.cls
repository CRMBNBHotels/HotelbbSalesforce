public class AccountDataHistoryOld {
    public AccountDataHistory.CustomerType customerType;
    public AccountDataHistory.CountryPercentage countryPercentage;
    public Map<Id, AccountDataHistory.Night> mapBookingNight; 
    public Map<Id, AccountDataHistory.Revenue> mapBookingRevenue;
    public Integer totalNights;
    public decimal totalRevenue;
    public AccountDataHistoryOld() {
        customerType = new AccountDataHistory.CustomerType();
        countryPercentage = new AccountDataHistory.CountryPercentage();
        totalRevenue = 0;
        mapBookingNight = new Map<Id, AccountDataHistory.Night>();
        mapBookingRevenue = new Map<Id, AccountDataHistory.Revenue>();
        totalNights = 0;
    }
    public static AccountDataHistoryOld parse(String json) {
        return (AccountDataHistoryOld) System.JSON.deserialize(json.unescapeHtml4(), AccountDataHistoryOld.class);
    }
    
}