({
    goBack : function(component, event, helper){
        
        helper.goBackHelper(component, event, helper);
    },
    
    doInit : function(component, event, helper){
        
        var mvCall = component.get("v.parentMVCall");
        console.log('mvCall' +mvCall);
        
        if(mvCall == false){
            
            helper.onLoadData(component, event, helper);
        }
    },
})