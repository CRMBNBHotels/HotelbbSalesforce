trigger VoucherAfterUpdate on Voucher__c (after update) {
    
    // CRMSS-129 Cynthia Geagea TMA
    //AP03_voucher.CallWSUpdateVoucherInfo(trigger.newMap,Trigger.oldMap); 

}