/*
* Description: Test Class for AP11_Opportunity 
* @author: TMA-EI Myriam Antoun
* @date: 9/17/2019
*/

@isTest
public class AP11_Opportunity_Test {
    
    @isTest
    public static void updateNumberOfNightsOnMasterBookingTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            list<Opportunity> listMasterBookings = new list<Opportunity>();
            list<Opportunity> listBookings = new list<Opportunity>();
            for(Integer i=0; i<=4; i++){
                String nameMB = 'MasterBooking' + i;
                Opportunity oppObj = Utils.CreateMasterBookingOpportunity(nameMB, null);
                listMasterBookings.add(oppObj);
            }
            insert listMasterBookings;
            
            for(Integer i=0; i<=4; i++){
                String nameB = 'Booking' + i;
                Opportunity oppObj = Utils.CreateBookingOpportunity(nameB);
                oppObj.StageName = 'Cancelled';
                oppObj.Master_Booking_FK__c = listMasterBookings[i].Id;
                oppObj.Min_Arrival__c = date.today();
                oppObj.Max_Departure__c = date.today() + i;
                listBookings.add(oppObj);
            }
            insert listBookings;
            List<Opportunity> masterBookings = [select id, Number_of_nights_master__c,Bookings_Cancelled_Count__c
                                               from opportunity
                                               where id in: listMasterBookings];
            Test.startTest();
            listBookings[0].StageName = 'Booked';
            listBookings[1].StageName = 'Checked';
            listBookings[2].StageName = 'Booked';
            update listBookings;
            listMasterBookings[0].TechIsNotFirst_01__c = true;
            listMasterBookings[0].Bookings_Cancelled_Count__c = 1;
            listMasterBookings[0].Number_of_nights_master__c = 1;
            listMasterBookings[0].Rooms__c = 1;
            listMasterBookings[0].Bookings_Booked_Count__c = 1;
            listMasterBookings[0].Bookings_Checked_Count__c = 1;
            listMasterBookings[0].Bookings_Error_Count__c = 1;
            listMasterBookings[0].Bookings_No_Show_Count__c = 1;
            update listMasterBookings[0];
            Batch_UpdateMB_Nights_Rooms_StageCount batchObj = new Batch_UpdateMB_Nights_Rooms_StageCount(null,0);
            DataBase.executeBatch(batchObj);
            test.stopTest();
           // for(Integer i=0; i<=4; i++){
                //system.assert(masterBookings[i].Bookings_Cancelled_Count__c > 0);
           // }
        }
    }
    
}