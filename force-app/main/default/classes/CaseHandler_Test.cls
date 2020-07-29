/** 
* Test class for the Case Handler Apex Class
* @author JKA 
* @version 0.1
* @date 24/01/2020 
*/

@isTest
private class CaseHandler_Test {
    
     public static testMethod void testCaseHandler()
    {
        Account Partner = Utils.CreatePartnerAccount('Partner', '124');
        insert Partner;
        Account person = Utils.CreatePersonAccount('Person',null);
        insert person;
        Case cas = Utils.CreateCase();
        cas.Type = label.Information_request;
        cas.AccountId = person.Id;
        insert cas;
        cas.Type=null;
        update cas;
        delete cas;
        undelete cas;
    }
}