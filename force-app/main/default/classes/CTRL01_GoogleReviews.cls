public with sharing class CTRL01_GoogleReviews extends OAuthController {
    public CTRL01_GoogleReviews() {
    }
    static public void refreshToken(){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(OAuthApp__c.getValues('googleAPI').AccessTokenURL__c);
        request.setMethod('POST');
        request.setHeader('Content-Type','text/plain');
        request.setHeader('Authorization', 'Bearer ' +OAuthApp__c.getValues('googleAPI').AccessToken__c);
        String body = '{"grant_type": "refresh_token",'
                        +'"client_id": "'+OAuthApp__c.getValues('googleAPI').ClientId__c+'",'
                        +'"client_secret": "'+OAuthApp__c.getValues('googleAPI').ClientSecret__c+'",' 
                        +'"refresh_token": "'+OAuthApp__c.getValues('googleAPI').RefreshToken__c+'"}';
        System.debug('@@: '+body) ;
        request.setbody(body);
        HttpResponse response = httpProtocol.send(request);
        System.debug('@@: '+response.getStatus()) ;
        if (response.getStatus() == 'OK'){
            String jsonInput = response.getBody();
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
            OAuthApp__c temp = OAuthApp__c.getValues('googleAPI');
            temp.AccessToken__c =(String) m.get('access_token');
            update temp;
        }
    }
    static public void getReviewsList(Boolean isValideToken){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://www.googleapis.com/androidpublisher/v3/applications/com.bbhotel.android/reviews');
        request.setMethod('GET');
        request.setHeader('Content-Type','text/plain');
        request.setHeader('Authorization', 'Bearer ' +OAuthApp__c.getValues('googleAPI').AccessToken__c);
        HttpResponse response = httpProtocol.send(request);
        System.debug('@@: '+response.getStatus()) ;
        if (response.getStatus() == 'OK'){
            String jsonInput = response.getBody();
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
            System.debug('@@: '+m) ;
        }else{
            // Automatique Refresh Token
            if(isValideToken){
                CTRL01_GoogleReviews.refreshToken();
                CTRL01_GoogleReviews.getReviewsList(false);
            }
        }
    }
}