/** 
* Apex trigger containing all event
*
* @author JKA
* @version 0.1
* @date    22/01/2020
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/
trigger ContactTrigger on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    if (!UtilsBypass.canbyPassTrigger('ContactTrigger')) {
        ContactHandler handler = new ContactHandler(Trigger.isExecuting, Trigger.size);
           System.debug('IsTriggerContext: 			'+handler.IsTriggerContext) ;
        System.debug('IsVisualforcePageContext: 	'+handler.IsVisualforcePageContext);
        System.debug('IsWebServiceContext: 			'+handler.IsWebServiceContext);
        System.debug('IsExecuteAnonymousContext: 	'+handler.IsExecuteAnonymousContext);
        if(Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }else if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new,Trigger.newMap, Trigger.oldMap);
            if((!System.isFuture() && !System.isBatch())){
                ContactHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
            }
        }else if(Trigger.isUpdate && Trigger.isBefore){
            handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
            
        }else if(Trigger.isUpdate && Trigger.isAfter){
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
            if((!System.isFuture() && !System.isBatch())){
                ContactHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
            }
        }else if(Trigger.isDelete && Trigger.isBefore){
            handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }else if(Trigger.isDelete && Trigger.isAfter){
            handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
            if((!System.isFuture() && !System.isBatch())){
                ContactHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
            }
        }else if( trigger.isUnDelete){
            handler.OnUndelete(Trigger.new);
        }
        
    }
}