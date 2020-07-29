/**
* 
* @version 09/09/2019
* @author TMA-EI - PG
* @CodeCoverage :
*/


@isTest
public class AP08_Account_Test {
	 public static testMethod void insertAccount()
     {
         Account acc1=new Account();
         acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
         acc1.LastName='test';
         acc1.E_club_Expiration_date__pc=date.today();
         insert acc1;
         
         
         Account acc2=new Account();
         acc2.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
         acc2.LastName='test';
         insert acc2; 
         
         acc2.E_club_Expiration_date__pc=date.today();
         update acc2;
         acc2.E_club_Expiration_date__pc=date.today().addDays(+40);
         update acc2;
          acc2.E_club_Expiration_date__pc=date.today().addDays(-40);
         update acc2;
     }
}