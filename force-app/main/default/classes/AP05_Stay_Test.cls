/**
* 
* @version 1.00 14/11/2017
* @author Jenny Jawhar
* @CodeCoverage 98%
*/
@isTest
public class AP05_Stay_Test 
{
    
    private static testMethod void InsertUpdateDeleteOpportunity()
    {/*
        //insert Account      
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);
        PartnerAccount.BillingCountry='France';
        insert PartnerAccount;
        
        list<Account> listAccount = new list<Account>();
        Account PersonAccount =  Utils.CreatePersonAccount('Person', PartnerAccount.Id);
        listAccount.add(PersonAccount);      
        Account PersonAccount1 = Utils.CreatePersonAccount('Person1', PartnerAccount.Id);
        listAccount.add(PersonAccount1);
        insert listAccount;
        
        //insert List of Opportunities
        List<Opportunity> ListOpp = new List<Opportunity>(); 
        Opportunity opp1 = Utils.CreateBookingOpportunity('B1');            
        opp1.Min_Arrival__c = date.Today();                 
        opp1.StageName= label.ClosedWonStage; 
        ListOpp.add(opp1);
        Opportunity opp2 = Utils.CreateBookingOpportunity('B2');       
        opp2.Min_Arrival__c = date.Today()+2;          
        opp2.StageName= label.ClosedWonStage; 
        ListOpp.add(opp2);
        insert ListOpp;  
        list<Stay__c> listStay = new list<Stay__c>();
        Stay__c stay1 = Utils.CreateStay(PersonAccount.Id,opp1.Id);
        listStay.add(stay1);
        Stay__c stay2 = Utils.CreateStay(PersonAccount1.Id,opp2.Id);
        listStay.add(stay2);
        insert listStay;
        
        Account acc=[Select Id,MaxBookingMinArrival__c
                     From Account
                     Where Id=:PersonAccount1.Id];            
        System.assertEquals(date.Today()+2,acc.MaxBookingMinArrival__c);
        //Delete Stay
        Stay__c stay = [Select Id
                        From Stay__c
                        Where Guest_Account__c =: PersonAccount1.Id Limit 1];
        Delete (stay);
        acc=[Select Id,MaxBookingMinArrival__c
             From Account
             Where Id=:PartnerAccount.Id];             
        System.assertEquals(date.Today(),acc.MaxBookingMinArrival__c);
        //update Opportunity
        opp1.Min_Arrival__c = date.Today()+3;
        update opp1;
        acc=[Select Id,MaxBookingMinArrival__c
             From Account
             Where Id=:PartnerAccount.Id];        
        System.assertEquals(date.Today()+3,acc.MaxBookingMinArrival__c);*/
    }
}