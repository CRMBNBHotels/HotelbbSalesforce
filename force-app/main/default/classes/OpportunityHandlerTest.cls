/*
* Description: Test class for OpportunityHandler
* @author: TMA-EIL CG
* @date:
*/
@isTest
public class OpportunityHandlerTest {
    @isTest
    public static void testMethod1()
    {
        String companyAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookRTID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        Account testAcc=Utils.CreatePersonAccount('accName',null);
        Account testAcc2=Utils.CreatePersonAccount('accName2',null);
        insert testAcc;
        insert testAcc2;
        
        Account compAcc1 = new Account(Name = 'compAccTest', RecordTypeId = companyAccRTId,TechIsNotFirst_03__c=true, BillingCountry = 'France', BillingPostalCode = '99999');
        insert compAcc1;
        
        Opportunity testOpp=Utils.CreateMasterBookingOpportunity('oppName',testAcc.id);
        testOpp.StageName=Label.StageNameBooking_Checked;
        testOpp.RecordTypeId = masterBookingRTId;
        insert testOpp;
        Opportunity masterBook1 = new Opportunity(Name = 'masterBookingTest1', Bookings_Checked_Count__c =2, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
        insert masterBook1;
        
        Account getAcc=[Select id,Total_Transactions__pc from account where id=:testAcc.id limit 1];
        //System.assertEquals(getAcc.Total_Transactions__pc, 1);
        
        List<Opportunity> listOpp=new List<Opportunity>();
        Map<id,Opportunity> mapOpp=new Map<id,Opportunity>();
        listOpp.add(testOpp);
        mapOpp.put(testOpp.id,testOpp);
        /*MasterBookingHandler.FilterOpportunity(listOpp, null);
MasterBookingHandler.FilterOpportunity(listOpp, mapOpp);
MasterBookingHandler.FilterOpportunity(null, mapOpp);*/
        testOpp.Person_Account__c=testAcc2.id;
        update testOpp;
        Account getAcc2=[Select id,Total_Transactions__pc from account where id=:testAcc2.id limit 1];
        //System.assertEquals(getAcc.Total_Transactions__pc, 1);
        // delete testOpp;
        Account getAcc3=[Select id,Total_Transactions__pc from account where id=:testAcc2.id limit 1];
        //System.assertEquals(getAcc3.Total_Transactions__pc, 0);
        Opportunity testBook=Utils.CreateMasterBookingOpportunity('oppName',testAcc.id);
        testBook.StageName=Label.StageNameBooking_Checked;
        testBook.RecordTypeId = bookRTID;
        testBook.Confirmation_Number__c = '123';
        //testOpp.Number_of_nights__c = 1;
        testBook.Master_Booking_FK__c = testOpp.id;
        testBook.chambre__c = 1;
        testBook.Booking_Person_account__c = testAcc2.id;
        insert testBook;
        
        Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = Label.StageNameBooking_Checked, Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Invoiced_amount__c=100, PartnerCode__c = compAcc1.id, RecordTypeId = bookRTID,Master_Booking_FK__c=masterBook1.Id);
        insert book1;
        Account getAcc4=[Select id,TechIsNotFirst_03__c from account where id=:compAcc1.id limit 1];
        Opportunity getBook1=[Select id,Name,CloseDate,StageName,Min_Arrival__c,Max_Departure__c,OnTheCurrentYear__c, IsDeleted, Number_of_nights__c, PartnerCode__c,Invoiced_amount__c,RecordTypeId,Master_Booking_FK__c,PartnerCode__r.TechIsNotFirst_03__c,PartnerCode__r.Total_Transactions_PartnerShip__c, PartnerCode__r.Total_Revenue_PartnerShip__c, PartnerCode__r.Total_Nights_PartnerShip__c from Opportunity where id=:book1.id and PartnerCode__c=:getAcc4.id limit 1];
        
        Map<String,String> mapCongHotelNAme = OpportunityHandler.filterBookingsBatch_UpdateMB_ConfNb_HotelName(new List<opportunity>{testBook});
        Map<String,String> mapRoomStage = OpportunityHandler.filterBookingsBatch_UpdateMB_Nights_Rooms_StageCount(new List<opportunity>{testBook});
        Map<String,String> mapHotelCount = OpportunityHandler.filterBookings_Batch_HotelCountChecked(new List<opportunity>{testBook});
        Map<String,String> mapPartnerShipFieldUpdt = OpportunityHandler.filterBookings_Batch_PartnershipFieldsUpdate(new List<opportunity>{getBook1});
        
        
    }
}