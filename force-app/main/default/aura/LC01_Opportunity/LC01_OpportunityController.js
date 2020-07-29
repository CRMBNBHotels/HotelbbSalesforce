({
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    E01_Opportunity : function(component, event, helper) {
        var getAllHotel = event.getParam("checkbox"); 
        var AddHotel = [];   
        for (var i = 0; i < getAllHotel.length; i++) {
            if (getAllHotel[i].get("v.value") == true) {
                AddHotel.push(getAllHotel[i].get("v.text"));
            }
        }  
        component.set("v.Selectedhotels", AddHotel);
        var address = event.getParam("address");
        component.set("v.address", address);
    },
    clickCreateHotels : function(component, event, helper) {
        component.set("v.disabled", true);
        if(helper.validateValues(component)){
            var action = component.get("c.createHotel");
            action.setParams({
                "sfdcId":component.get("v.recordId"),
                "ListHotel":component.get("v.Selectedhotels"),
                "address":component.get("v.address")                
            });           
            // Register the callback function
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") { 
                   //do nothing
                }
                else {
                    console.log("Failed with state: " + state);
                }
            });
            // Invoke the service
            $A.enqueueAction(action);
            $A.get("e.force:closeQuickAction").fire();           
            $A.get('e.force:refreshView').fire();             
        }
    },
})