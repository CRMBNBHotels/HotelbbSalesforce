/**
* 
* @version 1.00 04/12/2017
* @author Jenny Jawhar
* @CodeCoverage 96%
*/
@isTest
public class AP04_Stay_Test 
{
    public static testMethod void InsertUpdateDeleteStay()
    {
        //insert Account      
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);                      
        insert PersonAccount;
        
        //insert Hotels
        list<Hotel__c> listHotel = new list<Hotel__c>();
        Hotel__c hotel1 = Utils.CreateHotel('123');
        listHotel.add(hotel1);
        Hotel__c hotel2 = Utils.CreateHotel('456');
        listHotel.add(hotel2);
        Hotel__c hotel3 = Utils.CreateHotel('789');
        listHotel.add(hotel3);
        insert listHotel;
        
        //insert Opportunity
        list<Opportunity> listOpp = new list<Opportunity>();
        for(integer i=0; i<2; i++)
        {
            Opportunity opp1 = Utils.CreateBookingOpportunity('B1'+i);                 
            opp1.StageName=Label.StatusChecked; 
            opp1.Hotel__c = hotel1.Id;
            ListOpp.add(opp1);            
        }
        for(integer i=0;i<3;i++)
        {
            Opportunity opp2 = Utils.CreateBookingOpportunity('B2'+i);                 
            opp2.StageName=Label.StatusChecked; 
            opp2.Hotel__c = hotel2.Id;
            ListOpp.add(opp2);
        }
        for(integer i=0;i<4;i++)
        {
            Opportunity opp3 = Utils.CreateBookingOpportunity('B3'+i);                 
            opp3.StageName=Label.StatusChecked; 
            opp3.Hotel__c = hotel3.Id;
            ListOpp.add(opp3);
        }
        insert listOpp;
        //insert list of stays
        list<Stay__c> listStay = new list<Stay__c>();
        for(integer i=0;i<listOpp.size();i++)
        {
            Stay__c stay = Utils.CreateStay(PersonAccount.Id,listOpp[i].Id); 
            listStay.add(stay);
        } 
        insert listStay;
        Account acc=[Select Id,Favorite_hotel__pc
                     From Account
                     Where Id=:PersonAccount.Id];            
        System.assertEquals(hotel3.Id,acc.Favorite_hotel__pc);
        string hotelId = hotel3.Id;
        list<Stay__c> listStayToDelete = [Select Id, Trip_Context__c
                                          From Stay__c
                                          Where Guest_account__c =: PersonAccount.Id
                                          And Hotel_Id__c =: hotelId.substring(0,15) Limit 2];
        system.debug(listStayToDelete);
        Delete listStayToDelete;
        acc=[Select Id,Favorite_hotel__pc
             From Account
             Where Id=:PersonAccount.Id];            
        System.assertEquals(hotel2.Id,acc.Favorite_hotel__pc);
    }
}