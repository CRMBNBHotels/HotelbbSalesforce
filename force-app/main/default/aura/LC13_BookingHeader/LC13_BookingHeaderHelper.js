/*******************************************************************************************************************************************************************

*
* -- Date         Name              Version  Remarks
* -- -----------  ----------        -------  ---------------------------------------
* -- 18-Jun-2020  Consultant TMA    1.0     
* -- 17-MAR-2021  Amira             2.0     CRMSS-1073 : Ajouter l'IDUNIX avant le nom de l'hôtel dans le header
*
*********************************************************************************************************************************************************************/

({
	loadDataHelper : function(component, event, helper) {
        
        var action = component.get("c.GetBookingInfo");
        action.setParams({ 
            bookingId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                
                var result = response.getReturnValue();
                component.set("v.Stage", result.Stage__c );
                component.set("v.ArrivalDate", result.Arrival_date__c );   
                component.set("v.DepartureDate", result.Departure_date__c);
                component.set("v.InvoicedAmnt", result.Invoiced_amount_TTC__c);
                component.set("v.OCStatus", result.CAD_Status__c);
                component.set("v.PMSBookId", result.PMS_booking_ID__c);
                component.set("v.IdCrsVb", result.ID_CRS_VB__c);
                component.set("v.Updatable", result.Modifiable_Reservation_Date__c);
                component.set("v.Cancellable", result.Cancellable_Booking__c);
                
                if(result.Hotel__c != null){
                    
                    component.set("v.Hotel", result.Hotel__c );
                    
                    if(result.Hotel__r.Commercial_Hotel_Name__c != null && result.Hotel__r.Commercial_Hotel_Name__c != ''){
                        
                        component.set("v.HotelName", result.Hotel_Name_IDUNIX__c);
                    }
                    else{
                        
                        component.set("v.HotelName",null);
                    }
                }
                else{
                    
                    component.set("v.HotelName",null);
                }
            }
            
            /*  else if (state === "ERROR"){                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.setError(component, event, helper,errors[0].message,false);
                    }
                }
            }*/
            
        });
        $A.enqueueAction(action);
    }
})