/*
* Update contact Name with Person Account Name When I enter the account Name
* @author: Jenny Jawhar
* @date: 07/12/2017
* @Test: AP02_Case_Test
*/
public without sharing class AP02_Case 
{
    public static void UpdateContactNameWithPersonAccount(list<Case> triggerNew, map<Id,Case> oldMap)
    {
        system.debug('@@@ ap02 in UpdateContactNameWithPersonAccount');
        list<Case> listCase = new list<Case>();
        list<Case> listSelectedCase = [Select Id,Account.IsPersonAccount,Account.PersonContactId,AccountId
                                       From Case
                                       Where Id IN: triggerNew];
        for(Case cas: listSelectedCase)
        {
            if(!string.isBlank(cas.AccountId) && (oldMap==null || cas.AccountId != oldMap.get(cas.Id).AccountId))
            {
                listCase.add(cas);
            }
        }
        if(listCase.size() > 0)
        {
            list<Case> listCaseToUpdate = new list<Case>();
            for(Case cas:listCase)
            {
                if(cas.Account.IsPersonAccount)
                {
                    cas.ContactId = cas.Account.PersonContactId;
                }
                listCaseToUpdate.add(cas);
            }
            update listCaseToUpdate;
        }
    }
}