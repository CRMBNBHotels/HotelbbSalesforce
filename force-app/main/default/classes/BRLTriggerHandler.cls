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

public without sharing class BRLTriggerHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public BRLTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Booking_Room_Line__c[] newRecords){
        system.debug('@@@ OnBeforeInsert');
       
    }
    
    public void OnAfterInsert(Booking_Room_Line__c[] newRecords,Map<ID, Booking_Room_Line__c> recordMap, Map<ID, Booking_Room_Line__c> recordMapOld){
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Booking_Room_Line__c[] oldRecords, Booking_Room_Line__c[] updatedRecords, Map<ID, Booking_Room_Line__c> recordMap, Map<ID, Booking_Room_Line__c> recordMapOld){

         // UtilsMethodeForAccount.flowWithTheCommonValueFromAccountSetting(updatedRecords);
               // added by JKA CRMSS-437
               //BookingRoomLine_Handler.handle(updatedRecords,recordMapOld);	//TMA EI 9-9-2019 PG 275
               
               //end
    }
    
    public void OnAfterUpdate(Booking_Room_Line__c[] oldRecords, Booking_Room_Line__c[] updatedRecords, Map<ID, Booking_Room_Line__c> recordMap,  Map<ID, Booking_Room_Line__c> recordMapOld){  
        

       /* if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_BookingRoomLine') ) //
           || !UtilsBypass.canISkipApexClass('AP01_BookingRoomLine') 
           || !UtilsBypass.canISkipApexMethod('DeleteBookingRoomLine')){
               AP01_BookingRoomLine.DeleteBookingRoomLine(updatedRecords);
               
           } */
        // UtilsMethodeForAccount.flowWithTheCommonValueFromAccountSetting(updatedRecords);
        // added by JKA CRMSS-437
        //TMABNB-JK-55
        //AP01_SObject.UpdateFromSalesforce(trigger.new);
        //BookingRoomLine_Handler.handle(updatedRecords,recordMapOld);	//TMA EI 9-9-2019 PG 275
        
        //end
        
        // added by JKA CRMSS-437
        //TMABNB CRMSS-96
        //AP05_Account.CallWSUpdatePersonAccountInfo(recordMap,recordMapOld);
        //TMABNB CRMSS-236
        // AP06_Account.TrackHistory(updatedRecords, recordMapOld);
        //end
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Booking_Room_Line__c[] recordsToDelete, Map<ID, Booking_Room_Line__c> recordMap){
    }
    
    public void OnAfterDelete(Booking_Room_Line__c[] deletedRecords, Map<ID, Booking_Room_Line__c> recordMap){
        
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Booking_Room_Line__c[] restoredRecords){
        
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