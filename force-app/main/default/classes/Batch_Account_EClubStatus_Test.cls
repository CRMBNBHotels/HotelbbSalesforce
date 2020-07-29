/*
* Description: Test class for Batch_Account_EClubStatus 
* @author: TMA-EI JKA
* @date: 21/10/2019
*/

@isTest
public class Batch_Account_EClubStatus_Test {
    
    @isTest
    static void batchUpdateEclubStatus(){
        List<Account> lstAccount= new List<Account>();
        Id PersAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Account acc1=new Account();
        acc1.RecordTypeId=PersAccRecTypeId;
        acc1.LastName='test1';
        acc1.E_club_Expiration_date__pc=date.today();
        lstAccount.add(acc1);
        
        Account acc2=new Account();
        acc2.RecordTypeId=PersAccRecTypeId;
        acc2.LastName='test2';
        acc2.E_club_Expiration_date__pc=date.today().addDays(+30);
        lstAccount.add(acc2);
        
        Account acc3=new Account();
        acc3.RecordTypeId=PersAccRecTypeId;
        acc3.LastName='test3';
        acc3.E_club_Expiration_date__pc=date.today().addDays(+60);
        lstAccount.add(acc3);
        
        Account acc4=new Account();
        acc4.RecordTypeId=PersAccRecTypeId;
        acc4.LastName='test4';
        acc4.E_club_Expiration_date__pc=date.today().addDays(-60);
        lstAccount.add(acc4);
        
        Account acc5=new Account();
        acc5.RecordTypeId=PersAccRecTypeId;
        acc5.LastName='test5';
        acc5.E_club_Expiration_date__pc=date.today().addDays(-10);
        lstAccount.add(acc5);
        
        insert lstAccount;
        
        Test.startTest();
        Batch_Account_EClubStatus batchObj = new Batch_Account_EClubStatus();
        DataBase.executeBatch(batchObj);
        Test.stopTest();
    }
    
}