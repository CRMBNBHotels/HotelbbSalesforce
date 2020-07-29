/**
* This class contains the test method to LCC09_GeneratePasswordController
* @version 1.00 13 Jan 2020
* @author TMA
*/
@isTest
private class LCC09_GeneratePasswordController_Test {
    static testMethod void GeneratePassword() {
        
        String Password = LCC09_GeneratePasswordController.GeneratePassword();
        
        list<Account> listAccountToInsert = new list<Account>();
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        Account PartnerAcccount1 = Utils.CreatePartnerAccount('Partner1', null);
        listAccountToInsert.add(PartnerAccount);
        listAccountToInsert.add(PartnerAcccount1);
        insert listAccountToInsert;
        
        list<Contract> listContract = new list<Contract>();
        Contract cont1 = Utils.CreateContract();
        cont1.AccountId = PartnerAccount.Id;
        Contract cont2 = Utils.CreateContract();
        cont2.AccountId = PartnerAccount.Id;  
        listContract.add(cont1);
        listContract.add(cont2);
        insert listContract;
        
         contact cont = new contact();
        cont.AccountId = PartnerAccount.Id;
        cont.LastName='test';
        cont.MobilePhone='+33 777';
        cont.Email = 'Test@email.com';
        insert cont ;
        
        
        List<LCC09_GeneratePasswordController.ContactWrapper> listContWrap = LCC09_GeneratePasswordController.GetListContacts(cont1.Id);
        
        String listContWarpSTR = json.serialize(listContWrap);
        LCC09_GeneratePasswordController.SendEmails(listContWarpSTR,Password);
    }

}