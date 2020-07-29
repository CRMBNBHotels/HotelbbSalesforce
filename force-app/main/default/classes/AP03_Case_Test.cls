/*
* Description: Test Class for AP03_Case 
* @author: TMA-EI Cynthia Geagea
* @date: 03/06/2019
*/

@isTest
public class AP03_Case_Test {
    
    @isTest
    Public Static void AssignCaseToUserTest(){
        
        /*Database.DMLOptions dmo = new Database.DMLOptions();
          dmo.assignmentRuleHeader.useDefaultRule= true;*/
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        u.BypassValidationRule__c = true;
        insert u;
        
        system.runAs(u){
            
            Hotel__c hotel = Utils.CreateHotel('Hotel');
            hotel.Email__c = 'hotel@asce.com';
            hotel.Country__c = label.FR;
            hotel.Commercial_Hotel_Name__c='testHotel';
            insert hotel;
            
            list<Case> listCaseToInsert = new list<Case>();
            
            Case cas = Utils.CreateCase();
            cas.Origin = 'Web';
            cas.Type = label.Information_request;
            cas.Status = 'Open';
            cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
            cas.Hotel_ID__c = hotel.Hotel_ID__c;
            cas.SuppliedEmail = 'customerTest@asce.com';
            cas.First_Name__c = 'First';
            cas.Last_Name__c = 'Last';
            cas.Concerned_country__c = 'IT';
            //cas.setOptions(dmo);
            listCaseToInsert.add(cas);
            
            Case cas1 = Utils.CreateCase();
            cas1.Origin = 'Web';
            cas1.Type = label.Information_request;
            cas1.Status = 'Open';
            cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
            cas1.Hotel_ID__c = hotel.Hotel_ID__c;
            
            cas1.SuppliedEmail = 'customerTest1@asce.com';
            cas1.Concerned_country__c = 'FR';
            cas1.First_Name__c = 'First1';
            cas1.Last_Name__c = 'Last1';
            //cas1.setOptions(dmo);
            listCaseToInsert.add(cas1);
            
            Case cas2 = Utils.CreateCase();
            cas2.Origin = 'Web';
            cas2.Status = 'Open';
            cas2.Type = label.Information_request;
            //cas2.SuppliedEmail = 'customerTest2@asce.com';
            cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
            //cas2.Hotel_ID__c = hotel.Hotel_ID__c;
            cas2.First_Name__c = 'First2';
            cas2.Last_Name__c = 'Last2';
            cas2.Concerned_country__c = 'ES';
            cas2.E_club_ID__c = 'E-club ID';
            cas2.SuppliedPhone = '123456';
            cas2.Guest_Adress__c = 'testAddress';
            cas2.Zip_code__c = '000';
            cas2.City__c = 'testCity';
            cas2.Country__c = 'testCountry';
            cas2.Description = 'testDescription';
            cas2.Arrival_Date__c = date.today() + 1;
            cas.Departure_date__c = date.today();
            //cas2.setOptions(dmo);
            listCaseToInsert.add(cas2);
            
            insert listCaseToInsert;
            
            List<Group> queueIds = [Select Id from Group
                                    Where Name = 'Italy Service Agent' or Name = 'French Queue hotel case' or Name = 'Spain Queue Hotel Case' ];
            
            listCaseToInsert[0].OwnerId = queueIds[0].Id;
            listCaseToInsert[1].OwnerId = queueIds[1].Id;
            listCaseToInsert[2].OwnerId = queueIds[2].Id;
            
            update listCaseToInsert;
            
            
        }
    }
    
}