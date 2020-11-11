({
    loadDataHelper : function(component, event, helper) {
        
        var action = component.get("c.GetQuotas");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                
                var result = response.getReturnValue();   
                console.log(result);
                component.set("v.quotaList", result.listContRole);
            }
            
            else if (state === "ERROR"){                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                    }
                }
            } 
        });
        
        $A.enqueueAction(action);
    }
})
