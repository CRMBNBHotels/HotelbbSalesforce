({
    TestLatLong: function(component,latlong){
        var addressField = component.find("addressText");
        if(latlong=="OVER_QUERY_LIMIT"){                  
            addressField.set("v.errors",[{message:"OVER_QUERY_LIMIT"}]); 
        }                                                          
        if(latlong=="ZERO_RESULTS"){
            addressField.set("v.errors",[{message:"This address is not a valid address"}]); 
        }
        if(latlong!="OVER_QUERY_LIMIT" && latlong!="ZERO_RESULTS"){
            addressField.set("v.errors",null); 
        }  
    },
    ParseLatLong: function(res){
        var data = JSON.parse(res);
        var latlong;
        if(data.status=="OVER_QUERY_LIMIT" || data.status=="ZERO_RESULTS"){
            latlong = data.status;
        }
        else{                 
            var lat = data.results[0].geometry.location.lat;
            var long = data.results[0].geometry.location.lng;
            latlong = lat+','+long;
        } 
        return latlong;
    },
    getAddresses: function(res){
        var data = JSON.parse(res);
        var listAddresses = [];
        var getAllPredictions = data.predictions;
        if(data.status!="OVER_QUERY_LIMIT" || data.status!="ZERO_RESULTS"){
            for(var i=0; i < getAllPredictions.length;i++){
                listAddresses.push(getAllPredictions[i].description);
            }
        }
        return listAddresses;
    },
    validateLength : function(component) {
        var validValue = true;
        var searchKey = component.get("v.searchKey");        
        if(searchKey.length<3){
            validValue = false;
            component.set("v.filteredOptions",null);               
        }  
        if(searchKey.length == 0){
            component.InitHotel();
        }
        return validValue;
    },
    NoHotelsIfListAddressesNull:function(component,listAddresses){
        if(listAddresses.length == 0){
            component.set("v.hotels",null);
        }
    },
    removeAllCheckedBox:function(component){
        var checkBoxes = component.find("checkedHotel");
        if(checkBoxes != null){
            for(var i=0; i < checkBoxes.length; i++){
                checkBoxes[i].set("v.value",false);
            }
            component.CallEvent();
        }  
    }
})