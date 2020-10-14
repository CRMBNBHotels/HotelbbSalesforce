/**
* 
* @version 13/09/2019
* @author TMA-EI - PG
* @CodeCoverage :
*/


@isTest
public class Account_Handler_Test {
    public static testMethod void checkEClubStatus()
    {
        //it's a test
        Account acc1=new Account();
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.LastName='test';
        acc1.E_club_Expiration_date__pc=date.today();
        insert acc1;
        List<Account> listAcc=new list<Account>();
        listAcc.add(acc1);
        Account_Handler.handle(listAcc,null);
        
        Account acc2=new Account();
        acc2.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc2.LastName='test';
        acc2.E_club_Expiration_date__pc=date.today().adddays(+2);
        insert acc2; 
        Map<ID,Account> mapAcc=new Map<ID,Account>();
        mapAcc.put(acc2.id,acc2);
        mapAcc.put(acc1.id,acc1);
        listAcc.add(acc2);
        Account_Handler.handle(listAcc,mapAcc);
    }
}