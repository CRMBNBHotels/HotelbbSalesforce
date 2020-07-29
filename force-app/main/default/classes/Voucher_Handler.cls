/*
* @Author: TMA-EI PG
* @Description: Handle the parameters that the method will use
* @Date: 22/01/2020
* @Test class: 
* @Coverage: 
*/

public without sharing class Voucher_Handler {
    
  public static void handle(List<Voucher__c> listVch,map<Id,Voucher__c> mapOldVch)
    {
     /*   system.debug('@@@ handle');
        system.debug('trigger new ' + listVch);
        system.debug('trigger old ' + mapOldVch);
        List<Voucher__c> listFilteredAccountsEClubStatus=new List<Voucher__c>();
      if(listVch!=null &&listVch.size()>0)
        {
            for(Voucher__c vch:listVch)
            {
                if(Acc==null || (vch.E_club_Expiration_date__pc != mapOldVch.get(vch.id).E_club_Expiration_date__pc)){
                listFilteredAccountsEClubStatus.add(vch);
                }
            }
        }
        
        if(listFilteredAccountsEClubStatus!=null && listFilteredAccountsEClubStatus.size()>0)
        {
            AP08_Account.checkEClubStatus(listFilteredAccountsEClubStatus, mapOldVch);
        }
*/        
    }
}