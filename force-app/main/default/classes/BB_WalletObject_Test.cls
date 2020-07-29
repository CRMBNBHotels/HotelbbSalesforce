@isTest
public class BB_WalletObject_Test {
    @isTest
    static void testCallBBWalletObject() {
        BB_WalletObject bbWalletObj = new BB_WalletObject();
        Account accObj = new Account(Name='testAccount',BillingCountry='Germany',BillingPostalCode='12345');
        insert accObj;
        String endPoint = bbWalletObj.initializeRequestEndpoint();
        String body = bbWalletObj.initializeRequestBody(true, '3', accObj.Id,null,null);
        String strResponse = '{"bb:LoyaltyPointRS":{"bb:Success":{},"bb:LoyaltyPoints":{"bb:LoyaltyPoint":[{"bb:TimeSpan":{"@Start":"2019-02-01","@End":"2019-02-02"}}]}}}';
        DataTableWrapper wrapper = bbWalletObj.createTableFromResponse(strResponse);
        List<String> bodyLst = new List<String>();
        bodyLst.add(fillResponse('Email empty or invalid'));
        bodyLst.add(fillResponse('Id Person Account empty or invalid'));
        for(String bodyObj : bodyLst) {
            DataTableWrapper badWrapper = bbWalletObj.createTableFromBadResponse(bodyObj,400);
        }
        
        BB_WalletObject.BBWalletResponseWrapper wrapperTest = new BB_WalletObject.BBWalletResponseWrapper();
        wrapperTest.LoyaltyPointRS = new BB_WalletObject.LoyaltyPointRS();
        wrapperTest.LoyaltyPointRS.Success = new BB_WalletObject.Success();
        wrapperTest.LoyaltyPointRS.TimeStamp = 'TimeStamp';
        //wrapperTest.LoyaltyPointRS = new BB_WalletObject.LoyaltyPointRS();
        wrapperTest.LoyaltyPointRS.Errors = new BB_WalletObject.Errors();
        wrapperTest.LoyaltyPointRS.Errors.Error = new List<BB_WalletObject.Error>();
        BB_WalletObject.Error errorObj = new BB_WalletObject.Error();
        errorObj.Code = '201';
        errorObj.ShortText = 'ShortText';
        errorObj.Type = 'Type';
        wrapperTest.LoyaltyPointRS.LoyaltyPoints = new BB_WalletObject.LoyaltyPoints();
        wrapperTest.LoyaltyPointRS.LoyaltyPoints.LoyaltyPoint = new List<BB_WalletObject.LoyaltyPoint>();
        BB_WalletObject.LoyaltyPoint loyaltyPtObj = new BB_WalletObject.LoyaltyPoint();
        loyaltyPtObj.ReservationID = 'ReservationID';
        loyaltyPtObj.CreationDate = 'CreationDate';
    }
    
    static String fillResponse(string resBody) {
        String reqBody = '{"bb:LoyaltyPointRS":{"bb:Errors":{"bb:Error":[{"*body":"' + resBody + '","@Type":"3","@ShortText":"Email address is invalid","@Code":"244"}]}}}';
        return reqBody;
    }
}