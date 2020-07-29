trigger AfterInsertOpportunity on Opportunity (after insert) {
    
    //OpportunityHandler.FilterOpportunity(trigger.new, null);
    
    //gho modifications
   // AP05_Opportunity.doCalculateGuestHistoryField(Trigger.New, null);
    
   
    //if(PAD.canTrigger('AfterInsertOpportunity')){
        //AP03_Opportunity.UpdateTotalNightsPartnerShip(trigger.New ,null, null);
       // AP04_Opportunity.UpdateTotalTransactions(trigger.New ,null, null);
        //Not yet on production
        //AP05_Opportunity.UpdateCountryPercentages(trigger.New ,null, null); 
        
   // }
    
}