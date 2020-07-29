/**
* 
* @version 1.00 2/10/2017
* @author Jenny Jawhar
* @CodeCoverage 100%
*/
@isTest
public class AP01_Contract_Test 
{
    private static testMethod void InsertUpdateDeleteContract()
    {
        list<Account> listAccountToInsert = new list<Account>();
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        Account PartnerAcccount1 = Utils.CreatePartnerAccount('Partner1', null);
        listAccountToInsert.add(PartnerAccount);
        listAccountToInsert.add(PartnerAcccount1);
        insert listAccountToInsert;
         contact cont = new contact();
        cont.AccountId = PartnerAccount.Id;
        cont.LastName='test';
        cont.MobilePhone='+33 777';
        cont.Email = 'Test@email.com';
        insert cont ;
        
        list<Contract> listContract = new list<Contract>();
        Contract cont1 = Utils.CreateContract();
        cont1.AccountId = PartnerAccount.Id;
        Contract cont2 = Utils.CreateContract();
        cont2.AccountId = PartnerAccount.Id;  
        listContract.add(cont1);
        listContract.add(cont2);
        insert listContract;
        
        Account acc=[Select Id,Number_of_Contracts__c
                     From Account
                     Where Id=:PartnerAccount.Id];  
        system.assertEquals(2, acc.Number_of_Contracts__c);
        
        delete(cont1);
        acc=[Select Id,Number_of_Contracts__c
             From Account
             Where Id=:PartnerAccount.Id];  
        system.assertEquals(1, acc.Number_of_Contracts__c);
        cont2.AccountId = PartnerAcccount1.Id;
        update cont2;
    }
}