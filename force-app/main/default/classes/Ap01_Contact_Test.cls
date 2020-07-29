@isTest
public class Ap01_Contact_Test {
private static testMethod void UpdateAccount()
    {
 
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        insert PartnerAccount;  
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id); 
        insert PersonAccount; 
        contact cont = new contact();
        cont.LastName='test';
        cont.MobilePhone='+33 777';
        insert cont ;
        cont.MobilePhone='+1 672345';
        update cont;
        delete cont;
        undelete cont;
         
    }
}