trigger AfterUpdateOpportunity on Opportunity (after update) {
    
    //OpportunityHandler.FilterOpportunity(trigger.new, trigger.oldMap);
    // gho modifications
   // AP05_Opportunity.doCalculateGuestHistoryField(Trigger.New, Trigger.oldMap);
    
    
    //if(PAD.canTrigger('AfterUpdateOpportunity')){
        //AP02_Opportunity.UpdateStayWhenBookingUpdate(trigger.NewMap,trigger.oldMap);
        
        //AP03_Opportunity.UpdateTotalNightsPartnerShip(trigger.New , trigger.oldMap,trigger.old);  
        //AP04_Opportunity.UpdateTotalTransactions(trigger.New , trigger.oldMap,trigger.old);
        //AP05_Opportunity.UpdateCountryPercentages(trigger.New , trigger.oldMap,trigger.old);
   // }
    
    //Added by JK CRMSS-343
   // AP014_Opportunity.ReCalculateContract(Trigger.new,Trigger.OldMap);
    
}