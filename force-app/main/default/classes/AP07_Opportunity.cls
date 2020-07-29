/*
* Description: Controller class for opportunity lightning components
* @author: Georges Hobeika
* @date: 08/01/2019
* @Test class: AP07_Opportunity_Test
*/

// questions :
// 1- Can we update opportunity tripContext whatever the status is ?
// 2- Trip Context field on Booking should not be picklist ?

public without sharing class AP07_Opportunity {
   
    static String actionAdd = 'ADD';
    static String actionRemove = 'REMOVE';
    static Map<Id, Map<String, Integer>> mapAccountIdTripContextCounter;
    static Set<Integer> setGuestAccountFields = null;
    
    public static void calculateBookingTripContext(List<Opportunity> listNewBookings, Map<Id, Opportunity> mapOldBookings) {
        mapAccountIdTripContextCounter = new Map<Id, Map<String, Integer>>();
        Id booking_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId();
        if(booking_RT != null) {
            String tripContext = null;
            Opportunity oldBooking = null;
            String persAccId;
            String oldPersAccId;
            String fieldName;
            if(listNewBookings != null) {
                for(Opportunity booking : listNewBookings) {
                    tripContext = booking.Trip_Context__c;
                    if(booking.RecordTypeId == booking_RT) {
                        if(mapOldBookings == null) {
                            // insert mode
                            if(tripContext != null && (tripContext.equalsIgnoreCase(Label.BusinessCustomerType) || tripContext.equalsIgnoreCase(Label.LeisureCustomerType))){
                                setGuestAccountFields = new Set<Integer>{1,2,3,4,5};
                                fillTripContextMaps(booking, tripContext.toUpperCase(), actionAdd);
                            } 
                        } else {
                            // update mode
                            oldBooking = mapOldBookings.get(booking.Id);
                            if((tripContext == null && oldBooking.Trip_Context__c != null) || !tripContext.equalsIgnoreCase(oldBooking.Trip_Context__c)) {
                                // Trip context changed
                                setGuestAccountFields = new Set<Integer>{1,2,3,4,5};
                                if(oldBooking.Trip_Context__c != null) {
                                    fillTripContextMaps(oldBooking, oldBooking.Trip_Context__c.toUpperCase(), actionRemove);
                                }
                                if(tripContext != null) {
                                    fillTripContextMaps(booking, tripContext.toUpperCase(), actionAdd);
                                }
                            } else if(tripContext != null){
								setGuestAccountFields = new Set<Integer>();
                                // Guest Account changed
                                for(Integer i = 1 ; i <= 5 ; i++) {
                                    fieldName = 'Guest_Account_' + i + '__c';
            						persAccId = (String)booking.get(fieldName);
                                    oldPersAccId = (String)oldBooking.get(fieldName);
                                    if(persAccId != oldPersAccId) {
                                        setGuestAccountFields.add(i);
                                    }
                                }
                                if(setGuestAccountFields.size() > 0) {
                                    fillTripContextMaps(oldBooking, tripContext.toUpperCase(), actionRemove);
                                    fillTripContextMaps(booking, tripContext.toUpperCase(), actionAdd);
                                }
                            }
                        }
                    }
                    
                } 
            } else {
                // delete mode
                for(Opportunity booking : mapOldBookings.values()) {
                    tripContext = booking.Trip_Context__c;
                    if(booking.RecordTypeId == booking_RT) {
                        setGuestAccountFields = new Set<Integer>{1,2,3,4,5};
                        fillTripContextMaps(booking, tripContext.toUpperCase(), actionRemove);
                    }
                }
            }
            if(mapAccountIdTripContextCounter.size() > 0) {
               // AP04_Account.recalculateCustomerType(mapAccountIdTripContextCounter);
            }
            
        }
    }
    
    private static void fillTripContextMaps(Opportunity booking, String tripContext, String actionType) {
        Integer counter  = actionType.equals(actionAdd) ? 1 : -1;
        Integer contextCounter;
        String fieldName = null;
        String personAcctId = null;
        Map<String, Integer> mapTripContext = null;
        for(Integer i = 1 ; i <= 5 ; i++) {
            if(setGuestAccountFields.contains(i)) {
                fieldName = 'Guest_Account_' + i + '__c';
                personAcctId = (String)booking.get(fieldName);
                if(personAcctId != null) {
                    if(!mapAccountIdTripContextCounter.containsKey(personAcctId)) {
                        mapAccountIdTripContextCounter.put(personAcctId, new Map<String, Integer>());
                    }
                    mapTripContext = mapAccountIdTripContextCounter.get(personAcctId);
                    if(!mapTripContext.containsKey(tripContext)) {
                        mapTripContext.put(tripContext, counter);
                    } else {
                        contextCounter = mapTripContext.get(tripContext);
                        contextCounter += counter;
                        mapTripContext.put(tripContext, contextCounter);
                    }
                }
            }
        }
    }
}