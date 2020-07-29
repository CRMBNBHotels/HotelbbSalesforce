/** 
* Apex trigger containing all event
*
* @author  Omar Bensouda Korachi <o.bensouda@obkconsulting.com>
* @version 0.1
* @date    11/10/2019 
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/
trigger AccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    // This should be used in conjunction with the TriggerHandlerComprehensive.cls template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    if (!UtilsBypass.canbyPassTrigger('AccountTrigger')) {
        AccountHandler handler = new AccountHandler(Trigger.isExecuting, Trigger.size);
        System.debug('IsTriggerContext: 			'+handler.IsTriggerContext) ;
        System.debug('IsVisualforcePageContext: 	'+handler.IsVisualforcePageContext);
        System.debug('IsWebServiceContext: 			'+handler.IsWebServiceContext);
        System.debug('IsExecuteAnonymousContext: 	'+handler.IsExecuteAnonymousContext);
        if(Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }else if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new,Trigger.newMap, Trigger.oldMap);
            if((!System.isFuture() && !System.isBatch())){
                AccountHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
            }
        }else if(Trigger.isUpdate && Trigger.isBefore){
            handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
            
        }else if(Trigger.isUpdate && Trigger.isAfter){
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
            if((!System.isFuture() && !System.isBatch())){
                AccountHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
            }
            
        }else if(Trigger.isDelete && Trigger.isBefore){
            handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }else if(Trigger.isDelete && Trigger.isAfter){
            handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
            if((!System.isFuture() && !System.isBatch())){
                AccountHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
            }
        }else if( trigger.isUnDelete){
            handler.OnUndelete(Trigger.new);
        }
        
    }
}