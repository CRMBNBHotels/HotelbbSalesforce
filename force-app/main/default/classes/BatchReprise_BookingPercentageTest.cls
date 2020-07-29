@isTest
public class BatchReprise_BookingPercentageTest {
private static testMethod void InsertUpdateDeleteOpportunity()
    {
        list<Account> listAccount = new list<Account>();
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);
        listAccount.add(PersonAccount); 
        Account PersonAccount2 =  Utils.CreatePersonAccount('Person2', null);
        listAccount.add(PersonAccount2); 
        Account PersonAccount1 = Utils.CreatePersonAccount('Person1', null);
        listAccount.add(PersonAccount1);
        insert listAccount;
        
        // insert LIST hotel__c
        List<Hotel__c> ListHotel = new List<Hotel__c>(); 
        Hotel__c hot1 = new Hotel__c ( Country__c='France');            
        ListHotel.add(hot1);
        Hotel__c hot2 = new Hotel__c ( Country__c='France');         
        ListHotel.add(hot2);
        insert ListHotel;
        
        //insert List of Opportunities
        List<Opportunity> ListOpp = new List<Opportunity>(); 
        Opportunity opp1 = Utils.CreateBookingOpportunity('B1');            
        opp1.Min_Arrival__c = date.Today();                 
        opp1.StageName= label.StageBooked;
        opp1.Hotel__c=hot1.id;
        ListOpp.add(opp1);
        Opportunity opp2 = Utils.CreateBookingOpportunity('B2');       
        opp2.Min_Arrival__c = date.Today()+2;          
        opp2.StageName= label.StageBooked; 
        opp2.Hotel__c=hot2.id;
        ListOpp.add(opp2);
        insert ListOpp;  
        
        // insert List Of Stays
        list<Stay__c> listStay = new list<Stay__c>();
        Stay__c stay1 = Utils.CreateStay(PersonAccount.Id,opp1.Id);
        Stay__c stay3 = Utils.CreateStay(PersonAccount.Id,opp2.Id);
        Stay__c stay2 = Utils.CreateStay(PersonAccount1.Id,opp2.Id);
        listStay.add(stay1);
        listStay.add(stay2);
        listStay.add(stay3);
        insert listStay;
		
            database.executeBatch(new BatchReprise_BookingCountryCorrection());

    }
}