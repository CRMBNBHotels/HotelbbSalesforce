trigger AfterDeleteStay on Stay__c (after Delete) {
    if(PAD.canTrigger('AfterDeleteStay')){
        AP01_Stay.UpdateTypeAccount(null , trigger.oldMap,trigger.old);
       //Removed for deployement on prod 2668
        // AP02_Stay.UpdateTotalNightsTotalRevenueFavoriteHotel(null , trigger.oldMap,trigger.old);  
        AP05_Stay.UpdateMaxBookingMinArrival(null , trigger.oldMap,trigger.old);
        AP06_Stay.calculateFavorites(null,null, trigger.old);
        AP07_Stay.UpdateCountryPercentages(null,trigger.oldMap, trigger.old);
        
        //Added for deployement on prod 2668
         AP02_Stay.UpdateTotalNights(null , trigger.oldMap,trigger.old);
    AP03_Stay.UpdateTotalRevenue(null, trigger.oldMap,trigger.old);
    AP04_Stay.UpdateFavoriteHotel(null, trigger.oldMap,trigger.old);
    }
}