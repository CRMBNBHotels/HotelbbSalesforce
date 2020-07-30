/*
* Description: Test Class for BB_BillObject
* @author: TMA-EI JK
* @date: 021/04/2020
*/
@istest
public class BB_BillObject_test {
    @isTest
    static void testCallBBBillObject() {
        Account accObj =  Utils.CreatePersonAccount('Person',null);  
        accobj.Externalid__c = '1234';
        insert accObj;
        
        BB_BillObject bbbillObj = new BB_BillObject();
        String endPoint = bbbillObj.initializeRequestEndpoint();
        String endPointVouch = bbbillObj.initializeRequestEndpointUpdate();
        String body = bbbillObj.initializeRequestBody(true, '3', accObj.Id,null, null);
        String strResponse = '{"bb:BillDownloadRS": { "bb:Success": {},"bb:BillDownload": [{"@Amount": "39","@Currency": "EUR", "@EmissionDate": "2020-04-03 15:18:49.0","@Link": "https://bb-hprod-sftp.s3.eu-central-1.amazonaws.com/PPROD/FR/2020/04/03/club_FR20_758.pdf?response-content-disposition=filename%3DFR%2F2020%2F04%2F03%2Fclub_FR20_758.pdf&response-content-type=application%2Fpdf&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20200421T092649Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3599&X-Amz-Credential=AKIAW7KG5VFJM3NSLSKD%2F20200421%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Signature=914ef4e6e070a2245afbcbef540245d5000184a198f6cb8bfd781d51ac00f4e5","@Type": "CLUB","@Wording": "FR/2020/04/03/club_FR20_758.pdf"}]}}';
        DataTableWrapper wrapper = bbbillObj.createTableFromResponse(strResponse);
        String BodyError = '{ "bb:BillDownloadRS": {"bb:Success": {},"bb:BillDownload": [], "bb:Errors": { "bb:Error": [{"*body": "Email empty or invalid (should respect regex email address)", "@Type": "3", "@ShortText": "Email address is invalid", "@Code": "244",  "@CodeError": "54" }  ] }}}';
        DataTableWrapper badWrapper = bbbillObj.createTableFromBadResponse(BodyError,400);

    }
}