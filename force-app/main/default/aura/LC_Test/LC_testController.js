({
    doInit : function(component, event, helper) {

        var emitEmail = component.get("v.emitEmail");
    },

    handleSubmit: function(component, event, helper) {
       
        event.preventDefault();       // stop the form from submitting
     
        //CRMSS-868 05/11/2020
        var copies = component.find("copies").get('v.value');
        component.set("v.nbVouchOC", copies);
        
        var action = component.get("c.GetRemainingQuotas");
        action.setParams({ 
            userEmail : component.get('v.emitEmail'),
            nbCopies : component.get('v.nbVouchOC')
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                
                var result = response.getReturnValue();   
                console.log(result);
                component.set("v.nbVouchOCremain", result.remainingVouchOC);

                if(result.remainingVouchOC >= 0){

                    var fields = event.getParam('fields');
                    component.find('editForm').submit(fields);
                }
                else{
                    helper.showErrorToast(component, event, helper);
                }

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


        //var fields = event.getParam('fields');
        //component.find('editForm').submit(fields);
		
    },

    handleSuccess : function(component, event, helper) {
        
        var record = event.getParam("response");
        var apiName = record.apiName;
       
        component.set("v.newRecordID",record.id); // ID of updated or created record
        component.set("v.consultMV", true);//Show the Master Voucher OC Consultation page after successfully submitting it to SF
    }
})