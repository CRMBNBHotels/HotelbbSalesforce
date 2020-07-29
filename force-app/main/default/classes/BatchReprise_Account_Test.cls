/*
* Description: Test class for BatchReprise_Account
* @author: Cynthia Geagea
* @date: 26/06/2019
*/

@isTest
public class BatchReprise_Account_Test {
    
    @isTest
    static void batchRepriseAccTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        u.BypassValidationRule__c = true;
        insert u;
        
        System.runAs(u){
            
            Id GuestAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.PersonAccountDeveloperName).getRecordTypeId();
            Id CompanyAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            Account account = new Account(Name = 'TestAccount', RecordTypeId = CompanyAccountRTId, BillingCountry = 'Algeria', BillingPostalCode='1');
            insert account;
            
            List<Account> listAcc = new List<Account>();
            
            For(Integer i = 0; i<100; i++){
                
                String lstName = 'TestPersonEmailNull'+i;
                Account acc = Utils.CreatePersonAccount(lstName, account.Id);
                listAcc.add(acc);
            }
            
            insert listAcc;
            
            For(Account acc : listAcc){
                
                acc.Data_History__c = null;
            }
            
            update listAcc;
            
            Test.startTest();
            BatchReprise_Account batchObj = new BatchReprise_Account();
            DataBase.executeBatch(batchObj);
            Test.stopTest();
        }
        
    }

}