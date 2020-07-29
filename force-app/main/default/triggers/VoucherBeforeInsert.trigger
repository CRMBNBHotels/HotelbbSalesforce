trigger VoucherBeforeInsert on Voucher__c (before insert) {
 	//AP01_Voucher.FillInvitationInformationOnCreation(Trigger.new);
   // AP04_Voucher.vouchHelper(Trigger.new, null);
}