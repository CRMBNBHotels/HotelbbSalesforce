({
    loadDataHelper : function(component, event, helper) {
        
        var action = component.get("c.GetMasterVouchers");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                
                var result = response.getReturnValue();   
                console.log(result);
                component.set("v.MasterVoucherList", result.listMasterVouch);
            }
            
            else if (state === "ERROR"){                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.setError(component, event, helper,errors[0].message,false);
                    }
                }
            } 
        });
        
        $A.enqueueAction(action);
    },
    
    goToConsultpageHelper : function(component, event, helper) {
      
        var mvId = event.currentTarget.getAttribute("id");
        component.set("v.recordId", mvId);
        component.set("v.consult", true);
    }
})