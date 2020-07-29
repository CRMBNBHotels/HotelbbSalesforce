/**
* 
* @version 1.00 16/11/2017
* @author Jenny Jawhar
* @CodeCoverage 92%
*/
@isTest
public class AP06_Stay_Test 
{
    /*
    public static testMethod void InsertUpdateDeleteBookingRoomLine()
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
             
        Stay__c stay = Utils.CreateStay(PersonAccount.Id,opp.Id);
        test.startTest();
        insert stay;
        
        Account acc = [Select Id,Favorite_Room_type_Label__pc, Favorites_option_1_Label__pc
                       From Account
                       Where Id =: PersonAccount.Id];
        system.assertEquals(label.TypeCodeRoom + '0',acc.Favorite_Room_type_Label__pc);
        system.assertEquals(label.TypeCodeOption +'0',acc.Favorites_option_1_Label__pc);
        delete BRL;
        acc = [Select Id,Favorites_option_3_label__pc
               From Account
               Where Id =: PersonAccount.Id];
        system.assertEquals(null,acc.Favorites_option_3_label__pc);
        test.stopTest();
    }*/
}