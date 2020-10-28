public class AccountDataHistory {
    
    public CustomerType customerType;
    public CountryPercentage countryPercentage;
    //public Map<Id, Night> mapBookingNight; 
    //public Map<Id, Revenue> mapBookingRevenue;
    //public Integer totalNights;
    //public decimal totalRevenue;
    
    
    /*public void setTotalNights() {
totalNights = 0;
Integer index = 0;
Night night;
for(Id bookingId : mapBookingNight.keySet()) {
night = mapBookingNight.get(bookingId);
if(night.year == Date.today().Year()) {
totalNights += night.nbrNights;
} else {
mapBookingNight.remove(bookingId);
} 
}
}

public void setTotalRevenue() {
totalRevenue = 0;
Integer index = 0;
Revenue revenue;
for(Id bookingId : mapBookingRevenue.keySet()) {
revenue = mapBookingRevenue.get(bookingId);
if(revenue.year == Date.today().Year()) {
totalRevenue += revenue.bookingRevenue;
} else {
mapBookingRevenue.remove(bookingId);
} 
}
}*/
    
    
    
    public AccountDataHistory() {
        customerType = new CustomerType();
        countryPercentage = new CountryPercentage();
        //totalRevenue = 0;
        //mapBookingNight = new Map<Id, Night>();
        //mapBookingRevenue = new Map<Id, Revenue>();
        //totalNights = 0;
    }
    
    public static AccountDataHistory parse(String json) {
        return (AccountDataHistory) System.JSON.deserialize(json.unescapeHtml4(), AccountDataHistory.class);
    }
    

    public class Night {
        public Integer year{get;set;}
        public Integer nbrNights {get;set;} 
        public Id bookingId {get;set;}
        
        public Night(Integer y, Integer nights, Id bkId) {
            year = y;  nbrNights = nights; bookingId = bkId;
        }
    }
    
    public class Revenue {
        public Integer year{get;set;}
        public decimal bookingRevenue {get;set;} 
        public Id bookingId {get;set;}
        
        public Revenue(Integer y, decimal revenue, Id bkId) {
            year = y;  bookingRevenue = revenue;  bookingId = bkId;
        }
    }
    
    
    public class CustomerType {
        public Integer business;
        public Integer leisure;
        
        public CustomerType() {
            business = 0;
            leisure  = 0;
        }
        
        public void setBusinessType(Integer businessCounter) {
            business += businessCounter;
        }
        
        public void setLeisureType(Integer leisureCounter) {
            leisure += leisureCounter;
        }
        
        public Integer getLeisureType() {
            return leisure;
        }
        
        public Integer getBusinessType() {
            return business;
        }
    }
    
    public class CountryPercentage {
        public Integer france;
        public Integer spain;
        public Integer germany;
        public Integer italy;
        public Integer poland;
        public Integer others;
        public Integer austria; //Added by TMA-EIL CG CRMSS-851 04/09/2020
        
        public CountryPercentage() {
            france = 0;
            spain = 0;
            germany = 0;
            italy = 0;
            poland = 0;
            others = 0; 
            austria = 0;//Added by TMA-EIL CG CRMSS-851 04/09/2020
        }
        
        public void setFrance(Integer franceCounter) {
            france += franceCounter;
        }
        
        public void setSpain(Integer spainCounter) {
            spain += spainCounter;
        }
        
        public void setGermany(Integer germanyCounter) {
            germany += germanyCounter;
        }
        
        public void setItaly(Integer italyCounter) {
            italy += italyCounter;
        }
        
        public void setPoland(Integer polandCounter) {
            poland += polandCounter;
        }
        
        public void setOthers(Integer othersCounter) {
            others += othersCounter;
        }
        
        //Added by TMA-EIL CG CRMSS-851 04/09/2020 Start
        public void setAustria(Integer austriaCounter) {
            austria += austriaCounter;
        }
        //Added by TMA-EIL CG CRMSS-851 04/09/2020 End
    }
    
}