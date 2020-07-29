({
    loadData : function(component, event, helper) {       
        helper.loadInformation(component, event, helper);		
    },
    
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeModal: function(component, event, helper) { 
        component.set("v.isOpen", false);
    }
})