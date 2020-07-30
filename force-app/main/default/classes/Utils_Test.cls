/**
* 
* @version 1.00 22/09/2017
* @author Jenny Jawhar
* @CodeCoverage 100%
*/
@isTest
public class Utils_Test {
  static testmethod void testUtils() {
      Account Partner = Utils.CreatePartnerAccount('Partner1','456');
      insert Partner;
      Contact con = Utils.CreateContact('Contact', Partner.Id, label.EN);
      insert con;
      Account Person = Utils.CreatePersonAccount('Person1',Partner.Id);
      insert Person;
      Opportunity MasterBooking = Utils.CreateMasterBookingOpportunity('MasterBooking1', Person.Id);
      MasterBooking.StageName = label.ClosedWonStage;
      insert MasterBooking;
      Opportunity Booking = Utils.CreateBookingOpportunity('Booking1');
      Booking.Master_Booking_fk__c = MasterBooking.Id;
      Booking.StageName = label.ClosedWonStage;
      insert Booking;
      //Stay__c stay = Utils.CreateStay(Person.Id,Booking.Id);
      //insert stay;
      Booking_Room_Line__c roomLine = Utils.CreateBookingRoomLine(Booking.Id);
      insert roomLine;
      //Booking_Room_Line_Price__c roomPrice = Utils.CreateBookingRoomLinePrice(roomLine.Id, 100);
      //insert roomPrice;
      Contract contract = Utils.CreateContract();
      contract.AccountId = Partner.Id;
      insert contract;
      Hotel__c hotel = Utils.CreateHotel('123');
      insert hotel;
      Case cas = Utils.CreateCase();
      insert cas;
      //Hotel_Room_Option__c hotelRoomOptionAndCode = Utils.CreateHotelRoomOptionAndCode();
      //insert hotelRoomOptionAndCode;
      Product2 prod = Utils.CreateProduct();
      prod.Name = 'prod1';
      insert prod;
      Messaging.SingleEmailMessage SEM = Utils.CreateSingleEmailMessage(null,null,null,null,label.WebCaseEnglishEmailTemplateId,'jennyjawhar@hotmail.com');
      
    }
}