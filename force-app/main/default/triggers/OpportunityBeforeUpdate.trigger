trigger OpportunityBeforeUpdate on Opportunity (before update) {
    //TMABNB-JK-55
   // if(!AP01_SObject.isFirst)
        AP01_SObject.UpdateFromSalesforce(trigger.new);
    AP08_Opportunity.fillBookingLookups(trigger.new);
}