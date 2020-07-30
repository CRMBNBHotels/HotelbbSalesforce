/** 
* Apex Class Handler trigger 
*
* @author  JKA
* @version 0.1
* @date    22/01/2020 
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/

public without sharing class OpportunityTriggerHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    private String UserBypassApexClass = UtilsBypass.getUserBypassApexClass();
    
    
    
    public OpportunityTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Opportunity[] newRecords){
        system.debug('@@@@@ OnBeforeInsert');
        
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP08_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP08_Opportunity') || !UtilsBypass.canISkipApexMethod('fillBookingLookups')){
               AP08_Opportunity.fillBookingLookups(newRecords);
           } 
    }
    
    public void OnAfterInsert(Opportunity[] newRecords,Map<ID, Opportunity> recordMap, Map<ID, Opportunity> recordMapOld){
        system.debug('@@@@@ OnAfterInsert');
        /*if((UserBypassApexClass != null && !UserBypassApexClass.contains('OpportunityHandler')) 
           || !UtilsBypass.canISkipApexClass('OpportunityHandler') || !UtilsBypass.canISkipApexMethod('FilterOpportunity')){
               //OpportunityHandler.FilterOpportunity(newRecords, null);
           }*/
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP05_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP05_Opportunity') || !UtilsBypass.canISkipApexMethod('doCalculateGuestHistoryField')){
               //gho modifications
               AP05_Opportunity.doCalculateGuestHistoryField(newRecords, null);
           }
        /*if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP03_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP03_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateTotalNightsPartnerShip')){
               //AP03_Opportunity.UpdateTotalNightsPartnerShip(newRecords ,null, null);
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP04_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP04_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateTotalTransactions')){
               //AP04_Opportunity.UpdateTotalTransactions(newRecords ,null, null);
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP05_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP05_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateCountryPercentages')){
               //AP05_Opportunity.UpdateCountryPercentages(newRecords ,null, null); 
           }*/
        
        //Added by TMA-EIL CG CRMSS-474 11/03/2020 Start
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP18_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP18_Opportunity') || !UtilsBypass.canISkipApexMethod('fillMBOpco')){
               system.debug('### cg im here 1');
               Id bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
               
               list<opportunity> listFilteredOpp = new list<opportunity>();
               
               for(opportunity opp : newRecords){
                   
                   if(opp.RecordTypeId == bookingRTId && opp.HotelCountry__c != null && string.isNotBlank(opp.HotelCountry__c) && opp.Master_Booking_FK__c != null && string.isNotBlank(opp.Master_Booking_FK__c)){
                       system.debug('### cg im here 2');
                       listFilteredOpp.add(opp);
                   }
               }
               
               if(listFilteredOpp != null && listFilteredOpp.size()>0){
                   system.debug('### cg im here 3');
                   AP18_Opportunity.fillMBOpco(newRecords);
               }
           }
        //Added by TMA-EIL CG CRMSS-474 11/03/2020 End
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Opportunity[] oldRecords, Opportunity[] updatedRecords, Map<ID, Opportunity> recordMap, Map<ID, Opportunity> recordMapOld){
        system.debug('@@@@@ OnBeforeUpdate');

        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP08_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP08_Opportunity') || !UtilsBypass.canISkipApexMethod('fillBookingLookups')){
               AP08_Opportunity.fillBookingLookups(updatedRecords);
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP17_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP17_Opportunity') || !UtilsBypass.canISkipApexMethod('FillOldPArent')){
               AP17_Opportunity.FillOldPArent(updatedRecords,recordMapOld);
           }
    }
    
    public void OnAfterUpdate(Opportunity[] oldRecords, Opportunity[] updatedRecords, Map<ID, Opportunity> recordMap,  Map<ID, Opportunity> recordMapOld){  
        system.debug('@@@@@ OnAfterUpdate');
        /*if((UserBypassApexClass != null && !UserBypassApexClass.contains('OpportunityHandler')) 
           || !UtilsBypass.canISkipApexClass('OpportunityHandler') || !UtilsBypass.canISkipApexMethod('FilterOpportunity')){
               //OpportunityHandler.FilterOpportunity(updatedRecords,recordMapOld);
           }*/
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP05_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP05_Opportunity') || !UtilsBypass.canISkipApexMethod('doCalculateGuestHistoryField')){
               // gho modifications
               AP05_Opportunity.doCalculateGuestHistoryField(updatedRecords, recordMapOld);
           }

        /*if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP03_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP03_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateTotalNightsPartnerShip')){
               //AP03_Opportunity.UpdateTotalNightsPartnerShip(updatedRecords , recordMapOld,oldRecords);  
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP04_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP04_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateTotalTransactions')){
               //AP04_Opportunity.UpdateTotalTransactions(updatedRecords , recordMapOld,oldRecords);
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP05_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP17_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateCountryPercentages')){
               //AP05_Opportunity.UpdateCountryPercentages(updatedRecords, recordMapOld,oldRecords);
           }
        
        /*if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP014_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP014_Opportunity') || !UtilsBypass.canISkipApexMethod('ReCalculateContract')){
               //Added by JK CRMSS-343
               AP014_Opportunity.ReCalculateContract(updatedRecords,recordMapOld);
           }*/
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Opportunity[] recordsToDelete, Map<ID, Opportunity> recordMap){
        
        system.debug('@@@@@ OnBeforeDelete');

        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP06_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP06_Opportunity') || !UtilsBypass.canISkipApexMethod('forceErrorOnBookingDelete')){
                AP06_Opportunity.forceErrorOnBookingDelete(recordsToDelete);
           }
    }
    
    public void OnAfterDelete(Opportunity[] deletedRecords, Map<ID, Opportunity> recordMap){
        system.debug('@@@@@ OnAfterDelete');
        /*if((UserBypassApexClass != null && !UserBypassApexClass.contains('OpportunityHandler')) 
           || !UtilsBypass.canISkipApexClass('OpportunityHandler') || !UtilsBypass.canISkipApexMethod('FilterOpportunity')){
               //OpportunityHandler.FilterOpportunity(null, recordMap);
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP03_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP03_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateTotalNightsPartnerShip')){
               // AP03_Opportunity.UpdateTotalNightsPartnerShip(null, recordMap,deletedRecords);  
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP04_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP04_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateTotalTransactions')){
                //AP04_Opportunity.UpdateTotalTransactions(null, recordMap,deletedRecords);
           }
        if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP05_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP05_Opportunity') || !UtilsBypass.canISkipApexMethod('UpdateCountryPercentages')){
              //AP05_Opportunity.UpdateCountryPercentages(null, recordMap,deletedRecords);
           }*/
        
        // gho modifications
        if(!System.isBatch()) {
             if((UserBypassApexClass != null && !UserBypassApexClass.contains('AP05_Opportunity')) 
           || !UtilsBypass.canISkipApexClass('AP05_Opportunity') || !UtilsBypass.canISkipApexMethod('doCalculateGuestHistoryField')){
               AP05_Opportunity.doCalculateGuestHistoryField(deletedRecords, null);
           }
          
        }
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Opportunity[] restoredRecords){
        
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