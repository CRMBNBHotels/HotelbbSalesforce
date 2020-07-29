/*
* Description: Handle the parameters that the method will use
* @author: TMA-EI PG
* @date: 13/09/2019
* @Test class: 
* @Coverage: 
*/

public class Account_Handler {
    public static void handle(List<Account> listAcc,map<Id,Account> mapOldAcc)
    {
        List<Account> listFilteredAccountsEClubStatus=new List<Account>();
        if(listAcc!=null && mapOldAcc!=null && listAcc.size()>0 && mapOldAcc.size()>0){
            for(Account acc:listAcc)
            {
                //CRMSS-276
                    listFilteredAccountsEClubStatus.add(acc);
                
            }
            
        }
        else if(mapOldAcc==null && listAcc!=null &&listAcc.size()>0)
        {
            for(Account acc:listAcc)
            {
                listFilteredAccountsEClubStatus.add(acc);
            }
        }
        
        if(listFilteredAccountsEClubStatus!=null && listFilteredAccountsEClubStatus.size()>0)
        {
            AP08_Account.checkEClubStatus(listFilteredAccountsEClubStatus, mapOldAcc);
        }
        
    }
}