({
    loadDataHelper : function(component, event, helper) {
        
        var action = component.get("c.GetRelatedVouchers");
        action.setParams({ 
            mvId : component.get('v.mvrecordId')
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                
                var result = response.getReturnValue();   
                console.log(result);
                component.set("v.RelatedVouchersList", result.listRelatedVouchers);
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
    
    goToVoucherConsultpageHelper : function(component, event, helper) {
        
        var vouchId = event.currentTarget.getAttribute("id");
        component.set("v.vouchrecordId", vouchId);
        component.set("v.consultVouch", true);
    },
    
    generatePDFHelper : function(component, event, helper) {
     
        var masterVouchId = component.get('v.mvrecordId');
        window.open("/apex/VFP01_MasterVoucher?Id="+masterVouchId, "_blank");
    },
    
    goBackHelper : function(component, event, helper) {

        component.set("v.consult", false);
    }
    
})