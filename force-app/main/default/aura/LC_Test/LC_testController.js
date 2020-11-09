({
    doInit : function(component, event, helper) {

        var emitEmail = component.get("v.emitEmail");
    },

    handleSubmit: function(component, event, helper) {
       
        event.preventDefault();       // stop the form from submitting
        
        component.set("v.nbVouchOC",record.Nombre_de_copie_s__c);//CRMSS-868 05/11/2020
        var fields = event.getParam('fields');
        component.find('editForm').submit(fields);
		
    },

    handleSuccess : function(component, event, helper) {
        
        var record = event.getParam("response");
        var apiName = record.apiName;
       
        component.set("v.newRecordID",record.id); // ID of updated or created record
        component.set("v.consultMV", true);//Show the Master Voucher OC Consultation page after successfully submitting it to SF
    }
})