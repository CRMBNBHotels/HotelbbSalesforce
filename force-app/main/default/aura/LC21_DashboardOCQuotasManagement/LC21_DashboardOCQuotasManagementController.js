({
    doInit : function(component, event, helper) {  
        
        var connectEmail = component.get("v.connectEmail");
        
        component.set('v.columns', [
            {label: 'Année courante', fieldName: 'currentYear', type: 'double'},
            {label: 'Hôtel', fieldName: 'hotelName', type: 'text'},
            //{label: 'Hotelier', fieldName: 'hotelierName', type: 'text'}, //Commented because Hotelier Name must be removed from the component
            {label: 'Maximum d\'\invitations', fieldName: 'maxInvit', editable:'true', type: 'double'},
            {label: 'Invitations restantes', fieldName: 'remainInvit', type: 'double'}
        ]);        
        
        helper.getQuotasData(component, helper);
    },
    
    onSave : function (component, event, helper) {
        
        helper.saveDataTable(component, event, helper);
    }
})