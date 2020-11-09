({
    showErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Vous dépassez votre quotas, il vous reste “number of available vouchers” invitations. Si vous souhaitez augmentez votre quotas, contactez votre Service client ou votre directeur régional"
        });
        toastEvent.fire();
    }
})