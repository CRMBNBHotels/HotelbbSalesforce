trigger BeforeUpdatePrestation on Prestation__c (before update) {
    //TMABNB-JK-55
	AP01_SObject.UpdateFromSalesforce(trigger.new);
}