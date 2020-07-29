/**
* 
* @version 31/07/2019
* @author TMA-EI
* @CodeCoverage 100%
*/

@isTest
public class AP06_Account_Test 
{
 public static testMethod void trackHistory()
    {
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        insert PartnerAccount;  
        
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id);
        insert PersonAccount;
        
        Account  acc = [Select Id,Date_of_e_club_purchase__pc,E_club_Creation_channel__pc ,Hotel_Name__c, status__c
               From Account
               Where Id =: PersonAccount.Id];
		
        system.debug('###acc ' + acc.Hotel_Name__c);
        test.starttest();
        acc.Date_of_e_club_purchase__pc = system.today()+2;
        acc.E_club_Creation_channel__pc = 'Website';
        acc.Hotel_Name__c='Hotel1';
        update acc;
        system.debug('###acc ' + acc.Hotel_Name__c);
        test.stoptest();
    }
}