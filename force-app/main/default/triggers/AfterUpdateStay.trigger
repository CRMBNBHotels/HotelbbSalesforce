trigger AfterUpdateStay on Stay__c (after update) {
    if(PAD.canTrigger('AfterUpdateStay')){
        AP01_Stay.UpdateTypeAccount(trigger.New , trigger.oldMap,trigger.old);
        //Removed for deployement on prod 2668
        //AP02_Stay.UpdateTotalNightsTotalRevenueFavoriteHotel(trigger.New , trigger.oldMap,trigger.old);  
        AP05_Stay.UpdateMaxBookingMinArrival(trigger.New , trigger.oldMap,trigger.old);
        AP06_Stay.calculateFavorites(trigger.New,trigger.oldMap, trigger.old);
        AP07_Stay.UpdateCountryPercentages(trigger.New,trigger.oldMap, trigger.old);
        
        //Added for deployement on prod 2668
         AP02_Stay.UpdateTotalNights(trigger.New , trigger.oldMap,trigger.old);
    AP03_Stay.UpdateTotalRevenue(trigger.New , trigger.oldMap,trigger.old);
    AP04_Stay.UpdateFavoriteHotel(trigger.New , trigger.oldMap,trigger.old);
    }
}