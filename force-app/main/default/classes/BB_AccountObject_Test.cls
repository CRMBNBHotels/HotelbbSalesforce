@isTest
public class BB_AccountObject_Test {
    @isTest
    static void testCallBBAccountObject() {
        BB_AccountObject bbAccountObj = new BB_AccountObject();
        Account accObj =  Utils.CreatePersonAccount('Person',null);  
        accobj.Externalid__c = '1234';
        insert accObj;
        accObj.FirstName = 'test name update';
        accObj.lastname = 'test name update';
        //accObj.Email__pc = 'Email@testUpdate.com';
        //accObj.E_mail_address_2__pc = 'Email@testUpdate.com';
        accObj.PersonMobilePhone = '+33 123';
        accObj.Mobile_Phone_Number_2__pc = '+33 123';
        accObj.PersonMailingCity = 'GUIPAVAS';
        accObj.PersonMailingCountry = 'France';
        //accObj.PersonMailingState = 'Nouvelle-Aquitaine';
        accObj.PersonMailingPostalCode = '29490';
        accObj.PersonMailingStreet = '75 rue Jansen';
        update accObj;
        String endPoint = bbAccountObj.initializeRequestEndpointUpdate();
        Set<String> setFields = new set<String>();
        setFields.add('firstname');
        setFields.add('email__pc');
        setFields.add('E_mail_address_2__pc');
        setFields.add('lastname');
        setFields.add('PersonMobilePhone');
        setFields.add('Mobile_Phone_Number_2__pc');
        setFields.add('PersonMailingCity');
        setFields.add('PersonMailingCountry');
        setFields.add('PersonMailingPostalCode');
        setFields.add('PersonMailingState');
        setFields.add('PersonMailingStreet');
        String body = bbAccountObj.initializeRequestBody(null, null, accObj.externalid__c,setFields, null);
        String strResponse = '{"bb:UpdateClientRS": {"bb:Errors": {"bb:Error": [{"*body": "Email empty or invalid","@Type": "1","@ShortText": "Email address is invalid","@Code": "244"}]},"@TimeStamp": "2019-05-09T11:02:09Z"},"bb:Headers": {"@ApiKey": "edf5c0d2-b5ea-47ee-b3d7-92af3122cc95"}}';
        Account accRollBack = bbAccountObj.actionBadResponse( strResponse, (String)accObj.id,setFields); 
        system.debug('###cyn accRollBack'+accRollBack);
        bbAccountObj.actionGoodResponse(strResponse);
        
        BB_AccountObject.UpdateClientRS wrapperTest = new BB_AccountObject.UpdateClientRS();
        wrapperTest.Success = new BB_AccountObject.Success();
        wrapperTest.TimeStamp = 'TimeStamp';
        //wrapperTest.LoyaltyPointRS = new BB_AccountObject.LoyaltyPointRS();
        BB_AccountObject.PrefCollections prefColls = new BB_AccountObject.PrefCollections();
        BB_AccountObject.PrefCollection prefColl = new BB_AccountObject.PrefCollection();
        BB_AccountObject.CommonPref commPref = new BB_AccountObject.CommonPref();
        BB_AccountObject.OtherSrvcPref OSP = new BB_AccountObject.OtherSrvcPref();
    }

}