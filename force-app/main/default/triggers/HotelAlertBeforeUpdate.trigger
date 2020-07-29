trigger HotelAlertBeforeUpdate on Hotel_Alert__c (before update) {
	//TMABNB-JK-55
 	 AP01_SObject.UpdateFromSalesforce(trigger.new);
}