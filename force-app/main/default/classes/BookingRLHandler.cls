/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/04/2021
* @details : Apex Class Handller Trigger
*
*********************************************************************************************************************************************************************/
public without sharing class BookingRLHandler {
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public BookingRLHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Booking_Room_Line_V2__c[] newRecords){

    }
    
    public void OnAfterInsert(Booking_Room_Line_V2__c[] newRecords,Map<ID, Booking_Room_Line_V2__c> recordMap, Map<ID, Booking_Room_Line_V2__c> recordMapOld){
        List<Id> BookingRLList = New List<Id>();
		system.debug('newRecords'+newRecords);
        for (Booking_Room_Line_V2__c BRL : newRecords){
            BookingRLList.add(BRL.Booking__c);
            system.debug('BookingRlLIST'+BookingRLList);
        }
		
        system.debug('@@@ OnAfterInsert');
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP03_BookingRoomLine') )
           || !UtilsBypass.canISkipApexClass('AP03_BookingRoomLine') 
           || !UtilsBypass.canISkipApexMethod('DeleteBookingRoomLines')){
             AP03_BookingRoomLine.DeleteBookingRoomLines(BookingRLList);
        }
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Booking_Room_Line_V2__c[] oldRecords, Booking_Room_Line_V2__c[] updatedRecords, Map<ID, Booking_Room_Line_V2__c> recordMap, Map<ID, Booking_Room_Line_V2__c> recordMapOld){

    }
    
    public void OnAfterUpdate(Booking_Room_Line_V2__c[] oldRecords, Booking_Room_Line_V2__c[] updatedRecords, Map<ID, Booking_Room_Line_V2__c> recordMap,  Map<ID, Booking_Room_Line_V2__c> recordMapOld){ 

    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Booking_Room_Line_V2__c[] recordsToDelete, Map<ID, Booking_Room_Line_V2__c> recordMap){
        
    }
    
    public void OnAfterDelete(Booking_Room_Line_V2__c[] deletedRecords, Map<ID, Booking_Room_Line_V2__c> recordMap){

    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
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