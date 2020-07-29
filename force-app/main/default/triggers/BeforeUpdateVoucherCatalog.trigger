trigger BeforeUpdateVoucherCatalog on Voucher_Catalog__c (before update) {
    //TMABNB-JK-55
	AP01_SObject.UpdateFromSalesforce(trigger.new);
}