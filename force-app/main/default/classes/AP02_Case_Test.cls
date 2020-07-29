/**
* 
* @version 1.00 07/12/2017
* @author Jenny Jawhar
* @CodeCoverage 100%
*/
@isTest
public class AP02_Case_Test 
{
    public static testMethod void InsertUpdateCase()
    {
        Account Partner = Utils.CreatePartnerAccount('Partner', '124');
        insert Partner;
        Account person = Utils.CreatePersonAccount('Person',null);
        insert person;
        Case cas = Utils.CreateCase();
        cas.Type = label.Information_request;
        cas.AccountId = person.Id;
        insert cas;
        Case cas1 = [Select Id, ContactId
                     From Case
                     Where Id =: cas.Id];
        system.assertEquals(person.PersonContactId, cas.ContactId);
    }
}