trigger BeforeUpdateContact on Contact (before update) {
    //TMABNB-JK-55
   // AP01_SObject.UpdateFromSalesforce(trigger.new);
    
    //TMABNB-62
 /*List<Contact> Listcont = new List<Contact>();
    for(Contact cont : Trigger.new ){
        if(cont.MobilePhone!=null && Trigger.oldMap.get(cont.Id).MobilePhone !=cont.MobilePhone )
        {
            Listcont.add(cont);
        }
    }
    if(Listcont!=null && Listcont.size()>0)
    {
        Ap01_Contact.MAJMobileCountryCode(Listcont);
    }*/
}