/** 
* Apex Class Handler trigger 
*
* @author  JKA 
* @version 0.1
* @date    23/01/2020 
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/

public without sharing class HotelHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public HotelHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Hotel__c[] newRecords){
        
    }
    
    public void OnAfterInsert(Hotel__c[] newRecords,Map<ID, Hotel__c> recordMap, Map<ID, Hotel__c> recordMapOld){
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Hotel__c[] oldRecords, Hotel__c[] updatedRecords, Map<ID, Hotel__c> recordMap, Map<ID, Hotel__c> recordMapOld){
 
    }
    
    public void OnAfterUpdate(Hotel__c[] oldRecords, Hotel__c[] updatedRecords, Map<ID, Hotel__c> recordMap,  Map<ID, Hotel__c> recordMapOld){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Hotel'))
           || !UtilsBypass.canISkipApexClass('AP01_Hotel') 
           || !UtilsBypass.canISkipApexMethod('updateBookingsCountryPercentages')){
               
               AP01_Hotel.updateBookingsCountryPercentages(updatedRecords, recordMapOld);
           }	
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Hotel__c[] recordsToDelete, Map<ID, Hotel__c> recordMap){
        /*  if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Hotel'))  
|| !UtilsBypass.canISkipApexClass('AP01_Hotel') 
|| !UtilsBypass.canISkipApexMethod('UpdateHotelOpportunity')){
//AP01_Hotel.UpdateHotelOpportunity(null, recordMap,recordsToDelete);
}*/
    }
    
    public void OnAfterDelete(Hotel__c[] deletedRecords, Map<ID, Hotel__c> recordMap){
        /*  if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Hotel'))  
|| !UtilsBypass.canISkipApexClass('AP01_Hotel') 
|| !UtilsBypass.canISkipApexMethod('UpdateHotelOpportunity')){
//AP01_Hotel.UpdateHotelOpportunity(null, recordMap,deletedRecords);
}*/
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Hotel__c[] restoredRecords){
        
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