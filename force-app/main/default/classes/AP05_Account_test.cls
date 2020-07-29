@isTest
public class AP05_Account_test {
    private static testMethod void UpdateAccount()
    {
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null); 
        insert PartnerAccount; 
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id);
        PersonAccount.PersonMobilePhone='+33 444';
        PersonAccount.E_Club_Status__c = 'Valid';
        PersonAccount.E_club_Expiration_date__pc = date.today().adddays(-3);
        insert PersonAccount;
        PersonAccount.E_Club_Status__c = 'Valid';
        PersonAccount.FirstName = 'test name update';
        PersonAccount.lastname = 'test name update';
        //PersonAccount.Email__pc = 'Email@testUpdate.com';
        //PersonAccount.E_mail_address_2__pc = 'Email@testUpdate.com';
        PersonAccount.PersonMobilePhone = '+33 123';
        PersonAccount.Mobile_Phone_Number_2__pc = '+33 123';
        PersonAccount.PersonMailingCity = 'GUIPAVAS';
        PersonAccount.E_Club_Status__c = 'Valid';
        PersonAccount.E_club_Expiration_date__pc = date.today();
        PersonAccount.PersonMailingCountry = 'France';
        //PersonAccount.PersonMailingState = 'Nouvelle-Aquitaine';
        PersonAccount.PersonMailingPostalCode = '29490';
        PersonAccount.PersonMailingStreet = '75 rue Jansen';
        //Added by TMA JKA - CRMSS 328 - 18/10/2019
        PersonAccount.Externalid__c='123';
        update PersonAccount;
    }
    
}