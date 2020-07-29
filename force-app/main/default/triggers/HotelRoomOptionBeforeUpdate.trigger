trigger HotelRoomOptionBeforeUpdate on Hotel_Room_Option__c (before update) {
	//TMABNB-JK-55
 	 AP01_SObject.UpdateFromSalesforce(trigger.new);
}