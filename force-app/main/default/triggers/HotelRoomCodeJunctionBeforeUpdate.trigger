trigger HotelRoomCodeJunctionBeforeUpdate on Hotel_Room_code_junction__c (before update) {
	//TMABNB-JK-55
 	 AP01_SObject.UpdateFromSalesforce(trigger.new);
}