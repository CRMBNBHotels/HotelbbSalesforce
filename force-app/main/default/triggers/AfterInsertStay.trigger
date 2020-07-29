trigger AfterInsertStay on Stay__c (after insert) {
    if(PAD.canTrigger('AfterInsertStay')){
        AP01_Stay.UpdateTypeAccount(trigger.New , null,null);
        //Removed for deployement on prod 2668
        //AP02_Stay.UpdateTotalNightsTotalRevenueFavoriteHotel(trigger.New , null,null);  
        AP05_Stay.UpdateMaxBookingMinArrival(trigger.New , null,null);
        AP06_Stay.calculateFavorites(trigger.New,null, null);
        AP07_Stay.UpdateCountryPercentages(trigger.New,null, null);
        
        //Added for deployement on prod 2668
         AP02_Stay.UpdateTotalNights(trigger.New , null,null);
    	AP03_Stay.UpdateTotalRevenue(trigger.New ,null, null);
    	AP04_Stay.UpdateFavoriteHotel(trigger.New ,null, null);
    }
    
}