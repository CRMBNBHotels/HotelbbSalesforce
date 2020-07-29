/**
* 
* @version 1.00 20/09/2017
* @author Jenny Jawhar
* @CodeCoverage 96%
*/
@isTest
public class AP03_Opportunity_Test 
{
    private static testMethod void InsertUpdateDeleteOpportunity()
    {
        //insert Account
        list<Account> listAccount = new list<Account>();      
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner','123');      
        insert PartnerAccount;       
        Account PersonAccount1 = Utils.CreatePersonAccount('Person', PartnerAccount.Id);                      
        listAccount.add(PersonAccount1);
        Account PersonAccount2 = Utils.CreatePersonAccount('Person1', PartnerAccount.Id); 
        insert listAccount;
        
        Opportunity MasterBooking = Utils.CreateMasterBookingOpportunity('Master Booking',PersonAccount1.Id); 
        MasterBooking.Min_Arrival__c = date.Today();
        insert MasterBooking;
        
        list<Opportunity> listOpp = new list<Opportunity>();
        Opportunity opp1 = Utils.CreateBookingOpportunity('Booking 1');
        opp1.Min_arrival__c = date.today();       
        opp1.Max_departure__c = date.today()+10;
        opp1.Partner_Code__c='123';
        opp1.Master_Booking_fk__c = MasterBooking.Id;
        opp1.StageName = Label.StatusChecked;
        listOpp.add(opp1);
        
        Opportunity opp2 = Utils.CreateBookingOpportunity('Booking 2');
        opp2.Min_arrival__c = date.today();
        opp2.Max_departure__c = date.today()+5;
        opp2.Partner_Code__c='123';
        opp2.Master_Booking_fk__c = MasterBooking.Id;
        opp2.StageName = Label.StatusChecked;                                               
        listOpp.add(opp2);
        insert listOpp;
        
        list<Booking_Room_Line__c> listroomLine = new list<Booking_Room_Line__c>();
        Booking_Room_Line__c roomLine1 = Utils.CreateBookingRoomLine(opp1.Id);
        roomLine1.Quantity__c = 1;
        listroomLine.add(roomLine1); 
        Booking_Room_Line__c roomLine2 =  Utils.CreateBookingRoomLine(opp2.Id);
        roomLine2.Quantity__c = 1;
        listroomLine.add(roomLine2); 
        insert listroomLine;
        
        /*list<Booking_Room_Line_Price__c> listRoomPrice = new list<Booking_Room_Line_Price__c>(); 
        for(integer i = 100; i<500; i++)
        {
            Booking_Room_Line_Price__c roomPrice = Utils.CreateBookingRoomLinePrice(roomLine1.Id, i);
            i=i+99;
            listRoomPrice.add(roomPrice);
        }
        for(integer i=200; i<500;i++)
        {
            Booking_Room_Line_Price__c roomPrice = Utils.CreateBookingRoomLinePrice(roomLine2.Id, i);
            i=i+99; 
            listRoomPrice.add(roomPrice);
        }
        insert listRoomPrice;*/
        
        Account acc=[Select Id,Total_Nights_PartnerShip__c,Total_Revenue_PartnerShip__c,Total_Transactions_PartnerShip__c
                     From Account
                     Where Id=:PartnerAccount.Id];    
        //system.assertEquals(15,acc.Total_Nights_PartnerShip__c);
        //system.assertEquals(1900,acc.Total_Revenue_PartnerShip__c);
        //system.assertEquals(1, acc.Total_Transactions_PartnerShip__c);
        
        Opportunity opp = [Select Id
                           From Opportunity
                           Where Id =: opp1.Id];
        Delete (opp1);
        acc=[Select Id,Total_Nights_PartnerShip__c,Total_Revenue_PartnerShip__c
             From Account
             Where Id=:PartnerAccount.Id];    
       // system.assertEquals(5,acc.Total_Nights_PartnerShip__c);
       // system.assertEquals(900,acc.Total_Revenue_PartnerShip__c); 
        MasterBooking.Min_Arrival__c = date.Today() - 400;
        update MasterBooking;
        acc=[Select Id,Total_Transactions_PartnerShip__c
             From Account
             Where Id=:PartnerAccount.Id];  
        //system.assertEquals(0, acc.Total_Transactions_PartnerShip__c);
    }
}