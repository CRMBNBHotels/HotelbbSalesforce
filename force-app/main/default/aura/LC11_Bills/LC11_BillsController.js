({
	loadData : function(component, event, helper) {   
        console.log('In Load Data');
        component.set("v.TypeLabel",$A.get("$Label.c.LC11_Bill_Type"));
        component.set("v.AmountLabel",$A.get("$Label.c.LC11_Bill_Amount"));
        component.set("v.DateLabel",$A.get("$Label.c.LC11_Bill_Date"));
        component.set("v.ViewLabel",$A.get("$Label.c.LC11_Bill_ViewDownload"));
        helper.loadInformation(component, event, helper);		
    },
})