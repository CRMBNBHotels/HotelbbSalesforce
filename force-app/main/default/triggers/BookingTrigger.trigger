/**
* @author TMA-EIT CG
* @date 24/11/2020
* @description: Booking Object Trigger, containing all trigger events
* @test class : 
* @coverage: 
*/

trigger BookingTrigger on Booking__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

        // This should be used in conjunction with the TriggerHandlerComprehensive.cls template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    
    if (!UtilsBypass.canbyPassTrigger('BookingTrigger')) {
        
        BookingHandler handler = new BookingHandler(Trigger.isExecuting, Trigger.size);
        
         if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new);
        } 
        if(Trigger.isUpdate && Trigger.isAfter){
            handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        }      
    }
}