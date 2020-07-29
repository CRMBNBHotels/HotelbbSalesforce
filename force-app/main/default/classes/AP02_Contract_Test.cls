@isTest
public class AP02_Contract_Test 
{
    @isTest
    public static void fillContactAndAccountTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
            
            list<contract> listContracts = new list<contract>();
            list<opportunity> listOpps = new list<opportunity>();
            list<account> listPA = new list<account>();
            
            String companyAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            String corporateOppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            String corporateContRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            
            Account compAcc = new Account(Name = 'compAccTest', RecordTypeId = companyAccRTId);
            insert compAcc;
             Account compAcc2 = new Account(Name = 'compAccTest2', RecordTypeId = companyAccRTId);
            insert compAcc2;
            
            Account persAcc1 = utils.CreatePersonAccount('perAcc1test', compAcc.Id);
            listPA.add(persAcc1);
            Account persAcc2 = utils.CreatePersonAccount('perAcc2test', compAcc.Id);
            listPA.add(persAcc2);
            
            Opportunity opp1 = new opportunity(Name = 'oppTest', recordTypeId = corporateOppRTId, AccountId = compAcc.Id, StageName = 'Qualification',CloseDate = Date.Today());
            opp1.AccountId = compAcc.Id;
            system.debug('### opp 1 before ' + opp1);
            listOpps.add(opp1);
            Opportunity opp2 = new opportunity(Name = 'oppTest', recordTypeId = corporateOppRTId, AccountId = compAcc.Id, StageName = 'Qualification',CloseDate = Date.Today());
            listOpps.add(opp2);
            insert listOpps;
            system.debug('### opp 1 ' + opp1);
            Contract cont = new Contract(recordTypeId = corporateContRTId, Opportunity__c = opp1.Id, AccountId = compAcc.Id, Corporate_Code__c = '521dds5');
            cont.AccountId = compAcc.Id;
            listContracts.add(cont);
            system.debug('### cont ' + cont);
            test.startTest();
            
            insert listContracts;
            
            cont.Opportunity__c = opp2.Id;
            update listContracts;
            
            opp2.AccountId = compAcc2.id;
            update opp2;
             //added	
            delete listContracts;
            test.stopTest();
            
            
        }
        
    }
}