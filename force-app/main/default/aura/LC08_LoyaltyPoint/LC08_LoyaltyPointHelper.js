({
    loadInformation : function(component, event, helper) {
        var action = component.get("c.GetAccountInfo");
        action.setParams({ 
            accountId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.ApexNbPoint", result.E_club_Number_of_points__pc );
                if(result.Tech_BBUS__c || !result.E_club_subscription__pc){
                    if(!result.E_club_subscription__pc ) {      
                        helper.setError(component, event, helper,$A.get("$Label.c.LC08_EClubCustomer"),false);
                    }
                    if(result.Tech_BBUS__c ) {   
                        helper.setError(component, event, helper,$A.get("$Label.c.LC08_RequestBBUS"),false);
                    }
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
    },
    setError: function(component, event, helper,ErrorMessage,displayform) {
        component.set('v.isError', true);
        component.set("v.ErrorMessage", ErrorMessage);
        component.set("v.DisplayForm", displayform);
    },
    showModalHelper : function(component, event, helper){
        var modal = component.find("ModalError");
        $A.util.removeClass(modal, 'hideDiv'); 
        $A.util.addClass(modal, 'slds-fade-in-open');
        // var body = component.find("modalbody");
        //$A.util.addClass(body, 'hideDiv'); 
        var modalBackdrop = component.find("myModal-Back");
        $A.util.addClass(modalBackdrop, 'slds-fade-in-open');
    },
    hideModalHelper : function(component, event, helper){
        var modal = component.find("ModalError");
        $A.util.addClass(modal, 'hideDiv');
        //var body = component.find("modalbody");
        //$A.util.removeClass(body, 'hideDiv'); 
        var modalBackdrop = component.find("myModal-Back");
        $A.util.removeClass(modalBackdrop, 'slds-fade-in-open');
    },
    
    //modified by TMA Cynthia Geagea CRMSS-128 - 27/05/2019
    SendData : function(component, event, helper){
        var action = component.get('c.DoCalculation'); 
        console.log(' component.get(v.NBPoint) '+ component.get('v.NBPoint'));
        action.setParams({ "accountId" : component.get('v.recordId'),
                          "type": component.get('v.Type'),
                          "NumberPoints": component.get('v.NBPoint'),
                          "ApexNbPoint": component.get('v.ApexNbPoint'),
                          "Reason": component.get('v.Raison'),
                          "Description": component.get('v.Description')
                         });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
            dismissActionPanel.fire();
        });
        
        
        /*setTimeout(function(){
             $A.get("e.force:closeQuickAction").fire(); 
		}, 1000);*/
        $A.enqueueAction(action); 
        $A.get('e.force:refreshView').fire();
        
        //   location.reload;
        //   window.reload;
        
        
    },
})