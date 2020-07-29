/**
* 
* @version 1.00 01/12/2017
* @author Jenny Jawhar
* @CodeCoverage 93%
*/

@isTest
public class AP01_Stay_Test {
    /*
    private static testMethod void InsertUpdateDeleteStay(){
        //insert Account       
        Account testAccount = Utils.CreatePersonAccount('Person', null); 
        insert testAccount;
        
        //insert Opportunities
        List<Opportunity> ListOpp = new List<Opportunity>();    
        Opportunity opp1 = Utils.CreateBookingOpportunity('B1');                                         
        opp1.Trip_Context__c = Label.BusinessCustomerType;    
        opp1.StageName = label.ClosedWonStage;
        ListOpp.add(opp1);
        
        Opportunity opp2 = Utils.CreateBookingOpportunity('B2');                
        opp2.Trip_Context__c = Label.LeisureCustomerType;
        opp2.StageName = label.ClosedWonStage;
        ListOpp.add(opp2);
        insert ListOpp; 
        
        //insert list of stay
        list<Stay__c> listStay = new list<Stay__c>();
        Stay__c stay = Utils.CreateStay(testAccount.Id,opp1.Id);
        listStay.add(stay);  
        Stay__c stay1 = Utils.CreateStay(testAccount.Id,opp2.Id);
        listStay.add(stay1);
        
        insert listStay;        
        Account acc=[Select Id,Customer_type__pc,Total_nights__pc
                     From Account
                     Where Id=:testAccount.Id];       
        System.assertEquals(Label.MixedCustomerType, 
                            acc.Customer_type__pc);        
        
        //Delete Opportunity
        Delete (stay1);
        acc=[Select Id,Customer_type__pc,Total_nights__pc
             From Account
             Where Id=:testAccount.Id];        
        System.assertEquals(Label.BusinessCustomerType, 
                            acc.Customer_type__pc);      
    }*/
}