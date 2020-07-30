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
public without sharing class ContractHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public ContractHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Contract[] newRecords){
        system.debug('@@@ OnBeforeInsert');
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_Contract') )
           || !UtilsBypass.canISkipApexClass('AP02_Contract') 
           || !UtilsBypass.canISkipApexMethod('fillContactAndAccount')){
               AP02_Contract.fillContactAndAccount(newRecords, null,false);
           }
    }
    
    public void OnAfterInsert(Contract[] newRecords,Map<ID, Contract> recordMap, Map<ID, Contract> recordMapOld){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Contract') )
           || !UtilsBypass.canISkipApexClass('AP01_Contract') 
           || !UtilsBypass.canISkipApexMethod('UpdateNumberOfContracts')){
               AP01_Contract.UpdateNumberOfContracts(newRecords, null, null);
           }
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Contract[] oldRecords, Contract[] updatedRecords, Map<ID, Contract> recordMap, Map<ID, Contract> recordMapOld){
        
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_Contract') )
           || !UtilsBypass.canISkipApexClass('AP02_Contract') 
           || !UtilsBypass.canISkipApexMethod('fillContactAndAccount')){
               AP02_Contract.fillContactAndAccount(updatedRecords, recordMapOld,false);
               
           } 
    }
    
    public void OnAfterUpdate(Contract[] oldRecords, Contract[] updatedRecords, Map<ID, Contract> recordMap,  Map<ID, Contract> recordMapOld){ 
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Contract') )
           || !UtilsBypass.canISkipApexClass('AP01_Contract') 
           || !UtilsBypass.canISkipApexMethod('UpdateNumberOfContracts')){
               AP01_Contract.UpdateNumberOfContracts(updatedRecords, recordMapOld,oldRecords);
               
           } 
        
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Contract[] recordsToDelete, Map<ID, Contract> recordMap){
        
    }
    
    public void OnAfterDelete(Contract[] deletedRecords, Map<ID, Contract> recordMap){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Contract') )
           || !UtilsBypass.canISkipApexClass('AP01_Contract') 
           || !UtilsBypass.canISkipApexMethod('UpdateNumberOfContracts')){
               AP01_Contract.UpdateNumberOfContracts(null, null,deletedRecords);
           } 
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Contract[] restoredRecords){
        
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