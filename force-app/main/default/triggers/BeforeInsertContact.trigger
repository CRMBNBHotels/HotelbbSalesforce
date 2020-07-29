trigger BeforeInsertContact on Contact (before insert) {
 List<Contact> Listcont = new List<Contact>();
    for(Contact cont : Trigger.new ){
        if(cont.MobilePhone!=null)
        {
            Listcont.add(cont);
        }
    }
    if(Listcont!=null && Listcont.size()>0)
    {
        Ap01_Contact.MAJMobileCountryCode(Listcont);
    }
}