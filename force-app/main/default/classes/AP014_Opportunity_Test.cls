/*
* Description: Test Class for AP014_Opportunity 
* @author: TMA-EI jka
* @date: 29/11/2019
* @coverage :100%
*/
@isTest
public class AP014_Opportunity_Test {
    @isTest
    public static void testMethod1(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            list<opportunity> listOpps = new list<opportunity>();
            list<account> listPA = new list<account>();
            list<contract> listContracts = new list<contract>();
           
            String companyAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            String corporateOppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            String corporateContRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            
            Account compAcc1 = new Account(Name = 'compAccTest', RecordTypeId = companyAccRTId);
            insert compAcc1;
             Account compAcc2 = new Account(Name = 'compAccTest2', RecordTypeId = companyAccRTId);
            insert compAcc2;
            
            Account persAcc1 = utils.CreatePersonAccount('perAcc1test', compAcc1.Id);
            listPA.add(persAcc1);
            Account persAcc2 = utils.CreatePersonAccount('perAcc2test', compAcc1.Id);
            listPA.add(persAcc2);
            
            Opportunity opp1 = new opportunity(Name = 'oppTest', recordTypeId = corporateOppRTId, AccountId = compAcc1.Id, StageName = 'Qualification',CloseDate = Date.Today());
            opp1.AccountId = compAcc1.Id;
            listOpps.add(opp1);
            Opportunity opp2 = new opportunity(Name = 'oppTest', recordTypeId = corporateOppRTId, AccountId = compAcc1.Id, StageName = 'Qualification',CloseDate = Date.Today());
            listOpps.add(opp2);
            insert listOpps;
            Contract cont = new Contract(recordTypeId = corporateContRTId, Opportunity__c = opp1.Id, AccountId = compAcc1.Id, Corporate_Code__c = '521dds5');
            cont.AccountId = compAcc1.Id;
            listContracts.add(cont);
            test.startTest();
            
            insert listContracts;
            
            cont.Opportunity__c = opp2.Id;
            update listContracts;
            
            opp2.AccountId = compAcc2.id;
            update opp2;
            test.stopTest();
        }
    }
}