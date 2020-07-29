({
    loadInformation : function(component, event, helper) {
        var bIncludePaging = component.get('v.includePaging');
        var action = component.get("c.loadTableInformation");
        action.setParams({ 
            bbObjectName : component.get('v.bbObjectName'),
            includePaging: bIncludePaging,
            pageKey : component.get('v.pageKey')  ,
            sfdcId : component.get('v.recordId'),
            PageDateKey : component.get('v.PageDateKey')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                var bPageLoaded = component.get('v.bPageLoaded');
                if(!bPageLoaded) {
                    component.set('v.bPageLoaded', true);
                }
                component.set('v.bDataLoaded', true);
                if(result.tableWrapper != null && result.tableWrapper.listHeaders != null && result.tableWrapper.listHeaders.length > 0) {
                    component.set('v.isError', false);
                    component.set('v.bHasData', true);                    
                    component.set("v.listHeaders", result.tableWrapper.listHeaders);
                    component.set("v.listRecords", result.tableWrapper.listRecords);
                    if(bIncludePaging){
                        if(result.tableWrapper.pageKey != null) {
                            component.set('v.pageKey', result.tableWrapper.pageKey);
                        }
                         if(result.tableWrapper.pageDateKey != null) {
                            component.set('v.pageDateKey', result.tableWrapper.pageDateKey);
                        }
                    }
                }
                else if(result.tableWrapper != null && result.tableWrapper.errorMessage !=null) {
                    component.set('v.errorMessage', result.tableWrapper.errorMessage);
                    component.set('v.isError', true);
                }
                    else if(result.tableWrapper.pageKey == null) {
                        component.set('v.pageKey', null);
                        component.set('v.pageDateKey', null);
                        component.set('v.bHasData', false);
                        component.set('v.listRecords', null);
                    }
            }
        });
        $A.enqueueAction(action);
    }
})