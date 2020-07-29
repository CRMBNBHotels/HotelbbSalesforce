trigger AfterDeleteOpportunity on Opportunity (after delete) {
    
    //OpportunityHandler.FilterOpportunity(null, trigger.oldMap);
    // gho modifications
    if(!System.isBatch()) {
        AP05_Opportunity.doCalculateGuestHistoryField(Trigger.Old, null);
    }
    
    if(PAD.canTrigger('AfterDeleteOpportunity')){
        AP03_Opportunity.UpdateTotalNightsPartnerShip(null, trigger.oldMap,trigger.old);  
        AP04_Opportunity.UpdateTotalTransactions(null, trigger.oldMap,trigger.old);
        //AP05_Opportunity.UpdateCountryPercentages(null, trigger.oldMap,trigger.old);
    }
    
    //Added by TMA Cynthia Geagea - CRMSS 255 - Start
   // AP09_Opportunity.bookedHotelsCount(null, trigger.oldMap);
    //Added by TMA Cynthia Geagea - CRMSS 255 - End 
    
    //Added by TMA Cynthia Geagea - CRMSS 249-250-251-252-253-264 - Start
    //AP10_Opportunity.updateMasterBookingStageNameOrConfrmNumb(null, trigger.oldMap);
    //Added by TMA Cynthia Geagea - CRMSS 249-250-251-252-253-264 - End
    
}