/**
* 
* @version 1.00 
* @author 
* @CodeCoverage 
*/
@isTest
public class batch_ap02_stay_test {
	/*
    private static testMethod void InsertUpdateDeleteStay(){
        //insert Account      
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);      
        insert PartnerAccount;
        Account PersonAccount =  Utils.CreatePersonAccount('Person', PartnerAccount.Id);                      
        insert PersonAccount;
        //insert Opportunities
        list<Hotel__c> listHotel = new list<Hotel__c>();
        Hotel__c hotel1 = Utils.CreateHotel('123');
        listHotel.add(hotel1);
        Hotel__c hotel2 = Utils.CreateHotel('456');
        listHotel.add(hotel2);
        Hotel__c hotel3 = Utils.CreateHotel('789');
        listHotel.add(hotel3);
        insert listHotel;
        List<Opportunity> ListOpp = new List<Opportunity>(); 
        Opportunity opp1 = Utils.CreateBookingOpportunity('B1');            
        opp1.Min_Arrival__c = date.Today();
        opp1.Max_Departure__c = date.Today() + 1;         
        opp1.StageName=Label.StatusChecked; 
        opp1.Trip_Context__c =Label.BusinessCustomerType;
        opp1.Hotel__c = hotel1.Id;
        ListOpp.add(opp1);
        Opportunity opp2 = Utils.CreateBookingOpportunity('B2');            
        opp2.Min_Arrival__c = date.Today();
        opp2.Max_Departure__c = date.Today() + 2;         
        opp2.StageName=Label.StatusChecked; 
        opp2.Hotel__c = hotel2.Id;
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
        System.assertEquals(3,acc.Total_nights__pc);
        //Delete Opportunity
        delete (stay2);
        acc=[Select Id,Total_nights__pc
             From Account
             Where Id=:PersonAccount.Id];             
        System.assertEquals(1,acc.Total_nights__pc);
        //update Opportunity    
        stay1.Booking__c = opp2.Id;      
        update (stay1);
        acc=[Select Id,Total_nights__pc
             From Account
             Where Id=:PersonAccount.Id];        
        //System.assertEquals(2,acc.Total_nights__pc);
        Database.executeBatch(new batch_ap02_Stay());
        test.stopTest();
    }*/
}