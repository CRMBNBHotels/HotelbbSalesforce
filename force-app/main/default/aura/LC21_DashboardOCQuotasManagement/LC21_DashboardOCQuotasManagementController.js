({
    doInit : function(component, event, helper) {  
        
        var connectEmail = component.get("v.connectEmail");
        
        component.set('v.columns', [
            {label: 'Année courante', fieldName: 'Tech_CurrentYear__c', type: 'integer'},
            {label: 'Hotel', fieldName: 'Tech_HotelName__c', type: 'text'},
            {label: 'Hotelier', fieldName: 'Tech_ContactName__c', type: 'text'},
            {label: 'Maximum d\'\invitations', fieldName: 'Maximun_invitations__c', editable:'true', type: 'integer'},
            {label: 'Invitations restantes'}
        ]);        
        
        helper.getQuotasData(component, helper);
    },
    
    onSave : function (component, event, helper) {
        
        helper.saveDataTable(component, event, helper);
    }
})