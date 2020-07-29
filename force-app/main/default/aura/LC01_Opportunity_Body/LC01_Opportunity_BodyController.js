({
    doInitHotel : function(component, event, helper) {
        // Create the action
        var action = component.get("c.getHotels");       
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.hotels", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });        
        // Send action off to be executed
        $A.enqueueAction(action);
    },   
    fireEvent : function(component, event, helper) {
        var myEvent = component.getEvent("E01_Opportunity_Body"); 
        myEvent.setParams({"checkbox": component.find("checkedHotel"),                         
                           "address":component.get("v.searchKey")});
        myEvent.fire();
    },
    
    displayOptionsLocation: function(component, event, helper) {
        if(helper.validateLength(component)){
            var action = component.get("c.getAddressAutoComplete");
            action.setParams({
                "input": component.get("v.searchKey")
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var listAddresses = helper.getAddresses(response.getReturnValue());
                    component.set("v.filteredOptions", listAddresses); 
                    helper.NoHotelsIfListAddressesNull(component,listAddresses);
                }
            });
            $A.enqueueAction(action);
        }      
    },
    clearCheckedBox: function(component, event, helper){
        helper.removeAllCheckedBox(component);
    },
    pickAddress: function(component, event, helper){
        var address = component.find("predictions").get("v.value");
        component.set("v.searchKey",address);
        component.set("v.filteredOptions",null);         
        var address = component.get("v.searchKey");   
        
        var action = component.get("c.getlocationlatlong");
        action.setParams({"address":address});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var latlong = helper.ParseLatLong(response.getReturnValue());                                      
                helper.TestLatLong(component,latlong);               
                var action1 = component.get("c.Filter");
                action1.setParams({"latlong":latlong});
                action1.setCallback(this, function(response) {                    
                    var state1 = response.getState();
                    if (component.isValid() && state1 === "SUCCESS") {                
                        component.set("v.hotels", response.getReturnValue());                      
                    }                 
                });        
                $A.enqueueAction(action1); 
            }
        });    
        $A.enqueueAction(action);         
    }
})