/*
* Description: Test class for BatchReprise_BookingToMB. This class must be run with the triggers AfterInsertOpportunity and AfterUpdateOpportunity bypassed
* @author: TMA-EIL Cynthia Geagea
* @date: 21/11/2019
*/

@isTest
public class BatchReprise_BookingToMB_Test {
    
    @isTest
    static void batchBookToMBTest(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        
        insert userTest;
        
        System.runAs(userTest){
            
            String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            
            list<opportunity> listMBs = new list<opportunity>();
            list<Opportunity> listBookings = new list<opportunity>();
            list<Account> listPersonAcc = new list<Account>();
            
            Account personAcc1 = new Account(LastName = 'test1', Email__pc = 'test1@asce.com');
            listPersonAcc.add(personAcc1);
            Account personAcc2 = new Account(LastName = 'test2', Email__pc = 'test2@asce.com');
            listPersonAcc.add(personAcc2);
            Account personAcc3 = new Account(LastName = 'test3', Email__pc = 'test3@asce.com');
            listPersonAcc.add(personAcc3);
            Account personAcc4 = new Account(LastName = 'test4', Email__pc = 'test4@asce.com');
            listPersonAcc.add(personAcc4);
            Account personAcc5 = new Account(LastName = 'test5', Email__pc = 'test5@asce.com');
            listPersonAcc.add(personAcc5);
            
            insert listPersonAcc;
            
            hotel__c hotelTest = new Hotel__c();
            hotelTest.Commercial_Hotel_Name__c = 'test hotel';
            insert hotelTest;
            
            for(integer i = 0; i < 5; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
                //NAT to increase code coverage
                if(i == 0) {
                    masterBook.Bookings_Booked_Count__c = 5;
                    /*masterBook.Bookings_Checked_Count__c = 3;
                    masterBook.Bookings_Cancelled_Count__c = 2;
                    masterBook.Bookings_Error_Count__c = 3;
                    masterBook.Bookings_No_Show_Count__c = 4;*/
                }
                else if(i==1){
                    masterBook.Bookings_Checked_Count__c = 1;
                }
                else if(i==2){
                    masterBook.Bookings_Cancelled_Count__c = 2;
                }
                else if(i==3){
                    masterBook.Bookings_Error_Count__c = 2;
                    masterBook.Rooms__c = 2;
                }
                else if(i==4){
                    masterBook.Bookings_No_Show_Count__c = 2;
                    masterBook.Number_of_nights_master__c = 2;
                }
                //
                listMBs.add(masterBook);
            }
            
            insert listMBs;
            
            for(integer j = 0; j <= 4; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Booked',Confirmation_Number__c = '000001', Hotel__c = hotelTest.Id, Booking_Person_account__c = personAcc1.id,
                                                   Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1, Chambre__c = 1, RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[0].id);
                listBookings.add(book);
            }
            
            for(integer j = 0; j <= 4; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Checked',Confirmation_Number__c = '000002', Hotel__c = hotelTest.Id, Booking_Person_account__c = personAcc2.id,
                                                   Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Chambre__c = 1, RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[1].id);
                listBookings.add(book);
            }
            
            for(integer j = 5; j <= 9; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Cancelled',Confirmation_Number__c = '000003', Hotel__c = hotelTest.Id, Booking_Person_account__c = personAcc3.id,
                                                   Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Chambre__c = 1, RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[2].id);
                listBookings.add(book);
            }
            
            for(integer j = 10; j <= 14; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'Error',Confirmation_Number__c = '000004', Hotel__c = hotelTest.Id, Booking_Person_account__c = personAcc4.id,
                                                   Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Chambre__c = 1, RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[3].id);
                listBookings.add(book);
            }
            
            for(integer j = 15; j <= 19; j++){
                
                Opportunity book = new Opportunity(Name = 'BOK'+j, CloseDate = date.today(), StageName = 'No Show',Confirmation_Number__c = '000005', Hotel__c = hotelTest.Id, Booking_Person_account__c = personAcc5.id,
                                                   Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Chambre__c = 1, RecordTypeId = bookingRTId, Master_Booking_FK__c = listMBs[4].id);
                listBookings.add(book);
            }
            
            
            insert listBookings;
            
            test.startTest();
            BatchReprise_BookingToMB batchObj = new BatchReprise_BookingToMB(null,0);
            DataBase.executeBatch(batchObj);
            map<String,String> mapBookId = new map<String,String>();
            mapBookId.put(personAcc1.ID,'Test class error');
            batchObj = new BatchReprise_BookingToMB(mapBookId,0);
            DataBase.executeBatch(batchObj);
            batchObj = new BatchReprise_BookingToMB(mapBookId,3);
            DataBase.executeBatch(batchObj);
            test.stopTest();
            
        }
    }
    
}