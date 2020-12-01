({
    doInit : function(component, event, helper) {
        
        var emitEmail = component.get("v.emitEmail");
        var clientId = component.get("v.clientId");
        
        //CRMSS-960 26/11/2020
        var hotelEmitId = component.get("v.hotelEmitId");
        var serviceEmit = component.get("v.serviceEmit");
        
        var action = component.get("c.GetDefaultInfo");
        action.setParams({ 
            clientExtId : component.get('v.clientId'),
            hotelEmitExtId : component.get('v.hotelEmitId')
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("state 0"+state);
            if(state == "SUCCESS") {
                
                var result = response.getReturnValue();   
                console.log("result: "+result);
                component.set("v.clientSFId", result.personAccountSFID);
                component.set("v.hotelEmitSFId", result.hotelEmitterSFID);

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
        
        //CRMSS-971 01/12/2020
        var action2 = component.get("c.GetRemainingQuotas");
        action2.setParams({ 
            userEmail : component.get('v.emitEmail'),
            nbCopies : component.get('v.nbVouchOC')
        });

        action2.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("state"+state);
            if(state == "SUCCESS") {
                
                var result = response.getReturnValue(); 
                console.log(result);
                component.set("v.nbVouchOCAvailable", result.nbAvailableVouch);
                component.set("v.hotelierRole", result.hotelierEmitter);
                console.log("result.nbAvailableVouch"+result.nbAvailableVouch);
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
        
        $A.enqueueAction(action2);
       
    },

    handleSubmit: function(component, event, helper) {
       
        event.preventDefault();       // stop the form from submitting
     
        //CRMSS-868 05/11/2020
        var copies = component.find("copies").get('v.value');console.log("copies"+copies);
        component.set("v.nbVouchOC", copies);
        
        var action = component.get("c.GetRemainingQuotas");
        action.setParams({ 
            userEmail : component.get('v.emitEmail'),
            nbCopies : component.get('v.nbVouchOC')
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("state"+state);
            if(state == "SUCCESS") {
                
                var result = response.getReturnValue(); 
                component.set("v.nbVouchOCremain", result.remainingVouchOC);
                console.log("result.remainingVouchOC"+result.remainingVouchOC);
                component.set("v.nbVouchOCAvailable", result.nbAvailableVouch);
                console.log("result.nbAvailableVouch"+result.nbAvailableVouch);

                if(result.remainingVouchOC >= 0){
                    console.log("in success toast");
                    var fields = event.getParam('fields');
                    component.find('editForm').submit(fields);
                }
                else{
                    
                    alert("Vous dépassez votre quotas, il vous reste "+result.nbAvailableVouch+" invitation(s). Si vous souhaitez augmenter votre quotas, contactez votre directeur régional. Merci.");
                    
                }

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
		
    },

    handleSuccess : function(component, event, helper) {
        
        var record = event.getParam("response");
        var apiName = record.apiName;
       
        component.set("v.newRecordID",record.id); // ID of updated or created record
        component.set("v.consultMV", true);//Show the Master Voucher OC Consultation page after successfully submitting it to SF
    }
})