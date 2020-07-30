/** 
* Apex Class Handler trigger 
*
* @author  JK
* @version 0.1
* @date    20/07/2020
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/
public class BRLHandler {
    ////////////////Attributes/////////////////
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    ////////////////Attributes/////////////////
    
    public BRLHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Booking_Room_Line_V2__c[] newRecords){
        //Delete existing BRL
        AP01_BRL.DeleteExistingBRL(newRecords);
    }
    
    public void OnAfterInsert(Booking_Room_Line_V2__c[] newRecords,Map<ID, Booking_Room_Line_V2__c> recordMap, Map<ID, Booking_Room_Line_V2__c> recordMapOld){
    }
    
    public void OnBeforeUpdate(Booking_Room_Line_V2__c[] oldRecords, Booking_Room_Line_V2__c[] updatedRecords, Map<ID, Booking_Room_Line_V2__c> recordMap, Map<ID, Booking_Room_Line_V2__c> recordMapOld){
    }
    
    public void OnAfterUpdate(Booking_Room_Line_V2__c[] oldRecords, Booking_Room_Line_V2__c[] updatedRecords, Map<ID, Booking_Room_Line_V2__c> recordMap,  Map<ID, Booking_Room_Line_V2__c> recordMapOld){  
    }
    
    public void OnBeforeDelete(Booking_Room_Line_V2__c[] recordsToDelete, Map<ID, Booking_Room_Line_V2__c> recordMap){
    }
    
    public void OnAfterDelete(Booking_Room_Line_V2__c[] deletedRecords, Map<ID, Booking_Room_Line_V2__c> recordMap){  
    }
    
    public void OnUndelete(Booking_Room_Line_V2__c[] restoredRecords){
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