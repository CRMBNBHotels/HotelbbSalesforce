trigger VoucherBeforeDelete on Voucher__c ( before delete) {
    //System.debug('### in delete trigger');
 	//AP04_Voucher.vouchHelper(null, Trigger.oldMap);
}