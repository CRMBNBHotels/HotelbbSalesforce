/**
* 
* @version 1.00 06/12/2017
* @author Jenny Jawhar
* @CodeCoverage 92%
*/
@isTest
public class AP02_Opportunity_Test {
    public static testMethod void updateDeleteBooking()
    {
        //insert person account
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);                      
        insert PersonAccount;
        //insert bookings
        list<Opportunity> listBookingToInsert = new list<Opportunity>();
        Opportunity opp1 = Utils.CreateBookingOpportunity('Booking1');                 
        opp1.StageName=Label.StatusChecked; 
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
      
        opp1.Min_Arrival__c = date.Today();
        opp1.Trip_Context__c = label.BusinessCustomerType;
        update opp1;
        delete opp2;
    }
}