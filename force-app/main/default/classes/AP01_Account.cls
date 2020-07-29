/*
* Update status in order to be equal to the status text (updated via 2 workflows)
* @author: Jenny Jawhar
* @date: 03/10/2017
* @Test: AP01_Account_Test
*/
public without sharing class AP01_Account 
{
    public static void UpdateStatus(List<Account> triggerNew,Map<Id,Account> oldMap)
    {
        system.debug('@@@ UpdateStatus');
        list<Account> listAccount = new list<Account>();
        for(Account acc: triggerNew)
        {
            if(oldMap.get(acc.Id).Status_Text__c != acc.Status_Text__c)
            {
                listAccount.add(acc);
            }
        }
        if(listAccount.Size() > 0)
        {
            list<Account> listAccToUpdate = new list<Account>();
            for(Account acc:listAccount)
            {
                if(!acc.IsPersonAccount)
                {
                    acc.Status__c = acc.Status_Text__c;  
                }
                else
                {
                    acc.Lifecycle_status__pc = acc.Status_Text__c;
                }                             
            }        
        }
    }
}