trigger VoucherBeforeUpdate on Voucher__c (before update) {
    //TMABNB-JK-55
    AP01_SObject.UpdateFromSalesforce(trigger.new);
    AP01_Voucher.FillInvitationInformationOnModification(Trigger.new);
    //AP03_voucher.Voucher_update(trigger.newmap, trigger.oldmap); // line added by jad 15-04-2019
    system.debug('### jka in Trigger update');
    AP04_Voucher.vouchHelper(Trigger.new, Trigger.oldMap);
    
}