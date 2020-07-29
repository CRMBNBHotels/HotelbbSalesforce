({
    loadData : function(component, event, helper) {
        component.set("v.CancelName",$A.get("$Label.c.LC08_Cancel"));
        component.set("v.SaveName",$A.get("$Label.c.LC08_Save"));
        component.set("v.TypeName",$A.get("$Label.c.LC08_Type"));
        component.set("v.NBPointName",$A.get("$Label.c.LC08_NBPoint"));
        component.set("v.RaisonName",$A.get("$Label.c.LC08_Raison"));
        component.set("v.ModifPTName",$A.get("$Label.c.LC08_ModifierPoints"));
        component.set("v.Ajout",$A.get("$Label.c.LC08_Ajout"));
        component.set("v.Suppression",$A.get("$Label.c.LC08_Suppression"));
        component.set("v.AnnulationEchangeCadeau",$A.get("$Label.c.LC08_AnnulationEchangeCadeau"));
        component.set("v.RegularisationPoints",$A.get("$Label.c.LC08_RegularisationPoints"));
        component.set("v.TransfertPointCompteFusionne",$A.get("$Label.c.LC08_TransfertPointCompteFusionne"));
        component.set("v.AnnulationPointsCreditesRecouvrement",$A.get("$Label.c.LC08_AnnulationPointsCreditesRecouvrement"));
        component.set("v.AnnulationPointCreditee",$A.get("$Label.c.LC08_AnnulationPointCreditee"));
        component.set("v.PointsOffertsDedommagement",$A.get("$Label.c.LC08_PointsOffertsDedommagement"));
        component.set("v.RegulDePointsSuiteRemiseAZero",$A.get("$Label.c.LC08_RegulDePointsSuiteRemiseAZero"));
        component.set("v.DescriptionName",$A.get("$Label.c.LC08_Description"));
        helper.loadInformation(component, event, helper);		
    },
    cancelBtn : function(component, event, helper) { 
        // Close the action panel 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        
        /*setTimeout(function(){
            		$A.get("e.force:closeQuickAction").fire(); 
		}, 1000);*/
    }, 
    SaveBtn: function(component, event, helper) {
        var error ='';
        var dynamicVal = component.find("typeFld").get("v.value");
        var dynamicVal1= component.find("raisonFld").get("v.value");
        var dynamicVal2= component.find("descriptionFld").get("v.value");
        component.set("v.Type", dynamicVal);
        component.set("v.Raison", dynamicVal1);
        component.set("v.Description", dynamicVal2);
        
        console.log('---' + dynamicVal);
        //validate if all fields are filled
        if (component.get('v.Type') == null || component.get('v.Type') == undefined || component.get('v.Type') == ''){
            component.set("v.ErrorMessageType", $A.get("$Label.c.LC08_FillField"));
            if(error =='' || error == null){
                error = $A.get("$Label.c.LC08_ValidateRequired");
            }
        } else {
            // clear error
            component.set("v.ErrorMessageType", null);
            if(error == ''){
                error ='';
            }
        }
        if (component.get('v.NBPoint') == null || component.get('v.NBPoint') == undefined || component.get('v.NBPoint') == ''){
            component.set("v.ErrorMessageNbPoint", $A.get("$Label.c.LC08_FillField"));
            if(error ==''){
                error = $A.get("$Label.c.LC08_ValidateRequired");
            }
            
        }
        else {
            // clear error
            component.set("v.ErrorMessageNbPoint", null);
            if(error == ''){
                error ='';
            }
        }
        
        if (component.get('v.Raison') == null || component.get('v.Raison') == undefined || component.get('v.Raison') == ''){
            component.set("v.ErrorMessageRaison", $A.get("$Label.c.LC08_FillField"));
            if(error ==''){
                error = $A.get("$Label.c.LC08_ValidateRequired");
            }
        }
        else {
            // clear error
            component.set("v.ErrorMessageRaison", null);
            if(error == ''){
                error ='';
            }
        }
        if(error != ''){
           // helper.showModalHelper(component, event, helper);
            helper.setError(component, event, helper, error,true);
            
        }
         if(error == ''){
         helper.SendData(component, event, helper);
         }
        
        //Added vy TMA Cynthia Geagea - CRMSS 260 - 19/09/2019 - Start
        //Disable the button
        var btn = event.getSource();
        btn.set("v.disabled",true);
        //Added vy TMA Cynthia Geagea - CRMSS 260 - 19/09/2019 - End
    },
    hideModal : function(component, event, helper){
        helper.hideModalHelper(component, event, helper);
    }
})