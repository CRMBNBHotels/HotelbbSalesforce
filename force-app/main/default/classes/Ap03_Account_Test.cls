@isTest
public class Ap03_Account_Test {
 private static testMethod void UpdateAccount()
    {
 
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        insert PartnerAccount;  
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id);
        PersonAccount.PersonMobilePhone='+33 444';
        insert PersonAccount;
        PersonAccount.PersonMobilePhone='+213 444';
         update PersonAccount;
    }   
}