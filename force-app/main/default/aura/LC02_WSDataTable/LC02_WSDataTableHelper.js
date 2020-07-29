({
    loadInformation : function(component, event, helper) {
        var bIncludePaging = component.get('v.includePaging');
        var action = component.get("c.loadTableInformation");
        action.setParams({ 
            bbObjectName : component.get('v.bbObjectName'),
            includePaging: bIncludePaging,
            pageKey : component.get('v.pageKey')  ,
            pageDateKey : component.get('v.pageDateKey')  ,
            sfdcId : component.get('v.recordId')
            
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
                console.log( result);
                if(result.tableWrapper != null && result.tableWrapper.listHeaders != null && result.tableWrapper.listHeaders.length > 0) {
                   
                    component.set('v.isError', false);
                    component.set('v.bHasData', true);                    
                    component.set("v.listHeaders", result.tableWrapper.listHeaders);
                    component.set("v.listRecords", result.tableWrapper.listRecords);
                     console.log( component.get('v.bHasData'));
                     console.log( component.get('v.includePaging'));
                    if(bIncludePaging){
                        if(result.tableWrapper.pageKey != null) {
                            console.log('#### result.tableWrapper.pageKey' + result.tableWrapper.pageKey);
                            component.set('v.pageKey', result.tableWrapper.pageKey);
                            console.log('#### pageKey includ paging ' + component.get('v.pageKey'));
                        }else{
                            console.log('### in else');
                            component.set('v.pageKey', null);
                             console.log('### after else');
                        }
                        console.log('### next cond'); 
                        console.log(result.tableWrapper.pageDateKey);
                        if(result.tableWrapper.pageDateKey != null) {
                            console.log('if not null');
                            component.set('v.pageDateKey', result.tableWrapper.pageDateKey);
                            console.log('setting pageDateKey ' + result.tableWrapper.pageDateKey);
                        }else{
                            console.log('if null');
                             component.set('v.pageDateKey', null);
                             console.log('if null after setting');
                        }
                        
                        
                    }
                }
                else if(result.tableWrapper != null && result.tableWrapper.errorMessage !=null) {
                    component.set('v.errorMessage', result.tableWrapper.errorMessage);
                    component.set('v.isError', true);
                }
                    else if(result.tableWrapper.pageKey == null) {
                        
                        component.set('v.pageKey', null);
                        component.set('v.bHasData', false);
                        component.set('v.listRecords', null);
                        
                        if(result.tableWrapper.pageDateKey == null){
                        component.set('v.pageDateKey', null);
                        }
                    }
            }
        });
        $A.enqueueAction(action);
    }
})