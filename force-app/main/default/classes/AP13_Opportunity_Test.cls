/*
* Description: Test Class for AP13_Opportunity 
* @author: TMA-EI JKA
* @date: 02/10/2019
*/

@isTest
public class AP13_Opportunity_Test {
    
    @isTest
    public static void CalculateRoomTest(){
        
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        
        Opportunity MB1 = new Opportunity(Name = 'MB1', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
        insert MB1;
        
        Opportunity MB2 = new Opportunity(Name = 'MB2', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
        insert MB2;
        
        Opportunity MB3 = new Opportunity(Name = 'MB3', StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
        insert MB3;
        
        list<Opportunity> listOpp =  new list<Opportunity>();
        
        
        Opportunity Opp1 = new Opportunity(Name = 'Booking1', StageName= 'Checked', CloseDate=date.Today(), recordTypeId = bookingRTId, chambre__c =1, Master_Booking_FK__c = MB1.id);
        listOpp.add(Opp1);
        Opportunity Opp2 = new Opportunity(Name = 'Booking2', StageName= 'Checked', CloseDate=date.Today(), recordTypeId = bookingRTId, chambre__c =2, Master_Booking_FK__c = MB1.id);
        listOpp.add(Opp2);
        Opportunity Opp3 = new Opportunity(Name = 'Booking3', StageName= 'Checked', CloseDate=date.Today(), recordTypeId = bookingRTId, chambre__c =2, Master_Booking_FK__c = MB1.id);
        listOpp.add(Opp3);
        Opportunity Opp4 = new Opportunity(Name = 'Booking4', StageName= 'Checked', CloseDate=date.Today(), recordTypeId = bookingRTId, chambre__c =1, Master_Booking_FK__c = MB2.id);
        listOpp.add(Opp4);
        Opportunity Opp5 = new Opportunity(Name = 'Booking5', StageName= 'Checked', CloseDate=date.Today(), recordTypeId = bookingRTId, chambre__c =1, Master_Booking_FK__c = MB3.id);
        listOpp.add(Opp5);
        
        test.startTest();
        
        Database.insert(listOpp, false);
        
        Opp2.chambre__c =1;
        Opp3.Master_Booking_FK__c = MB2.Id;
        Database.update(listOpp, false);
        
        Database.delete(Opp1, false);
        
        test.stopTest();
        
    }
}