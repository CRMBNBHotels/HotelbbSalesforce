@istest
public class BB_VoucherObject_test {
    @isTest
    static void testCallBBVoucherObject() {
        BB_VoucherObject bbvoucherObj = new BB_VoucherObject();
        BB_VoucherObject bbvoucherObjIR = new BB_VoucherObject();
        Account accObj = new Account(Name='testAccount',BillingCountry='Germany',BillingPostalCode='12345');
        insert accObj;
        
        Account accObjIR = new Account(Name='testAccountIR',BillingCountry='Germany',BillingPostalCode='12345');
        insert accObjIR;
        
        String EClubRecordTypeId = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.VoucherRecordType_EClub).getRecordTypeId();
        string IRRecordTypeID = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
        
        Voucher__c vouchObj = new Voucher__c(RecordTypeId = EClubRecordTypeId, Email_du_client__c = 'test@asce.com');
        vouchObj.Externalid__c = 'a0C4E000004KoUU';
        insert vouchObj;
        vouchObj.Statut__c = 'Consommé(e)';
        update vouchObj;
        
        Voucher__c vouchObjIR = new Voucher__c(RecordTypeId = IRRecordTypeID, Email_du_client__c = 'testIR@asce.com');
        vouchObjIR.Externalid__c = 'a0C4E000004KoUU001v';
        insert vouchObjIR;
        vouchObjIR.Statut__c = 'Consommé(e)';
        update vouchObjIR;
        
        String endPoint = bbvoucherObj.initializeRequestEndpoint();
        String endPointVouch = bbvoucherObj.initializeRequestEndpointUpdate();
        
        String endPointIR = bbvoucherObjIR.initializeRequestEndpoint();
        String endPointVouchIR = bbvoucherObjIR.initializeRequestEndpointUpdate();
        
        Set<String> setFields = new set<String>();
        setFields.add('Statut__c');
        
        String body = bbvoucherObj.initializeRequestBody(true, '3', accObj.Id,null, null);
        String strResponse = '{"bb:VoucherRS": {"bb:Voucher":[{"@IDBooking": null,"@IDCRS":[],"@IDVoucher":"88","@Points":"1000","@Type":"Eclub","@GeneratedCode":"ECLEA1RtmI81sKnHf","@GeneratedDate":"2018-01-20 00:00:00.0","@Status":"Expired","@ExpireDate":"2019-01-20","bb:VoucherDetail":[{"@Country": "EA","@IDVoucherCountry": "31","@MaxDiscount": "60","bb:Schedule": {"@Monday": "true","@Tuesday": "true","@Wednesday": "true","@Thursday": "true","@Friday": "true","@Saturday": "true","@Sunday": "true","@ObservanceDay": "true","@Holiday": "true"},"bb:Prestations": [{"@Category": "BREAKFAST","@Code": "2B","@Quantity": "2"},{"@Category": "ROOM","@Code": "1R","@Quantity": "1"}]}]}],"@PageKey": "304","bb:Success": {}},"bb:Headers": {"@ApiKey": "df5c0d2-b5ea-47ee-b3d7-92af3122cc95"}}';
        DataTableWrapper wrapper = bbvoucherObj.createTableFromResponse(strResponse);
        String BodyError = '{  "bb:VoucherRS": { "bb:Errors": {   "bb:Error": [ {  "*body": "Id Person Account empty or invalid", "@Type": "10",  "@ShortText": "Invalid customer number",   "@Code": "237"          }   ] },   "@TimeStamp": "2019-05-03T11:51:24Z" }, "bb:Headers": {  "@ApiKey": "edf5c0d2-b5ea-47ee-b3d7-92af3122cc95"}}';
        DataTableWrapper badWrapper = bbvoucherObj.createTableFromBadResponse(BodyError,400);
        
        String bodyVouch = bbvoucherObj.initializeRequestBody(null, null, vouchObj.Externalid__c,setFields, null);
        String strResponseVouchGood = '{"bb:UpdateVoucherRS": {"bb:Voucher": [{"@IDBooking": null,"@IDVoucher": "561","@Points": "1000","@Type": "Eclub","@GeneratedCode": "ECLEA1RZ4Z5xmWyIb","@GeneratedDate": "2019-04-11 04:07:54.0","@Status": "Used","@ExpireDate": "2020-05-08","bb:VoucherDetail": [{"@Country": "EA","@IDVoucherCountry": "31"}]}],"bb:Success": {}}}';
        String strResponseVouchBad = '{"bb:UpdateVoucherRS": {"bb:Errors": {"bb:Error": [{"*body": "generateCode invalid","@Type": "3","@ShortText": "GenerateCode is invalid","@Code": "320"}]},"@TimeStamp": "2019-05-10T04:49:51Z"}}';
        Voucher__c vouchRollBack = bbvoucherObj.actionBadResponse( strResponseVouchBad, (String)vouchObj.id,setFields); 
        bbvoucherObj.actionGoodResponse(strResponseVouchGood);
        
        //CRMSS-423
        /*String bodyIR = bbvoucherObjIR.initializeRequestBody(true, '3', accObjIR.Id,null, null);
        String strResponseIR = '{"bb:RefundVoucherRS": {"bb:RefundVoucher": [{"@IDBooking": null,"@EmitterContext": null,"@IDClient": null,"@IDEmitter": null, "@IDVoucher": null, "@Type": "Refund","@GeneratedCode": "rvwyu6effjeh","@GeneratedDate": "2019-04-11 04:07:54.0","@Status": "Used","@ExpireDate": "2020-05-08","bb:RefundVoucherDetail": [{"@Country": "EA","@IDVoucherCountry": "31, "@ValidityDay": null}]}],"bb:Success": {}}}';
        DataTableWrapper wrapperIR = bbvoucherObjIR.createTableFromResponse(strResponseIR);
        String BodyErrorIR = '{  "bb:RefundVoucherRS": { "bb:Errors": {   "bb:Error": [ {  "*body": "Id Person Account empty or invalid", "@Type": "10",  "@ShortText": "Invalid customer number",   "@Code": "237"          }   ] },   "@TimeStamp": "2019-05-03T11:51:24Z" }, "bb:Headers": {  "@ApiKey": "edf5c0d2-b5ea-47ee-b3d7-92af3122cc95"}}';
        DataTableWrapper badWrapperIR = bbvoucherObjIR.createTableFromBadResponse(BodyErrorIR,400);*/
        
        String bodyVouchIR = bbvoucherObjIR.initializeRequestBody(null, null, vouchObjIR.Externalid__c,setFields, null);
        String strResponseVouchGoodIR = '{"bb:UpdateRefundVoucherRS": {"bb:RefundVoucher": [{"@IDBooking": null,"@EmitterContext": null,"@IDClient": null,"@IDEmitter": null, "@IDVoucher": null, "@Type": "Refund","@GeneratedCode": "rvwyu6effjeh","@GeneratedDate": "2019-04-11 04:07:54.0","@Responsability": null,"@Status": "Used","@ExpireDate": "2020-05-08","bb:RefundVoucherDetail": [{"@Country": "EA","@IDVoucherCountry": "31, "@ValidityDay": null}]}],"bb:Success": {}}}';
        String strResponseVouchBadIR = '{"bb:UpdateRefundVoucherRS": {"bb:Errors": {"bb:Error": [{"*body": "generateCode invalid","@Type": "3","@ShortText": "GenerateCode is invalid","@Code": "320"}]},"@TimeStamp": "2019-05-10T04:49:51Z"}}';
        Voucher__c vouchRollBackIR = bbvoucherObjIR.actionBadResponse( strResponseVouchBadIR, (String)vouchObjIR.id,setFields); 
        bbvoucherObjIR.actionGoodResponse(strResponseVouchGoodIR);
        //CRMSS-423
        
        BB_VoucherObject.BBVoucherResponseWrapper wrapperTest = new BB_VoucherObject.BBVoucherResponseWrapper();
        wrapperTest.VoucherRS = new BB_VoucherObject.VoucherRS();
        wrapperTest.VoucherRS.PageKey = '12';
        wrapperTest.VoucherRS.Success = new BB_VoucherObject.Success();
        wrapperTest.VoucherRS.TimeStamp = 'TimeStamp';
        wrapperTest.VoucherRS.Errors = new BB_VoucherObject.Errors();
        wrapperTest.VoucherRS.Errors.Error = new List<BB_VoucherObject.Error>();
        BB_VoucherObject.Error errorObj = new BB_VoucherObject.Error();
        errorObj.Code = '201';
        errorObj.ShortText = 'ShortText';
        errorObj.Type = 'Type';
        
        BB_VoucherObject.BBVoucherResponseWrapper wrapperVouchTest = new BB_VoucherObject.BBVoucherResponseWrapper();
        wrapperVouchTest.VoucherRS = new BB_VoucherObject.VoucherRS();
        wrapperVouchTest.VoucherRS.Errors = new BB_VoucherObject.Errors();
        wrapperVouchTest.VoucherRS.Errors.Error = new List<BB_VoucherObject.Error>();
        BB_VoucherObject.Error errorVouchObj = new BB_VoucherObject.Error();
        errorVouchObj.Code = '201';
        errorVouchObj.ShortText = 'ShortText';
        errorVouchObj.Type = 'Type';
        
        //CRMSS-423
        BB_VoucherObject.BBRefundVoucherResponseWrapper wrapperTestIR = new BB_VoucherObject.BBRefundVoucherResponseWrapper();
        wrapperTestIR.RefundVoucherRS = new BB_VoucherObject.RefundVoucherRS();
        wrapperTestIR.RefundVoucherRS.PageKey = '12';
        wrapperTestIR.RefundVoucherRS.Success = new BB_VoucherObject.Success();
        wrapperTestIR.RefundVoucherRS.TimeStamp = 'TimeStamp';
        wrapperTestIR.RefundVoucherRS.Errors = new BB_VoucherObject.Errors();
        wrapperTestIR.RefundVoucherRS.Errors.Error = new List<BB_VoucherObject.Error>();
        
        wrapperTestIR.RefundVoucherRS.RefundVoucher = new List<BB_VoucherObject.RefundVoucher>();
        BB_VoucherObject.RefundVoucher refundObj = new BB_VoucherObject.RefundVoucher();
        wrapperTestIR.RefundVoucherRS.RefundVoucher.add(refundObj);
        
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].IDBooking = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].EmitterContext = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].IDClient = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].IDEmitter = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].IDVoucher = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].Type = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].GeneratedCode = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].GeneratedDate = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].Responsability = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].Status = '';
        wrapperTestIR.RefundVoucherRS.RefundVoucher[0].ExpireDate = '';   
        
        BB_VoucherObject.Error errorObjIR = new BB_VoucherObject.Error();
        errorObjIR.Code = '201';
        errorObjIR.ShortText = 'ShortText';
        errorObjIR.Type = 'Type';
        
        BB_VoucherObject.BBRefundVoucherResponseWrapper wrapperVouchTestIR = new BB_VoucherObject.BBRefundVoucherResponseWrapper();
        wrapperVouchTestIR.RefundVoucherRS = new BB_VoucherObject.RefundVoucherRS();
        wrapperVouchTestIR.RefundVoucherRS.Errors = new BB_VoucherObject.Errors();
        wrapperVouchTestIR.RefundVoucherRS.Errors.Error = new List<BB_VoucherObject.Error>();
        BB_VoucherObject.Error errorVouchObjIR = new BB_VoucherObject.Error();
        errorVouchObjIR.Code = '201';
        errorVouchObjIR.ShortText = 'ShortText';
        errorVouchObjIR.Type = 'Type';
        
        //CRMSS-423
        
    }
    
    static String fillResponse(string resBody) {
        String reqBody = '{"bb:LoyaltyPointRS":{"bb:Errors":{"bb:Error":[{"*body":"' + resBody + '","@Type":"3","@ShortText":"Email address is invalid","@Code":"244"}]}}}';
        return reqBody;
    }
}