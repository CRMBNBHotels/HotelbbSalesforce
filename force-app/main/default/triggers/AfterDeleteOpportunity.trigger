trigger AfterDeleteOpportunity on Opportunity (after delete) {
    
    //OpportunityHandler.FilterOpportunity(null, trigger.oldMap);
    // gho modifications
   // if(!System.isBatch()) {
      //  AP05_Opportunity.doCalculateGuestHistoryField(Trigger.Old, null);
   // }
    
    //if(PAD.canTrigger('AfterDeleteOpportunity')){
        // AP03_Opportunity.UpdateTotalNightsPartnerShip(null, trigger.oldMap,trigger.old);  
       // AP04_Opportunity.UpdateTotalTransactions(null, trigger.oldMap,trigger.old);
        //AP05_Opportunity.UpdateCountryPercentages(null, trigger.oldMap,trigger.old);
        
  //  }
    
    
}