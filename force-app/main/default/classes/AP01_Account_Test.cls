/**
* 
* @version 1.00 3/10/2017
* @author Jenny Jawhar
* @CodeCoverage 100%
*/
@isTest
public class AP01_Account_Test 
{
    private static testMethod void UpdateAccount()
    {
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        insert PartnerAccount;  
        
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id);
        insert PersonAccount;
        
        Contract cont = Utils.CreateContract();
        cont.AccountId = PartnerAccount.Id;
        insert cont;      
        
        Opportunity booking = Utils.CreateBookingOpportunity('Booking');
        booking.StageName = label.StatusChecked;
        booking.Min_Arrival__c = date.Today();
        insert booking;
        //Stay__c stay = Utils.CreateStay(PersonAccount.Id, booking.Id);
        //insert stay;
        Account acc = [Select Id,Status__c,Status_Text__c
                       From Account
                       Where Id =: PartnerAccount.Id];    
        system.assertEquals(acc.Status_Text__c, acc.Status__c);
        acc = [Select Id,Lifecycle_status__pc,Status_Text__c
               From Account
               Where Id =: PersonAccount.Id];
        system.assertequals(acc.Status_Text__c,acc.Lifecycle_status__pc);
    }   
}