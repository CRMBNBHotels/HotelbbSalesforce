/*
* Description: Apex trigger containing all event
* @author: TMA JK
* @date: 01/10/2020
* @Test: MasterVoucherHandler_Test
* @Coverage: 83%
*/
public class MasterVoucherHandler {
    
     // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public MasterVoucherHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Master_Voucher__c[] newRecords){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_MasterVoucher') ) 
           || !UtilsBypass.canISkipApexClass('AP01_MasterVoucher') || !UtilsBypass.canISkipApexMethod('fillMasterVoucherInformationInsert')){
               AP01_MasterVoucher.fillMasterVoucherInformationInsert(newRecords);
           }
    }
    
    public void OnAfterInsert(Master_Voucher__c[] newRecords){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_MasterVoucher') ) 
           || !UtilsBypass.canISkipApexClass('AP02_MasterVoucher') || !UtilsBypass.canISkipApexMethod('CreateVoucherOCOnInsert')){
               AP02_MasterVoucher.CreateVoucherOCOnInsert(newRecords);
           }   
        
        //Added by TMA-EIT CG CRMSS-869-951 20/11/2020 Start
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_MasterVoucher') ) 
           || !UtilsBypass.canISkipApexClass('AP02_MasterVoucher') || !UtilsBypass.canISkipApexMethod('fillHotelRemainInvit')){
               AP02_MasterVoucher.fillHotelRemainInvit(newRecords);
           }
        //Added by TMA-EIT CG CRMSS-869-951 20/11/2020 End
    }
    
    public void OnAfterUpdate(Master_Voucher__c[] newRecords, Map<ID, Master_Voucher__c> recordMapOld){  
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_MasterVoucher')) 
           || !UtilsBypass.canISkipApexClass('AP02_MasterVoucher') || !UtilsBypass.canISkipApexMethod('UpdateVoucherOCOnMVUpdate')){
               
               AP02_MasterVoucher.UpdateVoucherOCOnMVUpdate(newRecords,recordMapOld); 
           } 
    }
    
    public boolean IsTriggerContext{get{ return m_isExecuting;}}
    public boolean IsVisualforcePageContext{get{ return !IsTriggerContext;}} 
    public boolean IsWebServiceContext{get{ return !IsTriggerContext;}}
    public boolean IsExecuteAnonymousContext{get{ return !IsTriggerContext;}}
}