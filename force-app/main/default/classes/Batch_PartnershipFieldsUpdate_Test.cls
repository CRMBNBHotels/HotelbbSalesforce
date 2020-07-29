/*
* Description: Test class for Batch_PartnershipFieldsUpdate , AP03_Opportunity , OpportunityHandler,Batch_DeflagAccount_PartnerFields 
* @author: TMA-EIL CG
* @date: 06-01-2020
*/


@isTest
public class Batch_PartnershipFieldsUpdate_Test {
    
    @isTest
    static void Batch_PartnershipFieldsUpdate(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        
        insert userTest;
        
        System.runAs(userTest){
            String companyAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
            String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            
            
            List<Account> listCompanyAcc = new List<Account>();
            List<Opportunity> listMasterBookings = new List<Opportunity>();
            List<Opportunity> listBookings = new List<Opportunity>();
            
            Account compAcc1 = new Account(Name = 'compAccTest', RecordTypeId = companyAccRTId,TechIsNotFirst_03__c=true);
            listCompanyAcc.add(compAcc1);
            Account compAcc2 = new Account(Name = 'compAccTest2', RecordTypeId = companyAccRTId);
            listCompanyAcc.add(compAcc2);
            insert listCompanyAcc;
            
            Opportunity masterBook1 = new Opportunity(Name = 'masterBookingTest1', Bookings_Checked_Count__c =2, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            listMasterBookings.add(masterBook1);
            Opportunity masterBook2 = new Opportunity(Name = 'masterBookingTest2', Bookings_Checked_Count__c=1, StageName = 'Open', RecordTypeId = masterBookingRTId, CloseDate = Date.Today());
            listMasterBookings.add(masterBook2);
            
            insert listMasterBookings;
            
            Opportunity book1 = new Opportunity(Name = 'Booking1', CloseDate = date.today(), StageName = 'Checked', Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Invoiced_amount__c=100, PartnerCode__c = compAcc1.id, RecordTypeId = bookingRTId,Master_Booking_FK__c=masterBook1.Id);
            listBookings.add(book1);
            
            Opportunity book2 = new Opportunity(Name = 'Booking2',  CloseDate = date.today(), StageName = 'Checked',Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 2,Invoiced_amount__c=50, PartnerCode__c = compAcc1.id, RecordTypeId = bookingRTId,Master_Booking_FK__c=masterBook1.Id);
            listBookings.add(book2);
            
            Opportunity book3 = new Opportunity(Name = 'Booking3',  CloseDate = date.today(), StageName = 'Cancelled',Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 2,Invoiced_amount__c=30, PartnerCode__c = compAcc2.id, RecordTypeId = bookingRTId,Master_Booking_FK__c=masterBook2.Id);
            listBookings.add(book3);
            
            Opportunity book4 = new Opportunity(Name = 'Booking4', CloseDate = date.today(), StageName = 'Checked',Min_Arrival__c = date.today(),Max_Departure__c = date.today() + 1,Invoiced_amount__c=20, PartnerCode__c = compAcc2.id, RecordTypeId = bookingRTId,Master_Booking_FK__c=masterBook2.Id);
            listBookings.add(book4);
            
            insert listBookings;
            
            
            
            
            test.startTest();
            
            map<String,String> mapPAId = new map<String,String>();
            mapPAId.put(listCompanyAcc[0].ID,'Test class error');
            mapPAId.put(listCompanyAcc[1].ID,'Test class error');
            
            Batch_PartnershipFieldsUpdate batchObj = new Batch_PartnershipFieldsUpdate(mapPAId,0);
            DataBase.executeBatch(batchObj);
            
            database.delete(listBookings[1].ID, false);
            
            batchObj = new Batch_PartnershipFieldsUpdate(mapPAId,3);
            DataBase.executeBatch(batchObj);
            
            String[] toAddresses = new String[] {'cynthia.geagea@ei-technologies.com'};
                String Subject = 'Batch Error : Batch_PartnershipFieldsUpdate ';
            
            Utils_Email.sendEmailApex(toAddresses, Subject,mapPAId);
            
            test.stopTest();
            
            
        }
    }
}