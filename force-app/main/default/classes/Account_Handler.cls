/*
* @Author: TMA-EI PG
* @Description: Handle the parameters that the method will use
* @Date: 13/09/2019
* @Test class: 
* @Coverage: Account_Handler_Test
*/

public without sharing class Account_Handler {
    
    public static void handle(List<Account> listAcc,map<Id,Account> mapOldAcc)
    {
        system.debug('@@@ handle');
        system.debug('trigger new ' + listAcc);
        system.debug('trigger old ' + mapOldAcc);
        List<Account> listFilteredAccountsEClubStatus=new List<Account>();
      if(listAcc!=null &&listAcc.size()>0)
        {
            for(Account acc:listAcc)
            {
                if(mapOldAcc==null || (acc.E_club_Expiration_date__pc != mapOldAcc.get(acc.id).E_club_Expiration_date__pc)){
                listFilteredAccountsEClubStatus.add(acc);
                }
            }
        }
        
        if(listFilteredAccountsEClubStatus!=null && listFilteredAccountsEClubStatus.size()>0)
        {
            AP08_Account.checkEClubStatus(listFilteredAccountsEClubStatus, mapOldAcc);
        }
        
    }
}