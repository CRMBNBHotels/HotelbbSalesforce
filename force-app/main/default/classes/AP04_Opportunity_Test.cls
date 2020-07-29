/**
* 
* @version 1.00 04/12/2017
* @author Jenny Jawhar
* @CodeCoverage 95%
*/
@isTest
public class AP04_Opportunity_Test {
    private static testMethod void InsertUpdateDeleteOpportunity()
    {
        //insert Account
        list<Account> listAccount = new list<Account>();      
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);      
        insert PartnerAccount;       
        Account PersonAccount1 = Utils.CreatePersonAccount('Person', PartnerAccount.Id);                      
        listAccount.add(PersonAccount1);
        Account PersonAccount2 = Utils.CreatePersonAccount('Person1', PartnerAccount.Id); 
        listAccount.add(PersonAccount2);
        insert listAccount;
        
        //insert List of Opportunities
        List<Opportunity> ListOpp = new List<Opportunity>();               
        for(integer i=0;i<5;i++)
        {
            Opportunity opp = Utils.CreateMasterBookingOpportunity('B'+ i,PersonAccount1.Id);                     
            opp.Min_Arrival__c = date.today();
            opp.StageName =  label.ClosedWonStage;
            ListOpp.add(opp);
        } 
        for(integer i=0;i<5;i++)
        {
            Opportunity opp = Utils.CreateMasterBookingOpportunity('B'+ i,PersonAccount2.Id); 
            opp.Min_Arrival__c = date.today();
            opp.StageName =  label.ClosedWonStage;
            ListOpp.add(opp);
        }
        insert ListOpp; 
        Opportunity opp = [Select Id
                          From Opportunity
                          Where Person_account__c =: PersonAccount1.Id limit 1];
        Opportunity booking1 = Utils.CreateBookingOpportunity('Booking1');
        booking1.Master_Booking_FK__c = opp.Id;
        booking1.StageName = label.ClosedWonStage;
        booking1.Trip_Context__c = label.BusinessCustomerType;
        insert booking1;
        
        Account acc=[Select Id,Total_Transactions__pc
                     From Account
                     Where Id=:PersonAccount1.Id];            
        
        //Delete Opportunity
        opp = [Select Id, Trip_Context__c
                           From Opportunity
                           Where Person_account__c =: PersonAccount2.Id Limit 1];
        Delete (opp);
        acc=[Select Id,Total_Transactions__pc
             From Account
             Where Id=:PersonAccount2.Id];             
        
        //update Opportunity
        opp = [Select Id, AccountId 
               From Opportunity
               Where Person_account__c =: PersonAccount1.Id Limit 1];        
        opp.Person_account__c = PersonAccount2.Id;
        update opp;
        acc=[Select Id,Total_Transactions__c
             From Account
             Where Id=:PartnerAccount.Id];        
       
    }
}