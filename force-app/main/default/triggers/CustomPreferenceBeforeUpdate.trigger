trigger CustomPreferenceBeforeUpdate on Custom_Preference__c (before update) {
	//TMABNB-JK-55
    AP01_SObject.UpdateFromSalesforce(trigger.new);
}