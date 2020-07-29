({
	loadInformation : function(component, event, helper) {
        var action = component.get("c.loadPaymentInformation");
        action.setParams({ 
            sfdcId : component.get('v.recordId')   
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.acceptedPayment", result);
            }
        });
        $A.enqueueAction(action);
    }
})