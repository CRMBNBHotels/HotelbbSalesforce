/**
* 
* @version 06/08/2019
* @author TMA-EI - CKH
* @CodeCoverage 100%
*/

@isTest
public class AP07_Account_Test {

    public static testMethod void trackHistory()
    {
        Hotel__c hot1 = new Hotel__c();
        hot1.Hotel_ID__c = 'hotel_1';
        hot1.Country__c = 'FR';
        hot1.Hotel_ID__c = '4504';
        insert hot1;
        
        Hotel__c hot2 = new Hotel__c();
        hot2.Hotel_ID__c = 'hotel_2';
        hot2.Country__c = 'FR';
        hot2.Hotel_ID__c = '4713';
        insert hot2;

		List<Account> lstToInsert = new List<Account>();
        
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        PartnerAccount.Hotelid_club_subscription__c = '4504';
		lstToInsert.add(PartnerAccount);  
        
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id);
        PersonAccount.Hotelid_club_subscription__c = '4713';
		lstToInsert.add(PersonAccount);
        
        insert lstToInsert; 
        
        test.starttest();
        PartnerAccount.Hotelid_club_subscription__c = '4713345';
        update PartnerAccount;
        test.stoptest();
    }
}