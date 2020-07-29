trigger OpportunityBeforeInsert on Opportunity (before insert) {
   // AP01_SObject.UpdateFromSalesforce(trigger.new);
   AP08_Opportunity.fillBookingLookups(trigger.new);
}