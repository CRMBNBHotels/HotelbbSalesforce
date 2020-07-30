/*
* Description: Test Class for BB_AccountObjectPoints 
* @author: TMA-EI Cynthia Geagea
* @date: 28/05/2019
*/

@isTest
public class BB_AccountObjectPoints_Test {
    
    @isTest
    static void testCallBBAccountObjectPoints() {
        BB_AccountObjectPoints bbAccountObj = new BB_AccountObjectPoints();
        Account accObj =  Utils.CreatePersonAccount('Person',null);  
        accobj.Externalid__c = '201339';
        String ExtId = String.valueOf(accobj.Externalid__c);
        system.debug('ExtId'+ExtId+' '+'accobj.Externalid__c'+accobj.Externalid__c);
        accobj.Email__pc = 'test@asce.com';
        accobj.Tech_points_results__c = '{"typePt":"Ajout","sobj":{"attributes":{"type":"Account","url":"/services/data/v46.0/sobjects/Account/0014E000011OIycQAG"},"Point_Request__c":"Processing","E_club_Number_of_points__pc":125.0,"Tech_BBUS__c":true,"Id":"0014E000011OIycQAG"},"Reason":"Annulation échange cadeau","nbPoint":5}';
        insert accObj;
        system.debug('accObj.Id'+accObj.Id);
        accObj.E_club_Number_of_points__pc = 100;
        update accObj;
        String endPoint = bbAccountObj.initializeRequestEndpointUpdate();
        Set<String> setFields = new set<String>();
        setFields.add('E_club_Number_of_points__pc');
        String body = bbAccountObj.initializeRequestBody(null, null, ExtId,setFields,null);
        system.debug('body'+bbAccountObj.initializeRequestBody(null, null, ExtId,setFields,null));
        String strResponse = '{"bb:UpdateWalletRS": {"bb:Errors": {"bb:Error": [{"*body": "Email address is already linked to an existing account","@Type": "1","@ShortText": "Email address is invalid","@Code": "244"}]},"@TimeStamp": "2019-05-28T10:36:36Z"}}';
        Account accError = bbAccountObj.actionBadResponse( strResponse, (String)accObj.id,setFields); 
        strResponse = '{"bb:UpdateWalletRS": {"bb:Success": {}}}';
        bbAccountObj.actionGoodResponse(strResponse);
        
    }

}