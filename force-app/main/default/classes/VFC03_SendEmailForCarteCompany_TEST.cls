/**
*  Test class for the VFC03_SendEmailForCarteCompany Apex Class
* @version 1.00 24/2/2020
* @author
* @CodeCoverage 92%
*/

@isTest
public class VFC03_SendEmailForCarteCompany_TEST {
    
   static testMethod void  sendEmail_Test() {
    account acc = new account();
    acc.name = 'testacc';
    insert acc;
    
    contact cont = new contact();
    cont.Lastname  = 'testname';
    cont.Email = 'testtt@test.test';
    insert cont;
    
    
    Contract contr = new Contract();
    contr.Contact__c = cont.id;
    contr.AccountId = acc.Id;
    contr.StartDate = date.today();
    insert contr;
    

       
       Test.setCurrentPageReference(new PageReference('VFP03_SendEmailForCarteCompany'));
	   apexPages.Currentpage().getParameters().put('ContactId',cont.id);      

       
       VFC03_SendEmailForCarteCompany vfc = new VFC03_SendEmailForCarteCompany();

       Test.StartTest();
       vfc.Send();
       Integer invocations = Limits.getEmailInvocations();
       Test.stopTest();
	   System.assertEquals(1, invocations, 'No email has been sent');

    }

}