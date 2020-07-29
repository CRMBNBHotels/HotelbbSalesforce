trigger BeforeInsertAccount on Account (before insert) {
    
    // gho modifications
    /* AP04_Account.initializeDataHistoryField(Trigger.new);
Account_Handler.handle(Trigger.new,null);   //TMA EI 9-9-2019 PG 275
List<Account> ListAcc = new List<Account>();
for(account acc : Trigger.new ){
if(acc.PersonMobilePhone!=null)
{
ListAcc.add(acc);
}
}
if(ListAcc!=null && ListAcc.size()>0)
{
// commented by TTA 
// Ap03_Account.MAJMobileCountryCode(ListAcc);
}

AP07_Account.getHotelName(Trigger.new);
*/
}