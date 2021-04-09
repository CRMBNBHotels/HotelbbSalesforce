/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/04/2021
* @details : Trigger Handler for Booking Room Line V2
*
*********************************************************************************************************************************************************************/
trigger BookingRlTrigger on Booking_Room_Line_V2__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    // This should be used in conjunction with the TriggerHandlerComprehensive.cls template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    if (!UtilsBypass.canbyPassTrigger('BookingRlTrigger')) {
        BookingRLHandler handler = new BookingRLHandler(Trigger.isExecuting, Trigger.size);
        System.debug('IsTriggerContext:       '+handler.IsTriggerContext) ;
        System.debug('IsVisualforcePageContext:   '+handler.IsVisualforcePageContext);
        System.debug('IsWebServiceContext:       '+handler.IsWebServiceContext);
        System.debug('IsExecuteAnonymousContext:   '+handler.IsExecuteAnonymousContext);
        if(Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }else if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new,Trigger.newMap, Trigger.oldMap);
        }else if(Trigger.isUpdate && Trigger.isBefore){
            handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);           
        }else if(Trigger.isUpdate && Trigger.isAfter){
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
        }else if(Trigger.isDelete && Trigger.isBefore){
            handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }else if(Trigger.isDelete && Trigger.isAfter){
            handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        }else if( trigger.isUnDelete){
            handler.OnUndelete(Trigger.new);
        }
        
    }
}