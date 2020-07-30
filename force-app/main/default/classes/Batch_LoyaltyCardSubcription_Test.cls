/**
* 
* @version 1.00 09/08/2018
* @author Joyce Saidy
* @CodeCoverage 88%
*/
@isTest
public class Batch_LoyaltyCardSubcription_Test {
    static testMethod void testLoyaltyCardSubcription(){
        
        Account acc = new account();
        acc.lastName='Test';
        acc.RecordTypeId=Label.PersonAccountRecordTypeId; 
        insert acc;
        
        Loyalty_Card__c LC= new Loyalty_Card__c();
        LC.Person_Account__c=acc.id;
        LC.E_Club_Start_Date__c=system.today();
        LC.E_Club_Renewal_Period_End_Date__c=system.today();
        insert LC;
        
        Test.startTest();
        Database.executeBatch(new Batch_LoyaltyCardSubcription());
        Test.stopTest(); 
        
    }
}