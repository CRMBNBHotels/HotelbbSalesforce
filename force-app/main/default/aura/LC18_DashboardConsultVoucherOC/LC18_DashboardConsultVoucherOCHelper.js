({
    goBackHelper : function(component, event, helper) {

        component.set("v.consultVouch", false);
    },
    
    onLoadData : function(component, event, helper){
        
        var codeVouchOC = component.get("v.codeVouchOC");

        var action = component.get("c.GetVoucherOC");
        action.setParams({ 
            codeVouch : component.get('v.codeVouchOC')
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("state: "+state);
            if(state == "SUCCESS") {
                
                var result = response.getReturnValue(); 
                console.log(result);
                component.set("v.recordId", result.voucherOCSFID);
                component.set("v.mvrecordId", result.parentMVOCSFID);
                console.log(component.get("v.recordId"));
                console.log(component.get("v.mvrecordId"));
                
            }
            
            else if (state == "ERROR"){                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0] && errors[0].message);
                    }
                }
            } 
        });
        
        $A.enqueueAction(action);
    }
})