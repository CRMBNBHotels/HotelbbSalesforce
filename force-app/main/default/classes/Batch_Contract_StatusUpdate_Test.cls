/*
* Description: Test class for Batch_Contract_StatusUpdate
* @author: TMA Cynthia Geagea
* @date: 31/10/2019
*/

@isTest
public class Batch_Contract_StatusUpdate_Test {
    
    @isTest
    static void batchContractStatusUpdateTest(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = prof.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        userTest.BypassValidationRule__c = true;
     //   u.BypassApex__c = true;
        userTest.BypassWorkflow__c = true;
        insert userTest;
       date TodayDate = date.today();
        system.debug('@@@@@ test TODAY '+TodayDate);
        System.runAs(userTest){

            Id CompanyAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();system.debug('### cg CompanyAccountRTId'+CompanyAccountRTId);
            Id CarteLogeRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Carte_Log_e').getRecordTypeId();system.debug('### cg CarteLogeRTId'+CarteLogeRTId);
            Id CorporateRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
             Id CorporateRTI2 = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            
            Account acc = new Account(Name = 'TestAccount', RecordTypeId = CompanyAccountRTId, BillingCountry = 'Algeria', BillingPostalCode='1');
            insert acc;
            system.debug('#### accc'+acc);
            Opportunity opp = new Opportunity(Name = 'TestOpportunity',RecordTypeId = CorporateRTId, AccountId = acc.id, StageName = 'Booked', CloseDate = date.valueOf('2019-08-25'));
            insert opp;
            system.debug('#### opp.account'+opp.account);
            List<Contract> listContracts = new List<Contract>();
            
            For(Integer i = 0; i<100; i++){
                
                Contract cont = Utils.CreateContract();
                cont.RecordTypeId = CorporateRTI2;
                cont.StartDate = TodayDate.addMonths(-3);
                cont.StartDate = cont.StartDate.adddays(+1);
                cont.Status = 'Draft';
                cont.ContractTerm = 5;
                cont.name = 'dbfbf'+ i;
                //cont.enddate = TodayDate.addMonths(-5);
                cont.AccountId = acc.Id;
                cont.Opportunity__c = opp.Id;
                cont.Corporate_Code__c = '1242r'+i;
                system.debug('### jka AccountId'+cont.AccountId);
                system.debug('@@@@@ test Expiration_Date__c '+cont.enddate);
                system.debug('@@@@@ test22222 TODAY '+TodayDate.addMonths(2));
                listContracts.add(cont);
            }
            
        
            
            insert listContracts;
            
            Test.startTest();
            Batch_Contract_StatusUpdate batchObj = new Batch_Contract_StatusUpdate();
            DataBase.executeBatch(batchObj);
            Test.stopTest();
        }
    }

}