/**
* 
* @version 1.00 05/12/2017
* @author Jenny Jawhar
* @CodeCoverage 98% 
*/
@isTest
public class AP03_Stay_Test {
    /*
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
        
        list<Opportunity> listOpp = new list<Opportunity>();
        Opportunity opp1 = Utils.CreateBookingOpportunity('Booking 1');
        opp1.Min_arrival__c = date.today(); 
        opp1.StageName = label.ClosedWonStage;
        opp1.Trip_Context__c = label.BusinessCustomerType;
        listOpp.add(opp1);
        Opportunity opp2 = Utils.CreateBookingOpportunity('Booking 2');
        opp2.Min_arrival__c = date.today(); 
        opp2.StageName = label.ClosedWonStage;
        opp2.Trip_Context__c = label.BusinessCustomerType;
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
        /*
        list<Booking_Room_Line_Price__c> listRoomPrice = new list<Booking_Room_Line_Price__c>(); 
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
        insert listRoomPrice;
        
        list<Stay__c> listStay = new list<Stay__c>();
        Stay__c stay1 = Utils.CreateStay(PersonAccount1.Id,opp1.Id);
        listStay.Add(stay1);
        Stay__c stay2 = Utils.CreateStay(PersonAccount2.Id,opp2.Id);
        listStay.Add(stay2);
        insert listStay;
        Account acc=[Select Id,Total_Revenue__pc
                     From Account
                     Where Id=:PersonAccount1.Id];            
        System.assertEquals(1000,acc.Total_Revenue__pc);
        //Delete Opportunity
        Stay__c stay = [Select Id
                           From Stay__c
                           Where Guest_Account__c =: PersonAccount1.Id Limit 1];
        Delete (stay);
        acc=[Select Id,Total_Revenue__c
             From Account
             Where Id=:PartnerAccount.Id];             
        System.assertEquals(900,acc.Total_Revenue__c);
        //update Opportunity
        stay = [Select Id
               From Stay__c
               Where Guest_Account__c =: PersonAccount2.Id Limit 1];        
        stay.Guest_Account__c = PersonAccount1.Id;
        update stay;
        acc=[Select Id,Total_Revenue__pc
             From Account
             Where Id=:PersonAccount1.Id];        
        System.assertEquals(900,acc.Total_Revenue__pc);
        
    }*/
}