({
    loadInformation : function(component, event, helper) {
        console.log('Helper load info');
        var action = component.get("c.loadTableInformation");
        action.setParams({ 
            pageKey : component.get('v.pageKey')  ,
            sfdcId : component.get('v.recordId')
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('in action callout');
            if(component.isValid() && state === "SUCCESS") {
                console.log('state sucess');
                var result = response.getReturnValue();
                component.set('v.bDataLoaded', true);
                console.log('bDataLoaded ' + component.get('v.bDataLoaded'));
                console.log( result);
                if(result.tableWrapper != null && result.tableWrapper.listHeaders != null && result.tableWrapper.listHeaders.length > 0) {
                    
                    component.set('v.isError', false);
                    component.set('v.bHasData', true);                    
                    component.set("v.listHeaders", result.tableWrapper.listHeaders);
                    component.set("v.listRecords", result.tableWrapper.listRecords);
                }
                else if(result.tableWrapper != null && result.tableWrapper.errorMessage !=null) {
                    component.set('v.errorMessage', result.tableWrapper.errorMessage);
                    component.set('v.isError', true);
                }
            }
        });
        $A.enqueueAction(action);
    },
})