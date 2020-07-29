/**
* 
* @version 1.00 21/12/2017
* @author Jenny Jawhar
* @CodeCoverage 93%
*/
@isTest
public class AP02_Account_Test 
{
    /*
 public static testMethod void updateDeleteAccount()
    {
        //insert Partner
        Account Partner = Utils.CreatePartnerAccount('Partner','123');
        insert Partner;
        Account Partner1 = Utils.CreatePartnerAccount('Partner1','1234');
        insert Partner1;
        //insert person account
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);                      
        insert PersonAccount;
        Account PersonAccount1 =  Utils.CreatePersonAccount('Person1', Partner.Id);                      
        insert PersonAccount1;
        //insert Master Booking
        Opportunity MB1 = Utils.CreateMasterBookingOpportunity('MB1', PersonAccount.Id);
        insert MB1;
        Opportunity MB2 = Utils.CreateMasterBookingOpportunity('MB1', PersonAccount1.Id);
        insert MB2;
        //insert bookings
        list<Opportunity> listBookingToInsert = new list<Opportunity>();
        Opportunity opp1 = Utils.CreateBookingOpportunity('Booking1');                 
        opp1.StageName=Label.StatusChecked; 
        opp1.Master_Booking_FK__c = MB1.Id;
        listBookingToInsert.add(opp1);
        Opportunity opp2 = Utils.CreateBookingOpportunity('Booking2');
        opp2.StageName=label.StatusChecked;
        listBookingToInsert.add(opp2);
        insert listBookingToInsert;
        
        list<Stay__c> listStayToInsert = new list<Stay__c>();
        Stay__c stay1 = Utils.CreateStay(PersonAccount.Id,opp1.Id);
        listStayToInsert.add(stay1);
        Stay__c stay2 = Utils.CreateStay(PersonAccount.Id,opp2.Id);
        listStayToInsert.add(stay2);
        insert listStayToInsert;
      
        test.startTest();
        PersonAccount.Current_Compagny__pc = Partner.Id;
        update PersonAccount;
        PersonAccount.Current_Compagny__pc = Partner1.Id;
        update PersonAccount;
        delete PersonAccount;
        test.stopTest();
    }
*/
}