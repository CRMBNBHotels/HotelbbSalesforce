/*
* Calculate the number of contracts on an account
* @author: Jenny Jawhar
* @date: 2/10/2017
* @Test: AP01_Contract_Test
*/
public without sharing class AP01_Contract 
{
    public static void UpdateNumberOfContracts(list<Contract> newContracts,Map<Id,Contract> oldMap,
                                               list<Contract> oldContracts)
    {
        list<Id> listAccountId = new list<Id>();
        if(newContracts != null)
        {
            for(Contract con: newContracts)
            {
                if(oldMap==null || oldMap.get(con.Id).AccountId!=con.AccountId)
                {
                   listAccountId.add(con.AccountId);
                }
                 if(oldMap!=null && oldMap.get(con.Id).AccountId!=con.AccountId)
                {  
                   listAccountId.add(oldMap.get(con.Id).AccountId);
                }
            }
        }
        else
        {
            for(Contract con: oldContracts)
            {
                listAccountId.add(con.AccountId);
            }
        }
        if(listAccountId.Size() > 0)
        {
            list<Account> listAccToUpdate = new list<Account>();
            list<Account> listSelectedAccount= [Select Id,Number_of_Contracts__c,
                                                (select Id from Contracts)
                                                from Account
                                                where Id IN: ListAccountId];
            for(Account acc: listSelectedAccount)
            {
                list<Contract> listContract = acc.contracts;
                acc.Number_of_Contracts__c = listContract.Size();
                listAccToUpdate.add(acc);
            }
            update listAccToUpdate;
        }
    }
}