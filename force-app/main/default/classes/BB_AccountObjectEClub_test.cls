@isTest
public class BB_AccountObjectEClub_test {
    @isTest
    static void testCallBBAccountObjectEClub() {
        BB_AccountObjectEClub bbAccountObj = new BB_AccountObjectEClub();
        Account accObj =  Utils.CreatePersonAccount('Person',null);  
        accobj.Externalid__c = '1234';
        insert accObj;
        accObj.E_Club_Status__c = '	Closed';
        accObj.E_club_Expiration_date__pc = Date.today();
        update accObj;
        String endPoint = bbAccountObj.initializeRequestEndpointUpdate();
        Set<String> setFields = new set<String>();
        setFields.add('E_Club_Status__c');
        setFields.add('E_club_Expiration_date__pc');
        String body = bbAccountObj.initializeRequestBody(null, null, accObj.externalid__c,setFields, null);
        String strResponse = '{ "bb:UpdateClubRS": { "bb:Errors": { "bb:Error": [{ "*body": "Missing at least one parameter","@Type": "3","@ShortText": "Required Field missing","@Code": "321"}]},"@TimeStamp": "2019-05-14T04:21:53Z"}}';
        Account accRollBack = bbAccountObj.actionBadResponse( strResponse, (String)accObj.id,setFields); 
        strResponse = '{"bb:UpdateClubRS": { "bb:Success":{}}}';
        bbAccountObj.actionGoodResponse(strResponse);
        
    }
}