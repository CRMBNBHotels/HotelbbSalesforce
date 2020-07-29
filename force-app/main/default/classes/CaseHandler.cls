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

public without sharing class CaseHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public CaseHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Case[] newRecords){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Case')) 
           || !UtilsBypass.canISkipApexClass('AP01_Case') || !UtilsBypass.canISkipApexMethod('FillHotelID')){
               AP01_Case.FillHotelID(newRecords);
           }
    }
    
    public void OnAfterInsert(Case[] newRecords,Map<ID, Case> recordMap, Map<ID, Case> recordMapOld){
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Case')) 
           || !UtilsBypass.canISkipApexClass('AP01_Case') || !UtilsBypass.canISkipApexMethod('CreatePersonAccount')){
               AP01_Case.CreatePersonAccount(newRecords);
           }
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Case')) 
           || !UtilsBypass.canISkipApexClass('AP01_Case') || !UtilsBypass.canISkipApexMethod('SendEmailToHotel')){
               AP01_Case.SendEmailToHotel(newRecords);  
           }
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_Case')) 
           || !UtilsBypass.canISkipApexClass('AP02_Case') || !UtilsBypass.canISkipApexMethod('UpdateContactNameWithPersonAccount')){
               AP02_Case.UpdateContactNameWithPersonAccount(newRecords,recordMapOld);
           }
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Case[] oldRecords, Case[] updatedRecords, Map<ID, Case> recordMap, Map<ID, Case> recordMapOld){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP03_Case')) 
           || !UtilsBypass.canISkipApexClass('AP03_Case') || !UtilsBypass.canISkipApexMethod('AssignCaseToUser')){
               //TMA Cynthia geagea - CRMSS-161
               AP03_Case.AssignCaseToUser(updatedRecords);
           }
    }
    
    public void OnAfterUpdate(Case[] oldRecords, Case[] updatedRecords, Map<ID, Case> recordMap,  Map<ID, Case> recordMapOld){  
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_Case')) 
           || !UtilsBypass.canISkipApexClass('AP02_Case') || !UtilsBypass.canISkipApexMethod('UpdateContactNameWithPersonAccount')){
               //TMA Cynthia geagea - CRMSS-161
               AP02_Case.UpdateContactNameWithPersonAccount(updatedRecords,recordMapOld);
           }
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP03_Case')) 
           || !UtilsBypass.canISkipApexClass('AP03_Case') || !UtilsBypass.canISkipApexMethod('SendEmailToCaseOwner')){
               //TMA Cynthia geagea - CRMSS-161
               //TMA - Cynthia Geagea 11/06/2019 - CRMSS-161
               AP03_Case.SendEmailToCaseOwner(updatedRecords, recordMapOld);
           }   
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Case[] recordsToDelete, Map<ID, Case> recordMap){
        
    }
    
    public void OnAfterDelete(Case[] deletedRecords, Map<ID, Case> recordMap){
        
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Case[] restoredRecords){
        
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