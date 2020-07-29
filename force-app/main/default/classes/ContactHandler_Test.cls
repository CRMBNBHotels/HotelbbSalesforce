/** 
* Test class for the ContactHandler Apex Class
* @author  JKA
* @version 0.1
* @date 24/01/2020
*/

@isTest
private class ContactHandler_Test {
    
    private static testMethod void testContHandler()
    {
        account acc = new account();
        acc.Name='nametest';
        acc.BillingCountry='France';
        acc.BillingPostalCode='17200';
        insert acc;
        contact cont = new contact();
        cont.AccountId=acc.id;
        cont.LastName='test';
        cont.MobilePhone='+33 777';
        insert cont ;
        cont.MobilePhone='+1 672345';
        update cont;
        delete cont;
        undelete cont;
    }
    
}