trigger HotelAlertJunctionBeforeUpdate on Hotel_Alert_Junction__c (before update) {
	//TMABNB-JK-55
 	 AP01_SObject.UpdateFromSalesforce(trigger.new);
}