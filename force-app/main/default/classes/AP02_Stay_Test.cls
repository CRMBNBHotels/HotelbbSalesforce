/**
* 
* @version 1.00 01/12/2017
* @author Jenny Jawhar
* @CodeCoverage 91%
*/
@isTest
public class AP02_Stay_Test {
    /*
    private static testMethod void InsertUpdateDeleteStay(){
        //insert Account      
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);      
        insert PartnerAccount;
        Account PersonAccount =  Utils.CreatePersonAccount('Person', PartnerAccount.Id);                      
        insert PersonAccount;
        //insert Opportunities
        List<Opportunity> ListOpp = new List<Opportunity>(); 
        Opportunity opp1 = Utils.CreateBookingOpportunity('B1');            
        opp1.Min_Arrival__c = date.Today();
        opp1.Max_Departure__c = date.Today() + 1;         
        opp1.StageName=Label.StatusChecked; 
        opp1.Trip_Context__c =Label.BusinessCustomerType;
        ListOpp.add(opp1);
        Opportunity opp2 = Utils.CreateBookingOpportunity('B2');            
        opp2.Min_Arrival__c = date.Today();
        opp2.Max_Departure__c = date.Today() + 2;         
        opp2.StageName=Label.StatusChecked; 
        ListOpp.add(opp2);
        insert ListOpp; 
        //insert list of stays
        list<Stay__c> listStay = new list<Stay__c>();
        Stay__c stay1 = Utils.CreateStay(PersonAccount.Id,opp1.Id);
        listStay.add(stay1);    
        Stay__c stay2 = Utils.CreateStay(PersonAccount.Id,opp2.Id);
        listStay.add(stay2);  
        test.startTest();
        insert listStay;
        Account acc=[Select Id,Total_nights__pc
                     From Account
                     Where Id=:PersonAccount.Id];            
       // System.assertEquals(3,acc.Total_nights__pc);
        //Delete Opportunity
        delete (stay2);
        acc=[Select Id,Total_nights__pc
             From Account
             Where Id=:PersonAccount.Id];             
        //System.assertEquals(1,acc.Total_nights__pc);
        //update Opportunity    
        stay1.Booking__c = opp2.Id;      
        update (stay1);
        acc=[Select Id,Total_nights__pc
             From Account
             Where Id=:PersonAccount.Id];        
        //System.assertEquals(2,acc.Total_nights__pc);
        test.stopTest();
    }*/
}