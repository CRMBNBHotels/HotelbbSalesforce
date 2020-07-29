/*
* Description: Test class for Batch_FirstLastBooking
* @author: TMA-EIL Cynthia Geagea
* @date: 24/12/2019
*/

@isTest
public class Batch_FirstLastBooking_Test {
    
    @isTest
    static void batchUpdatePATest(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        
        insert userTest;
        
        System.runAs(userTest){
            
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            String personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            
            list<Account> listPersonAcc = new list<Account>();
            
            for(integer i = 0; i < 5; i++){
                
                Account acc = new Account(LastName = 'accTest'+i, Email__pc = 'testAcc'+i+'@asce.com', RecordTypeId = personAccRTId);
                listPersonAcc.add(acc);
            }
            
            insert listPersonAcc;
            
            list<Opportunity> listMBs =  new list<Opportunity>();
            
             for(integer i = 0; i <= 4; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, Departure_Date__c = Date.Today().addDays(i), Person_Account__c = listPersonAcc[0].Id, CloseDate = date.today(), Bookings_Checked_Count__c = 1);
                listMBs.add(masterBook);
            }
            for(integer i = 0; i <= 4; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, Departure_Date__c = Date.Today().addDays(i), Person_Account__c = listPersonAcc[1].Id, CloseDate = date.today(), Bookings_Checked_Count__c = 1);
                listMBs.add(masterBook);
            }
            for(integer i = 0; i <= 4; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, Departure_Date__c = Date.Today().addDays(i), Person_Account__c = listPersonAcc[2].Id, CloseDate = date.today(), Bookings_Checked_Count__c = 1);
                listMBs.add(masterBook);
            }
            for(integer i = 0; i <= 4; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, Departure_Date__c = Date.Today().addDays(i), Person_Account__c = listPersonAcc[3].Id, CloseDate = date.today(), Bookings_Checked_Count__c = 1);
                listMBs.add(masterBook);
            }
            for(integer i = 0; i <= 4; i++){
                
                Opportunity masterBook = new Opportunity(Name = 'masterBookingTest'+i, StageName = 'Open', RecordTypeId = masterBookingRTId, Departure_Date__c = Date.Today().addDays(i), Person_Account__c = listPersonAcc[4].Id, CloseDate = date.today(), Bookings_Checked_Count__c = 1);
                listMBs.add(masterBook);
            }
            
            insert listMBs;
            
            test.startTest();
                
                Batch_FirstLastBooking batchObj = new Batch_FirstLastBooking(null,0);
                DataBase.executeBatch(batchObj);
            
                listMBs[0].Person_Account__c = listPersonAcc[1].Id;
                update listMBs;
                
                batchObj = new Batch_FirstLastBooking(null,0);
                DataBase.executeBatch(batchObj);
            
                map<String,String> mapPAId = new map<String,String>();
                mapPAId.put(listPersonAcc[0].ID,'Test class error');
            
                batchObj = new Batch_FirstLastBooking(mapPAId,0);
                DataBase.executeBatch(batchObj);
            
                batchObj = new Batch_FirstLastBooking(mapPAId,3);
                DataBase.executeBatch(batchObj);
            
                database.delete(listMBs[1].ID, false);
            
                batchObj = new Batch_FirstLastBooking(mapPAId,4);
                DataBase.executeBatch(batchObj);
            
                String[] toAddresses = new String[] {'cynthia.geagea@ei-technologies.com'};
                String Subject = 'Batch Error : Batch_FirstLastBooking ';
            
                Utils_Email.sendEmailApex(toAddresses, Subject,mapPAId);
            
            test.stopTest();
        }
    }

}