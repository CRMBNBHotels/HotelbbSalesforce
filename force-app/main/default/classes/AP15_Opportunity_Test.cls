/*
* Description: Test Class for AP15_Opportunity 
* @author: TMA-EI JKA
* @date: 29/11/2019
*/

@isTest

public class AP15_Opportunity_Test {
    @isTest
    public static void testMethod1(){
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        Account testAcc=Utils.CreatePersonAccount('accName',null);
        Account testAcc2=Utils.CreatePersonAccount('accName2',null);
        insert testAcc;
        insert testAcc2;
        
        Opportunity masterBook1=Utils.CreateMasterBookingOpportunity('oppName',testAcc.id);
        masterBook1.StageName=Label.StageNameBooking_Checked;
        masterBook1.Bookings_Checked_Count__c=1;
        masterBook1.RecordTypeId = masterBookingRTId;
        insert masterBook1;
        
        Opportunity masterBook2=Utils.CreateMasterBookingOpportunity('oppName1',testAcc2.id);
        masterBook2.StageName=Label.StageNameBooking_Checked;
        masterBook2.Bookings_Checked_Count__c=3;
        masterBook2.RecordTypeId = masterBookingRTId;
        insert masterBook2;
        
        list<Opportunity> listBookings = new list<Opportunity>();
        Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'Checked', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook1.id);
        listBookings.add(book1);
        
        Opportunity book2 = new Opportunity(Name = 'Booking2', CloseDate = date.today(), StageName = 'Checked', RecordTypeId = bookingRTId, Master_Booking_FK__c = masterBook2.id);
        listBookings.add(book2);
        insert listBookings;
        
        List<Opportunity> listOpp=new List<Opportunity>();
        Map<id,Opportunity> mapOpp=new Map<id,Opportunity>();
        listOpp.add(masterBook1);
        mapOpp.put(masterBook1.id,masterBook1);
        /* MasterBookingHandler.FilterOpportunity(listOpp, null);
MasterBookingHandler.FilterOpportunity(listOpp, mapOpp);
MasterBookingHandler.FilterOpportunity(null, mapOpp);*/
        masterBook1.Person_Account__c=testAcc2.id;
        update masterBook1;
        masterBook1.Bookings_Checked_Count__c=2;
        update masterBook1;
        masterBook2.Bookings_Checked_Count__c=-1;
        update masterBook2;
        masterBook2.Bookings_Checked_Count__c=3;
        update masterBook2;
        delete masterBook2;
        masterBook1.Person_Account__c=testAcc.id;
        masterBook1.Bookings_Checked_Count__c=4;
        update masterBook1;
        
        
    }
}