trigger BeforeDeleteOpportunity on Opportunity (before delete) {
	//AP02_Opportunity.getAccountOfStayWhenBookingDelete(trigger.old);
	AP06_Opportunity.forceErrorOnBookingDelete(Trigger.old);
    
}