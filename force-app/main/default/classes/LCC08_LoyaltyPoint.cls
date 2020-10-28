/*
* Description: Controller class for Add/Remove Loyalty Point Component => 
* @author: TMA-EI JK
* @date: 27/03/2019
* @modified by TMA-EI CG 27-05-2019
* @Test class: LCC08_LoyaltyPoint_Test
* @Coverage: 78 %
* @Lightning Components: LC08_LoyaltyPoint
*/
public without sharing class LCC08_LoyaltyPoint {
    @AuraEnabled
    public static Account GetAccountInfo(String accountId) {
        if(accountId != null){
            Account acc = [select id,Tech_BBUS__c,E_club_subscription__pc,E_club_Number_of_points__pc,Point_Request__c from account where id=:accountId];
            return acc;
        }
        return null;
    }
    
    @AuraEnabled
    public static void DoCalculation(String accountId, string type, integer NumberPoints, integer ApexNbPoint, string Reason, String Description) {
        system.debug('#####reason '+Reason);
                system.debug('#####Description '+Description);

        system.debug('### cyn Description'+Description);
        if(accountId != null){
            
            List<Account> lstId = [select Externalid__c from Account where Id =: accountId Limit 1];
            String ExtId = lstId[0].Externalid__c;
                
            if(ApexNbPoint == null){
                ApexNbPoint = 0;
            }
                
            account acc = new account(id =accountId );         
            acc.Point_Request__c= 'Processing';
            acc.Tech_BBUS__c= true;
            
            if(type == 'Ajout' || type == 'ADD')
            {
                acc.E_club_Number_of_points__pc = ApexNbPoint + NumberPoints;
            }
            else
            {
                acc.E_club_Number_of_points__pc = ApexNbPoint - NumberPoints  ;
                if( acc.E_club_Number_of_points__pc < 0)
                {
                    acc.E_club_Number_of_points__pc = 0;
                }
            }
            
            Map<String,sObject> mapSObject = new Map<String,sObject>();
            mapSObject.put(acc.id,acc);
            
            Map<String,String> mapType = new Map<String,String>();
            mapType.put(acc.id,type);
            
            //Added by TMA Cynthia Geagea - CRMSS 260 - 27/08/2019 - Start
            Map<String,String> mapDescription = new Map<String,String>();
            mapDescription.put(acc.id,Description); system.debug('### cyn mapDescription'+mapDescription);
            //Added by TMA Cynthia Geagea - CRMSS 260 - 27/08/2019 - End
            
            //CRMSS-128 - Cynthia Geagea - 27/05/2019
            Map<String,String> mapReason = new Map<String,String>();
            mapReason.put(acc.id,Reason);
            
            Map<String,Integer> mapNBPT= new Map<String,Integer>();
            mapNBPT.put(acc.id,NumberPoints);
            
            Map<String,String> mapJsonn =  new Map<String,String>();
            mapJsonn = AP02_SObject_WS.Serialize(mapSObject,mapType,mapNBPT); 
            system.debug('### cyn mapJsonn'+mapJsonn);
            //CRMSS-128 - Cynthia Geagea - 27/05/2019
            String jsonToModify = mapJsonn.get(acc.Id);
            AP02_Sobject_WS.SerializeObject serOb = (AP02_Sobject_WS.SerializeObject)JSON.deserializeStrict(jsonToModify,AP02_Sobject_WS.SerializeObject.Class); 
 			serOb.Reason = Reason;
            
            //Added by TMA Cynthia Geagea - CRMSS 260 - 27/08/2019 - Start
            serOb.Description = Description;
            //Added by TMA Cynthia Geagea - CRMSS 260 - 27/08/2019 - End 
            
            jsonToModify = JSON.serialize(serOb);
            system.debug('### cyn jsonToModify'+jsonToModify);
            acc.Tech_points_results__c = jsonToModify;
            acc.E_club_Number_of_points__pc = ApexNbPoint;
            update acc;
            
            //CRMSS-128 - Cynthia Geagea - 27/05/2019
            Set<String> setFieldPoints = new Set<String>();
            setFieldPoints.add('E_club_Number_of_points__pc');
            
            CallWSPoints(ExtId,accountId,setFieldPoints);
            
            system.debug('donee');
        }
        
        
    }
    
    //CRMSS-128 - Cynthia Geagea - 27/05/2019
    @future(callout=true)
    Public Static Void CallWSPoints(String ExtID, String Idcurr,Set<String> setfieldModif){
        system.debug('## ExtID'+ExtID);
        system.debug('## Idcurr'+Idcurr);
        system.debug('## setfieldModif'+setfieldModif);
        BB_AccountObjectPoints accountobject = new BB_AccountObjectPoints(); 
        Account acc = new Account();
        try {            
            HttpResponse response = BBUS_DataHistoryManager.callBBUSWebserviceResponse('AccountPoints', null, null, ExtID,setfieldModif);
            String strResponse = response.getBody();
            system.debug('strResponse'+strResponse);
            system.debug('response.getStatusCode()'+response.getStatusCode());
            InsertLog( strResponse);
            //if it's a bad response then perform a roolback + set the status of the sync to error
            if(response.getStatusCode() != 200){
                acc =  accountobject.actionBadResponse(strResponse, Idcurr,setfieldModif);
            }else{
                //if it's a good response then set the status of the sync to Successful with the date
                acc.id = Idcurr;
                List<Account> lstAcc = [Select Tech_points_results__c, E_club_Number_of_points__pc from Account where Id =:Idcurr LIMIT 1];
                String oldDataJson = lstAcc[0].Tech_points_results__c;
                AP02_SObject_WS.SerializeObject OldDataWrapper = (AP02_SObject_WS.SerializeObject)JSON.deserialize(oldDataJson, AP02_SObject_WS.SerializeObject.class);
                acc.E_club_Number_of_points__pc = (Double)OldDataWrapper.sobj.get('E_club_Number_of_points__pc');
                acc.Point_Request__c = 'Successful ' + String.valueOf(DateTime.now().format());
                acc.Tech_BBUS__c = False;
            }
            update acc;
        }catch(Exception e) {
            //if we could not performed the callout, set the status to error with the date
            acc =  accountobject.actionBadResponse(null, Idcurr,setfieldModif);
            acc.Point_Request__c = 'Error ' + String.valueOf(DateTime.now().format());
            acc.Tech_BBUS__c = False;
            update acc; 
        }
    }
    
    @AuraEnabled
    public static void InsertLog(String strResponse) {
        Log__c log = new Log__c();
        log.WSName__c = 'Account Point Synchronisation Return';
        log.JsonMessage__c = strResponse;
        log.FromSalesforce__c = true;
        insert log;
    }
}