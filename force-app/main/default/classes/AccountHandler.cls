/** 
* Apex Class Handler trigger 
*
* @author  Omar Bensouda Korachi <o.bensouda@obkconsulting.com>
* @version 0.1
* @date    11/10/2019 
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/

public without sharing class AccountHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public AccountHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Account[] newRecords){
        system.debug('@@@ OnBeforeInsert');
       /* if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('UtilsMethodeForAccount') ) 
           || !UtilsBypass.canISkipApexClass('UtilsMethodeForAccount') 
           || !UtilsBypass.canISkipApexMethod('bBHClubSubscriptionCountry')){
              // UtilsMethodeForAccount.flowWithTheCommonValueFromAccountSetting(newRecords);
           }*/
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP04_Account') ) 
           || !UtilsBypass.canISkipApexClass('AP04_Account') 
           || !UtilsBypass.canISkipApexMethod('initializeDataHistoryField')){
               // gho modifications
               AP04_Account.initializeDataHistoryField(newRecords);
           }
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('Account_Handler') ) 
           || !UtilsBypass.canISkipApexClass('Account_Handler') 
           || !UtilsBypass.canISkipApexMethod('handle')){
               Account_Handler.handle(newRecords,null);   //TMA EI 9-9-2019 PG 275
           }
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP07_Account') ) 
           || !UtilsBypass.canISkipApexClass('AP07_Account') 
           || !UtilsBypass.canISkipApexMethod('getHotelName')){
               AP07_Account.getHotelName(newRecords);
           }
    }
    
    public void OnAfterInsert(Account[] newRecords,Map<ID, Account> recordMap, Map<ID, Account> recordMapOld){
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Account[] oldRecords, Account[] updatedRecords, Map<ID, Account> recordMap, Map<ID, Account> recordMapOld){
       
       /* if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('UtilsMethodeForAccount') ) 
           || !UtilsBypass.canISkipApexClass('UtilsMethodeForAccount') 
           || !UtilsBypass.canISkipApexMethod('bBHClubSubscriptionCountry')){
              // UtilsMethodeForAccount.flowWithTheCommonValueFromAccountSetting(updatedRecords);
           }*/

        if((UtilsBypass.getUserBypassApexClass() != null  && !UtilsBypass.getUserBypassApexClass().contains('Account_Handler')) 
           || !UtilsBypass.canISkipApexClass('Account_Handler') 
           || !UtilsBypass.canISkipApexMethod('handle')){
               Account_Handler.handle(updatedRecords,recordMapOld);	//TMA EI 9-9-2019 PG 275
           }
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Account')) 
           || !UtilsBypass.canISkipApexClass('AP01_Account') 
           || !UtilsBypass.canISkipApexMethod('UpdateStatus')){
               AP01_Account.UpdateStatus(updatedRecords,recordMapOld); 
           }
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP05_Account')) 
           || !UtilsBypass.canISkipApexClass('AP05_Account') 
           || !UtilsBypass.canISkipApexMethod('StockOldData')){
               system.debug('call stock data');
               AP05_Account.StockOldData(recordMap,recordMapOld);
           }
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP07_Account')) 
           || !UtilsBypass.canISkipApexClass('AP07_Account') 
           || !UtilsBypass.canISkipApexMethod('getHotelName')){
               AP07_Account.getHotelName(updatedRecords);
           }  
    }
    
    public void OnAfterUpdate(Account[] oldRecords, Account[] updatedRecords, Map<ID, Account> recordMap,  Map<ID, Account> recordMapOld){  
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP06_Account')) 
           || !UtilsBypass.canISkipApexClass('AP06_Account') 
           || !UtilsBypass.canISkipApexMethod('TrackHistory')){
               // added by JKA CRMSS-437
               
               //TMABNB CRMSS-236
               AP06_Account.TrackHistory(updatedRecords, recordMapOld);
               //end
           }
        if((UtilsBypass.getUserBypassApexClass() != null  && !UtilsBypass.getUserBypassApexClass().contains('AP05_Account')) 
           || !UtilsBypass.canISkipApexClass('AP05_Account') 
           || !UtilsBypass.canISkipApexMethod('CallWSUpdatePersonAccountInfo')){
               //TMABNB CRMSS-96
               AP05_Account.CallWSUpdatePersonAccountInfo(recordMap,recordMapOld);
           }
        
        
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Account[] recordsToDelete, Map<ID, Account> recordMap){
        
    }
    
    public void OnAfterDelete(Account[] deletedRecords, Map<ID, Account> recordMap){
        
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Account[] restoredRecords){
        
    }
    
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext{
        get{ return !IsTriggerContext;}
    }
}