public with sharing class CTRL01_GoogleReviews{
    
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
        request.setbody(body);
        HttpResponse response = httpProtocol.send(request);
        if (response.getStatus() == 'OK'){
            String jsonInput = response.getBody();
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
            OAuthApp__c temp = OAuthApp__c.getValues('googleAPI');
            temp.AccessToken__c =(String) m.get('access_token');
            System.debug('@&@ refreshToken '+m.get('access_token')) ;
            update temp;
            System.debug('@&@ refreshToken Done') ;
        }
    }

    @future(callout=true)
    static public void getReviewsListAndPutInCase(){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://www.googleapis.com/androidpublisher/v3/applications/com.bbhotel.android/reviews');
        request.setMethod('GET');
        request.setHeader('Content-Type','text/plain');
        request.setHeader('Authorization', 'Bearer ' +OAuthApp__c.getValues('googleAPI').AccessToken__c);
        HttpResponse response = httpProtocol.send(request);
        System.debug('@&@: '+response.getStatus()) ;
        if (response.getStatus() == 'OK'){
            System.debug('@&@ Get list of reviews') ;
            String jsonInput = response.getBody();
            CTRL01_GoogleReviews.putReviewsInCases(jsonInput);
        }
    }

    static public void putReviewsInCases(String jsonInput){
        CTRL02_GoogleReview googleReview = (CTRL02_GoogleReview) JSON.deserialize(jsonInput, CTRL02_GoogleReview.class );
        List<case> cases = new List<case>();
        for(Integer i=0;i<googleReview.reviews.size();i++){
            case caseToSFDC 			= new case();
            caseToSFDC.reviewId__c 		= googleReview.reviews.get(i).reviewId;
            caseToSFDC.AuthorName__c 	= googleReview.reviews.get(i).authorName;
            caseToSFDC.starRating__c 	= googleReview.reviews.get(i).comments.get(0).userComment.starRating;   
            if(caseToSFDC.starRating__c<3){
                caseToSFDC.Priority = 'High';
            }else if(caseToSFDC.starRating__c>3){
                caseToSFDC.Priority = 'Low';
            }else{
                caseToSFDC.Priority = 'Medium';
            }
            caseToSFDC.Language__c		= googleReview.reviews.get(i).comments.get(0).userComment.reviewerLanguage;
            caseToSFDC.Description 		= googleReview.reviews.get(i).comments.get(0).userComment.text;  
            caseToSFDC.Origin 			= 'GooglePlayApp';
            caseToSFDC.RecordTypeId     = '0120Q000000DJ2LQAW';
            cases.add(caseToSFDC);
        }
        Upsert cases reviewId__c;
        System.debug('@&@ upsert Cases') ;
    } 

}