({
    validateValues : function(component) {
        var validValues = true;
        if(component.get("v.Selectedhotels").length == 0){
            validValues = false;
            alert('PLEASE SELECT AT LEAST ONE HOTEL'); 
            component.set("v.disabled", false);
        } 
        return validValues;
    }
})