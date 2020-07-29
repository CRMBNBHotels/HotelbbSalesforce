/*
* Description: Test class for BatchReprise_WebToCase
* @author: Cynthia Geagea
* @date: 14/05/2019
*/

@isTest
public class BatchReprise_WebToCase_Test {
    
    @isTest
    static void batchUpdateAccTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        u.BypassValidationRule__c = true;
        insert u;
        
        System.runAs(u){
            
            List<Account> lstAccount= new List<Account>();
            Id GuestAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.PersonAccountDeveloperName).getRecordTypeId();
            Id CompanyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            Account account = new Account(Name = 'TestAccount', RecordTypeId = CompanyAccountRecordTypeId, BillingCountry = 'Algeria', BillingPostalCode='1');
            insert account;
            
            for(Integer i=0 ;i <100;i++){
                
                String lstName = 'TestPersonEmailNull'+i;
                Account acc = Utils.CreatePersonAccount(lstName, account.Id);
                acc.Email__pc ='TestPersonEmailNull' + i + '@asce.com';
                acc.PersonEmail = null;
                acc.Externalid__c = 'aaa'+i;
                lstAccount.add(acc);
                
            }
            
            for(Integer i=0 ;i <100;i++){
                
                String lstName = 'TestEmailpcNull'+i;
                Account acc = Utils.CreatePersonAccount(lstName, account.Id);
                acc.PersonEmail ='TestEmailpcNull' + i + '@asce.com';
                acc.Email__pc = null;
                acc.Externalid__c = 'bbb'+i;
                lstAccount.add(acc);
                
            }
            
            insert lstAccount;
            
            Test.startTest();
            BatchReprise_WebToCase batchObj = new BatchReprise_WebToCase();
            DataBase.executeBatch(batchObj);
            Test.stopTest();
            
        }   
        
    }
}