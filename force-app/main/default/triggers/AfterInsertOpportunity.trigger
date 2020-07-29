trigger AfterInsertOpportunity on Opportunity (after insert) {
    
    //OpportunityHandler.FilterOpportunity(trigger.new, null);
    
    //gho modifications
    AP05_Opportunity.doCalculateGuestHistoryField(Trigger.New, null);
    
    //Added by TMA Cynthia Geagea - CRMSS 255 - Start
    //AP09_Opportunity.bookedHotelsCount(Trigger.new, null);
    //Added by TMA Cynthia Geagea - CRMSS 255 - End 
    
    //Added by TMA Cynthia Geagea - CRMSS 249-250-251-252-253-264 - Start
    //AP10_Opportunity.updateMasterBookingStageNameOrConfrmNumb(Trigger.new, null);
    //Added by TMA Cynthia Geagea - CRMSS 249-250-251-252-253-264 - End
   
    if(PAD.canTrigger('AfterInsertOpportunity')){
        //AP03_Opportunity.UpdateTotalNightsPartnerShip(trigger.New ,null, null);
        AP04_Opportunity.UpdateTotalTransactions(trigger.New ,null, null);
        //Not yet on production
        //AP05_Opportunity.UpdateCountryPercentages(trigger.New ,null, null); 
    }
    
}