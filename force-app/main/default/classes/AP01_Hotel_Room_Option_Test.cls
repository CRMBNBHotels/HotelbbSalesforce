/**
* 
* @version 1.00 05/01/2018
* @author Jenny Jawhar
* @CodeCoverage 100%
*/
@isTest
public class AP01_Hotel_Room_Option_Test 
{
    public static testMethod void updateDeleteInsertHotelRoomOption()
    {
        //insert Hotel_Room_Option__c
        list<Hotel_Room_Option__c> listHotelRoomOptionAndCode = new list<Hotel_Room_Option__c>();
        Hotel_Room_Option__c hotelRoomOptionAndCode;
        for(integer i = 0; i < 2; i++)
        {
            hotelRoomOptionAndCode = Utils.CreateHotelRoomOptionAndCode();
            hotelRoomOptionAndCode.Type_code__c = label.TypeCodeRoom;
            hotelRoomOptionAndCode.Room_code__c = 'R'+ i;
            hotelRoomOptionAndCode.Room_Type__c = 'RT' + i;
            hotelRoomOptionAndCode.Room_Type_Label__c = label.TypeCodeRoom + i;
            listHotelRoomOptionAndCode.add(hotelRoomOptionAndCode);
        }
        for(integer i = 0; i < 5; i++)
        {
            hotelRoomOptionAndCode = Utils.CreateHotelRoomOptionAndCode();
            hotelRoomOptionAndCode.Type_code__c = label.TypeCodeOption;
            hotelRoomOptionAndCode.Room_code__c = 'O'+ i;
            hotelRoomOptionAndCode.Room_Code_Label__c = label.TypeCodeOption + i;
            listHotelRoomOptionAndCode.add(hotelRoomOptionAndCode);
        }
        insert listHotelRoomOptionAndCode;
        //insert Account      
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);                      
        insert PersonAccount;
        
        Opportunity opp = Utils.CreateBookingOpportunity('Booking');                 
        opp.StageName=Label.StatusChecked; 
        insert opp;
        
        list<Booking_Room_Line__c> listBRL = new list<Booking_Room_Line__c>();
        Booking_Room_Line__c BRL;
        for(integer i = 0; i < 3; i++)
        {
            BRL = Utils.CreateBookingRoomLine(opp.Id);
            BRL.Room_code__c = 'R'+ 0;
            listBRL.add(BRL);
        }  
        for(integer i = 0; i < 2; i++)
        {
            BRL = Utils.CreateBookingRoomLine(opp.Id);
            BRL.Room_code__c = 'R'+ 1;
            listBRL.add(BRL);
        } 
        for(integer i = 0; i < 3; i++)
        {
            BRL = Utils.CreateBookingRoomLine(opp.Id);
            BRL.Room_code__c = 'O'+ 0;
            listBRL.add(BRL);
        } 
        for(integer i = 0; i < 2; i++)
        {
            BRL = Utils.CreateBookingRoomLine(opp.Id);
            BRL.Room_code__c = 'O'+ 1;
            listBRL.add(BRL);
        }         
        BRL = Utils.CreateBookingRoomLine(opp.Id);
        BRL.Room_code__c = 'Unknown';
        listBRL.add(BRL);
        insert listBRL;
        
        //Stay__c stay = Utils.CreateStay(PersonAccount.Id,opp.Id);
        //test.startTest();
        //insert stay;
        
        Hotel_Room_Option__c hotelRoomOption = [Select Id,Room_code__c
                                                From Hotel_Room_Option__c
                                                Where Room_code__c = 'R0'];
        hotelRoomOption.Room_Type__c = 'RT01';
        update hotelRoomOption;
        Account acc = [Select Id,Favorite_Room_type__pc
                       From Account
                       Where Id =: PersonAccount.Id];
        //system.assertEquals('RT01',acc.Favorite_Room_type__pc);
        delete (hotelRoomOption);
        acc = [Select Id,Favorite_Room_type__pc
               From Account
               Where Id =: PersonAccount.Id];
        //system.assertEquals(label.UnknownProduct,acc.Favorite_Room_type__pc);
    }
}