/*******************************************************************************************************************************************************************
* @author: Kanel Services  - CreatedApexSharesha 
* @date: 02/04/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 02-APR-2021  CreatedApexSharesha      1.0     CRMSS-836 - GDPR - Visibility Booking
* -- 02-APR-2021  CreatedApexSharesha      2.0     CRMSS-838 - GDPR - Personal accounts visibility - NEW data model

* @TestClass : AP01_ObjectShare_Test
*********************************************************************************************************************************************************************/

public class AP01_ObjectShare {
    
    public class countrySharingRule{
        
        public String CountryCode;
        public Id     UserGroupId;
        public String AccessLevel;
        
        public countrySharingRule (String aCountryCode, Id aUserGroupId , String aAccessLevel){
            this.CountryCode = aCountryCode;
            this.UserGroupId = aUserGroupId;
            this.AccessLevel = aAccessLevel;
        }
        
    }

    /**
     * Description:  CRMSS-836 - GDPR - Visibility Booking
     */
    public static void createBookingShare(Map<Id,sObject> aBookIngMap){
    
        Set<String>                         bookingCountrySet  = New Set<String>();     
        Map<String,Buket_of_booking__Share> newShareMap        = New Map<String,Buket_of_booking__Share>();        
        Map<String,List<countrySharingRule>> rulesByCountryMap = getSharingRulesByCountry('Buket_of_booking__c');

        //Create Map parentId et requiredCountry code
        for (Booking__c bk: [SELECT Id, Name , Hotel__r.Country_code__c, Bucket_of_booking__c
                                FROM Booking__c
                                WHERE Id IN :aBookIngMap.KeySet()
                                order by Bucket_of_booking__c ASC ]){
                                    
            //Get Access For each country
            if (rulesByCountryMap.get(bk.Hotel__r.Country_code__c) != null){
                newShareMap.putAll(createBookingShares (bk.Bucket_of_booking__c, 
                                                        rulesByCountryMap.get(bk.Hotel__r.Country_code__c))
                                  );
                bookingCountrySet.add(bk.Bucket_of_booking__c);
            }
        }
        
        //Get all existing Master booking share for the bookingShare and remove from new map
        for (Buket_of_booking__Share shr: [ SELECT Id,ParentId, AccessLevel, UserOrGroupId, RowCause, UserOrGroup.Name
                                            FROM Buket_of_booking__Share
                                            WHERE RowCause = 'Manual'
                                            AND ParentId IN : bookingCountrySet
                                            ORDER BY ParentId]){
            System.debug('1. CreatedApexShare booking key values ParentId'+ shr.ParentId + '-userGroupId' + shr.UserOrGroupId + '-AccessLevel'+ shr.AccessLevel );
            String key = shr.ParentId != null && shr.UserOrGroupId != null && shr.AccessLevel != null ? String.ValueOf(shr.ParentId) + String.ValueOf(shr.UserOrGroupId) + shr.AccessLevel : '';
            newShareMap.remove(key);
        }   
                
        Database.insert(newShareMap.Values());
    }

    /**
     * Description: CRMSS-838 : GDPR - Personal accounts visibility - NEW data model
     */
    public static void createAccountShare(Map<Id,sObject> aRecordsMap, String aObjectName){        
        Set<String>                          bookingCountrySet  = New Set<String>();     
        Map<String,AccountShare>             newShareMap        = New Map<String,AccountShare>();        
        String                               query              = getQueryString(aObjectName);
        Map<String,List<countrySharingRule>> rulesByCountryMap  = getSharingRulesByCountry('Account');
        Set<Id>                              idSet              = aRecordsMap.KeySet();

        //Create Map parentId et requiredCountry code
        for (sObject obj: Database.Query(query) ){

            String CountryCode = aObjectName == 'Booking__c' ? (String) obj.getSObject('Hotel__r')?.get('Country_code__c'):
                                 aObjectName == 'Case'       ? (String) obj.getSObject('Hotel__r')?.get('Country_code__c') :'';

            Id     parentId    = aObjectName == 'Booking__c' ? (Id) obj.get('Personnal_Account__c'):
                                 aObjectName == 'Case'       ? (Id) obj.get('AccountId') : '';
            
            System.debug('CreatedApexShare 2.A bk' + parentId);  
            System.debug('CreatedApexShare 2.B rulesByCountryMap' + rulesByCountryMap.get(CountryCode)); 

            //Get Access For each country
            if (rulesByCountryMap.get(CountryCode) != null){
                newShareMap.putAll(createAccountShares (parentId, 
                                                        rulesByCountryMap.get(CountryCode))
                                  );
                bookingCountrySet.add(parentId);
            }
        }
        //Get all existing Master booking share for the bookingShare and remove from new map
        for (AccountShare shr: [SELECT Id,AccountId, AccountAccessLevel, UserOrGroupId, RowCause, UserOrGroup.Name
                                FROM AccountShare
                                WHERE RowCause = 'Manual'
                                AND AccountId IN : bookingCountrySet
                                ORDER BY AccountId]){
            System.debug('2. CreatedApexShare account key values AccountId'+ shr.AccountId + '-userGroupId' + shr.UserOrGroupId + '-AccountAccessLevel'+ shr.AccountAccessLevel );
            String key = shr.AccountId != null && shr.UserOrGroupId != null && shr.AccountAccessLevel != null ? String.ValueOf(shr.AccountId) + String.ValueOf(shr.UserOrGroupId) + shr.AccountAccessLevel : '';
            newShareMap.remove(key);
        }         
        Database.insert(newShareMap.Values());
    }

    private static String getQueryString(String aObjectName){
        String query = '';
        switch on aObjectName {
            when 'Booking__c' {		
                query =  ' SELECT Id, Name , Hotel__r.Country_code__c, Bucket_of_booking__c, Personnal_Account__c '+
                         ' FROM Booking__c '+
                         ' WHERE Id IN :idSet '+
                         ' ORDER BY Personnal_Account__c ASC ';
            }	
            when 'Case' {		
                query =  ' SELECT CaseNumber, Concerned_country__c, Hotel__r.Country_code__c, AccountId '+
                         ' FROM Case '+
                         ' WHERE Id IN :idSet '+
                         ' ORDER BY AccountId ASC ';
            }
        }
        return query;
    }

   
    public static Map<String,Buket_of_booking__Share> createBookingShares(Id                      aParentId, 
                                                                         List<countrySharingRule> aRuleList){
        
        Map<String,Buket_of_booking__Share> bShareMap = New Map<String,Buket_of_booking__Share>();
        for (countrySharingRule rule:aRuleList ){
            if (aParentId != null && rule.UserGroupId != null && rule.AccessLevel != null){
                 System.debug('1.2 CreatedApexShare key values aParentId'+ aParentId + '-userGroupId' + rule.UserGroupId + '-AccessLevel'+ rule.AccessLevel );
                String key = String.ValueOf(aParentId) + String.ValueOf(rule.UserGroupId) + rule.AccessLevel;
                bShareMap.put(key,manualShare(aParentId,rule.UserGroupId, rule.AccessLevel));
            }
        }
        return bShareMap;       
    }

    public static Map<String,AccountShare> createAccountShares( Id                       aParentId, 
                                                                List<countrySharingRule> aRuleList){

        Map<String,AccountShare> accShareMap = New Map<String,AccountShare>();
        for (countrySharingRule rule:aRuleList ){
            if (aParentId != null && rule.UserGroupId != null && rule.AccessLevel != null){
                System.debug('2.1 CreatedApexShare key values aParentId'+ aParentId + '-userGroupId' + rule.UserGroupId + '-AccessLevel'+ rule.AccessLevel );
                String key = String.ValueOf(aParentId) + String.ValueOf(rule.UserGroupId) + rule.AccessLevel;
                accShareMap.put(key,accountShare(aParentId,rule.UserGroupId, rule.AccessLevel));
            }
        }
        return accShareMap;       
    }

    public static  AccountShare accountShare(Id aRecordId, Id aUserOrGroupId, String aAccessLevel){
        
        AccountShare aShr  = new AccountShare();
        aShr.AccountId              = aRecordId;
        aShr.UserOrGroupId          = aUserOrGroupId;
        aShr.AccountAccessLevel     = aAccessLevel;
        aShr.OpportunityAccessLevel = 'None';
        aShr.CaseAccessLevel        = 'None';
        aShr.RowCause               = Schema.AccountShare.RowCause.Manual;
        return aShr;
    }
    
    public static  Buket_of_booking__Share manualShare(Id aRecordId, Id aUserOrGroupId, String aAccessLevel){
        
      Buket_of_booking__Share bShr  = new Buket_of_booking__Share();
      bShr.ParentId      = aRecordId;
      bShr.UserOrGroupId = aUserOrGroupId;
      bShr.AccessLevel   = aAccessLevel;
      bShr.RowCause      = Schema.Buket_of_booking__Share.RowCause.Manual;
      return bShr;
    }
    
    
    public static Map<String,List<countrySharingRule>> getSharingRulesByCountry(String aObjName){

        List<countrySharingRule>             sharingList        = New List<countrySharingRule>();
        Map<String,List<countrySharingRule>> sharingCountryMap  = New Map<String,List<countrySharingRule>>();
        Set<String>                          roleGroupNameSet   = New Set<String>();
        Set<String>                          sharedTypeSet      = New Set<String>();
        String                               prevCountryCode    = '';
        Map<string,Group>                    userMap            = New Map<string,Group>();
        
        List <ObjectShare__mdt> objShareList = [SELECT Id, ObjectAPIName__c, RecordCountryCode__c, 
                                                       SharedWith__c, SharedWithType__c, AccessLevel__c
                                                FROM ObjectShare__mdt
                                                WHERE ObjectAPIName__c = :aObjName 
                                                ORDER BY RecordCountryCode__c ASC];
                
        for (ObjectShare__mdt obj:objShareList ){           
            roleGroupNameSet.add(obj.SharedWith__c);
            sharedTypeSet.add(obj.SharedWithType__c);
        }
        
        //Get UserGroupId
        for ( Group gp : [   SELECT Id,Name,RelatedId,Type ,Related.Name
                             FROM Group 
                             WHERE RelatedId IN 
                                                (SELECT Id
                                                 FROM UserRole 
                                                 WHERE DeveloperName IN :roleGroupNameSet)
                             AND Type IN : sharedTypeSet]){
            userMap.put(gp.Related.Name + gp.Type, gp);
        }
        
        
        for (ObjectShare__mdt osh:objShareList ){   
            if (osh.RecordCountryCode__c != prevCountryCode){
                sharingList = New List<countrySharingRule>();
            }
            //get UserGroupId
            Id roleId = userMap.get(osh.SharedWith__c +osh.SharedWithType__c)?.Id;
            countrySharingRule crule = New countrySharingRule (osh.RecordCountryCode__c ,roleId, osh.AccessLevel__c);
            
            sharingList.add(crule);
            sharingCountryMap.put(osh.RecordCountryCode__c,sharingList);
            prevCountryCode = osh.RecordCountryCode__c;
        }
        
        return sharingCountryMap;           
    }


}