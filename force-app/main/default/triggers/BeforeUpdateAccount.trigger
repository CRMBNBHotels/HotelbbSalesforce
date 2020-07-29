trigger BeforeUpdateAccount on Account (before update) {
    //TMABNB-JK-55
  /*  AP01_SObject.UpdateFromSalesforce(trigger.new);
    Account_Handler.handle(Trigger.new,Trigger.oldMap);	//TMA EI 9-9-2019 PG 275
    AP01_Account.UpdateStatus(trigger.New,trigger.oldMap); 
    
    //TMABNB-62
     List<Account> ListAcc = new List<Account>();
    for(account acc : Trigger.new ){
        if(acc.PersonMobilePhone!=null && Trigger.oldMap.get(acc.Id).PersonMobilePhone !=acc.PersonMobilePhone )
        {
            ListAcc.add(acc);
        }
    }*/
  /*  if(ListAcc!=null && ListAcc.size()>0)
    {
        Ap03_Account.MAJMobileCountryCode(ListAcc);
    }*/
    //TMABNB CRMSS-96
   /* AP05_Account.StockOldData(trigger.newMap,Trigger.oldMap);
    
    
    AP07_Account.getHotelName(Trigger.new);*/
}