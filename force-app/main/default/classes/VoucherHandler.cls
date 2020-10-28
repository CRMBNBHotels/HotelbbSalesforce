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

public without sharing class VoucherHandler {
    
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public VoucherHandler(boolean isExecuting, integer size){
        
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Voucher__c[] newRecords){
        
        system.debug('@@@ OnBeforeInsert');
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Voucher') ) //
           || !UtilsBypass.canISkipApexClass('AP01_Voucher') 
           || !UtilsBypass.canISkipApexMethod('FillInvitationInformationOnCreation')){
               
               String VoucherOCRT = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get('OC').getRecordTypeId();
               list<Voucher__c> listFilteredVouchers = new list<Voucher__c>();
               
               For(Voucher__c voucher : newRecords){
                   
                   if(voucher.RecordTypeId != VoucherOCRT){
                       
                       listFilteredVouchers.add(voucher);
                   }
               }
               
               if(listFilteredVouchers != null && listFilteredVouchers.size()>0){
                   
                   AP01_Voucher.FillInvitationInformationOnCreation(listFilteredVouchers);
               }
               
           }
        
        // UtilsMethodeForAccount.flowWithTheCommonValueFromAccountSetting(newRecords);
        // added by JKA CRMSS-437
        // gho modifications
        
        //Voucher_Handler.handle(newRecords,null);   //TMA EI 9-9-2019 PG 275
        
        //end
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP04_Voucher') ) //
           || !UtilsBypass.canISkipApexClass('AP04_Voucher') 
           || !UtilsBypass.canISkipApexMethod('vouchHelper')){
               System.debug('jull Before insert ap04_voucher');
               AP04_Voucher.vouchHelper(Trigger.new, null);
           }
        
        // UtilsMethodeForAccount.flowWithTheCommonValueFromAccountSetting(newRecords);
        // added by JKA CRMSS-437
        // gho modifications
        
        //Voucher_Handler.handle(newRecords,null);   //TMA EI 9-9-2019 PG 275
        
        //end
        
        //Added by TMA-EIL CG CRMSS-474 06/03/2020 Start
       if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP05_Voucher')) || !UtilsBypass.canISkipApexClass('AP05_Voucher') || !UtilsBypass.canISkipApexMethod('fillVoucherOpco')){
            
            list<voucher__c> listFilteredVouch = new list<Voucher__c>();
            
            for(Voucher__c vouch : newRecords){
                
                if(vouch.Hotel__c != null && string.isNotBlank(vouch.Hotel__c)){
                    
                    listFilteredVouch.add(vouch);
                }
            }
            
            if(listFilteredVouch != null && listFilteredVouch.size()>0){
                
                AP05_Voucher.fillVoucherOpco(listFilteredVouch);
            }
        }
        //Added by TMA-EIL CG CRMSS-474 06/03/2020 Start
    }
    
    public void OnAfterInsert(Voucher__c[] newRecords,Map<ID, Voucher__c> recordMap, Map<ID, Voucher__c> recordMapOld){
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Voucher') ) //
           || !UtilsBypass.canISkipApexClass('AP01_Voucher') 
           || !UtilsBypass.canISkipApexMethod('CreateCase')){
               
               AP01_Voucher.CreateCase(newRecords);
           }
        
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Voucher__c[] oldRecords, Voucher__c[] updatedRecords, Map<ID, Voucher__c> recordMap, Map<ID, Voucher__c> recordMapOld){
        
        system.debug('### jka in Trigger update');
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Voucher')) 
           || !UtilsBypass.canISkipApexClass('AP01_Voucher') 
           || !UtilsBypass.canISkipApexMethod('FillInvitationInformationOnModification')){
               
               String VoucherOCRT = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get('OC').getRecordTypeId();
               list<Voucher__c> listFilteredVouchers = new list<Voucher__c>();
               
               For(Voucher__c voucher : updatedRecords){
                   
                   if(voucher.RecordTypeId != VoucherOCRT){
                       
                       listFilteredVouchers.add(voucher);
                   }
               }
               
               if(listFilteredVouchers != null && listFilteredVouchers.size()>0){
                   
                   AP01_Voucher.FillInvitationInformationOnModification(listFilteredVouchers);
               }
           } 
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP03_voucher')) 
           || !UtilsBypass.canISkipApexClass('AP03_voucher') 
           || !UtilsBypass.canISkipApexMethod('Voucher_update')){
               
               AP03_voucher.Voucher_update(recordMap, recordMapOld); // line added by jad 15-04-2019        
           } 
        system.debug('1 '+(UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP04_Voucher')));
        system.debug('2 '+!UtilsBypass.canISkipApexClass('AP04_Voucher'));
        system.debug('2 '+!UtilsBypass.canISkipApexClass('vouchHelper'));
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP04_Voucher')) 
           || !UtilsBypass.canISkipApexClass('AP04_Voucher') 
           || !UtilsBypass.canISkipApexMethod('vouchHelper')){
               System.debug('jull Before update ap04_voucher');
               AP04_Voucher.vouchHelper(updatedRecords, recordMapOld);
           }
        
        //Added by TMA-EIL CG CRMSS-474 06/03/2020 Start
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP05_Voucher')) || !UtilsBypass.canISkipApexClass('AP05_Voucher') || !UtilsBypass.canISkipApexMethod('fillVoucherOpco')){
            
            list<voucher__c> listFilteredVouch = new list<Voucher__c>();
            
            for(Voucher__c vouch : updatedRecords){
                
                if(vouch.Hotel__c != null && string.isNotBlank(vouch.Hotel__c) && recordMapOld.get(vouch.Id).Hotel__c != vouch.Hotel__c){
                    
                    listFilteredVouch.add(vouch);
                }
            }
            
            if(listFilteredVouch != null && listFilteredVouch.size()>0){
                
                AP05_Voucher.fillVoucherOpco(listFilteredVouch);
            }
        } 
        //Added by TMA-EIL CG CRMSS-474 06/03/2020 Start
    }
 
    public void OnAfterUpdate(Voucher__c[] oldRecords, Voucher__c[] updatedRecords, Map<ID, Voucher__c> recordMap,  Map<ID, Voucher__c> recordMapOld){  
                
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP03_voucher')) 
           || !UtilsBypass.canISkipApexClass('AP03_voucher') 
           || !UtilsBypass.canISkipApexMethod('CallWSUpdateVoucherInfo')){
               
               AP03_voucher.CallWSUpdateVoucherInfo(recordMap,recordMapOld); 
           } 
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Voucher__c[] recordsToDelete, Map<ID, Voucher__c> recordMap){
        
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP04_Voucher')) 
           || !UtilsBypass.canISkipApexClass('AP04_Voucher') 
           || !UtilsBypass.canISkipApexMethod('vouchHelper')){
               
               AP04_Voucher.vouchHelper(null, recordMap);
           } 
    }
    
    public void OnAfterDelete(Voucher__c[] deletedRecords, Map<ID, Voucher__c> recordMap){
        
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Voucher__c[] restoredRecords){
        
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