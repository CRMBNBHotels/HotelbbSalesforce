/*
* 
* @author: Georges Hobeika
* @date: 06/27/2018 
* @ Test: AP05_Opportunity_Test 90%
*/

public without sharing class AP05_Opportunity {
    
    static String actionAdd = 'ADD';
    static String actionRemove = 'REMOVE'; 
    static Set<String> setCountryCodes;
    static Set<Integer> setGuestAccountFields = null;
    
    
    public static void doCalculateGuestHistoryField(List<Opportunity> listBookings, Map<Id, Opportunity> mapOldBookings) {
        system.debug('@@@ ap05 new doCalculateGuestHistoryField');
        Map<Id, AccountDataHistory> mapGuestNewData = new Map<Id, AccountDataHistory>();
        Set<Integer> setGuestAccountFields = new Set<Integer> {};
            Set<Integer> setUpdatedGuestFields = new Set<Integer> {};
                //Id booking_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId();
                Id booking_RT =  Label.BookingRecordTypeId;
        
        String actionType; 
        String strTripContext;
        String bookingStatus;
        Opportunity oldBooking;
        for(Opportunity booking : listBookings) {
            if(booking.RecordTypeId != null && booking.RecordTypeId == booking_RT && (booking.Trip_Context__c != null || booking.HotelCountry__c != null)) { 
                system.debug('@@@ Trigger.isupdate' + trigger.isupdate);
                setUpdatedGuestFields.clear();
                setGuestAccountFields.clear();
                setGuestAccountFields = new Set<Integer> {};
            	setUpdatedGuestFields = new Set<Integer> {};
                /* for(Integer i = 1 ; i <= 5 ; i++) { 
if((String)booking.get('Guest_Account_' + i + '__c') != null) {
setGuestAccountFields.add(i);
} 
if(Trigger.isUpdate) {
oldBooking = mapOldBookings.get(booking.Id);
if((String)booking.get('Guest_Account_' + i + '__c') != (String)oldBooking.get('Guest_Account_' + i + '__c')) {
setUpdatedGuestFields.add(i);
if(!setGuestAccountFields.contains(i)) {
setGuestAccountFields.add(i);
}
}
}
}*/
                if(!Trigger.isUpdate ) {//&& setGuestAccountFields.size() > 0
                    actionType = Trigger.isDelete ? actionRemove : actionAdd;
                    //1- Trip Context 
                    if(setGuestAccountFields.size() > 0)
                        doCalculateTripContext(booking, mapGuestNewData, actionType,setGuestAccountFields);
                    //2- Country Percentages
                    if(booking.person_account__c != null && (booking.StageName == 'Checked' || booking.StageName == 'Booked') && 
                       (booking.Channel_MB__c == 'Apps' || booking.Channel_MB__c == 'Dashboard' || booking.Channel_MB__c == 'Website'))
                        doCalculateCountryPercentage(booking, mapGuestNewData, actionType, null, setGuestAccountFields);
                    //3- Total Nights
                    // doCalculateTotalNights(booking, mapGuestNewData, actionType, setGuestAccountFields);
                    //4- Total Revenues
                    //  doCalculateTotalRevenues(booking, mapGuestNewData, actionType, setGuestAccountFields);
                } else if(Trigger.isUpdate) {
                    oldBooking = mapOldBookings.get(booking.Id);
                    //1- Trip Context 
                    strTripContext = booking.Trip_Context__c == null ? '' : booking.Trip_Context__c;
                    system.debug(setUpdatedGuestFields);
                    system.debug(booking);
                    system.debug(oldBooking);
                    system.debug(strTripContext);
                    if(setUpdatedGuestFields.size() > 0 || booking.StageName != oldBooking.StageName || !strTripContext.equalsIgnoreCase(oldBooking.Trip_Context__c)) {
                        doCalculateTripContext(oldBooking, mapGuestNewData, actionRemove, setGuestAccountFields);
                        doCalculateTripContext(booking, mapGuestNewData, actionAdd, setGuestAccountFields);
                    }
                    //2- Country Percentages
                    // if(setUpdatedGuestFields.size() > 0 || booking.StageName != oldBooking.StageName) {
                    if(booking.person_account__c != oldBooking.person_account__c || (booking.StageName != oldBooking.StageName && (oldBooking.StageName == 'Booked' || oldBooking.StageName == 'Checked')) && 
                      (booking.Channel_MB__c == 'Apps' || booking.Channel_MB__c == 'Dashboard' || booking.Channel_MB__c == 'Website'))
                        doCalculateCountryPercentage(oldBooking, mapGuestNewData, actionRemove, null, setGuestAccountFields);
                    if(booking.person_account__c != oldBooking.person_account__c || (booking.StageName != oldBooking.StageName && (booking.StageName == 'Booked' || booking.StageName == 'Checked')) && 
                        (booking.Channel_MB__c == 'Apps' || booking.Channel_MB__c == 'Dashboard' || booking.Channel_MB__c == 'Website'))
                        doCalculateCountryPercentage(booking, mapGuestNewData, actionAdd, null, setGuestAccountFields);
                    // }
                    /* //3- Total Nights
if(setUpdatedGuestFields.size() > 0 || booking.StageName != oldBooking.StageName || booking.Max_Departure__c != oldBooking.Max_Departure__c || booking.Min_Arrival__c != oldBooking.Min_Arrival__c) {
doCalculateTotalNights(oldBooking, mapGuestNewData, actionRemove, setGuestAccountFields);
doCalculateTotalNights(booking, mapGuestNewData, actionAdd, setGuestAccountFields);
}
//3- Total Revenues
if(setUpdatedGuestFields.size() > 0 || booking.StageName != oldBooking.StageName || booking.Max_Departure__c != oldBooking.Max_Departure__c || booking.Min_Arrival__c != oldBooking.Min_Arrival__c
|| booking.Price__c != oldBooking.Price__c) {
doCalculateTotalRevenues(oldBooking, mapGuestNewData, actionRemove, setGuestAccountFields);
doCalculateTotalRevenues(booking, mapGuestNewData, actionAdd, setGuestAccountFields);
}*/
                }
            }
        } 
        system.debug('mapGuestNewData ' + mapGuestNewData);
        if(mapGuestNewData.size() > 0) {
            AP04_Account.doUpdateGuestFields(mapGuestNewData);
        }
    } 
    
    
    public static void doCalculateTripContext(Opportunity booking, Map<Id, AccountDataHistory> mapGuestIdNewData, String actionType, Set<Integer> setGuestAccountFields) {
        system.debug('@@@ ap05 new doCalculateTripContext');
        Integer nbrToAddOrRemove  = actionType.equals(actionAdd) ? 1 : -1;
        String fieldName;
        String strTripContext = booking.Trip_Context__c;
        String personAcctId = null;
        if(String.isNotBlank(strTripContext) && booking.StageName.equalsIgnoreCase(Label.StageChecked) && 
           (strTripContext.equalsIgnoreCase(Label.BusinessCustomerType) || strTripContext.equalsIgnoreCase(Label.LeisureCustomerType))) {
               for(Integer guestFieldIndex : setGuestAccountFields) {
                   fieldName = 'Guest_Account_' + guestFieldIndex + '__c';
                   personAcctId = (String)booking.get(fieldName);
                   if(personAcctId != null) {
                       if(!mapGuestIdNewData.containsKey(personAcctId)) {
                           mapGuestIdNewData.put(personAcctId, new AccountDataHistory());
                       } 
                       if(booking.Trip_Context__c.equalsIgnoreCase(Label.BusinessCustomerType)) {
                           mapGuestIdNewData.get(personAcctId).CustomerType.business += nbrToAddOrRemove;
                       } else if(booking.Trip_Context__c.equalsIgnoreCase(Label.LeisureCustomerType)) {
                           mapGuestIdNewData.get(personAcctId).CustomerType.leisure += nbrToAddOrRemove;
                       }
                   }
               }
           }
    } 
    
    /* public static void doCalculateTotalNights(Opportunity booking, Map<Id, AccountDataHistory> mapGuestIdNewData, String actionType, Set<Integer> setGuestAccountFields) {
if(booking.Max_Departure__c != null && booking.Min_Arrival__c != null && booking.StageName == Label.StageChecked && booking.OnTheCurrentYear__c) {
String fieldName = null;
String personAcctId = null;
Integer nbrOfNights;
AccountDataHistory dataHistoryObject;
boolean isFound;
for(Integer guestFieldIndex : setGuestAccountFields) {
isFound = false;
fieldName = 'Guest_Account_' + guestFieldIndex + '__c';
personAcctId = (String) booking.get(fieldName);
if(personAcctId != null) {
if(!mapGuestIdNewData.containsKey(personAcctId)) {
mapGuestIdNewData.put(personAcctId, new AccountDataHistory());
}
dataHistoryObject = mapGuestIdNewData.get(personAcctId);
nbrOfNights = booking.Min_Arrival__c.daysBetween(booking.Max_Departure__c);
if(actionType.equals(actionRemove)) {
nbrOfNights = 0;
}
AccountDataHistory.Night night;
for(Id bookingId : dataHistoryObject.mapBookingNight.keySet()) {
night = dataHistoryObject.mapBookingNight.get(bookingId);
if(booking.Id == night.bookingId) {
night.nbrNights = nbrOfNights;
isFound = true;
break;
}
} 
if(!isFound) {
dataHistoryObject.mapBookingNight.put(booking.Id, new AccountDataHistory.Night(Date.today().Year(), nbrOfNights, booking.Id));
}
mapGuestIdNewData.get(personAcctId).setTotalNights();
}
}
}
}

public static void doCalculateTotalRevenues(Opportunity booking, Map<Id, AccountDataHistory> mapGuestIdNewData, String actionType, Set<Integer> setGuestAccountFields) {
if(booking.Max_Departure__c != null && booking.Min_Arrival__c != null && booking.StageName == Label.StageChecked && booking.OnTheCurrentYear__c) {
String fieldName = null;
String personAcctId = null;
decimal bookingRevenue;
AccountDataHistory dataHistoryObject;
boolean isFound;
for(Integer guestFieldIndex : setGuestAccountFields) {
isFound = false;
fieldName = 'Guest_Account_' + guestFieldIndex + '__c';
personAcctId = (String) booking.get(fieldName);
if(personAcctId != null) {
if(!mapGuestIdNewData.containsKey(personAcctId)) {
mapGuestIdNewData.put(personAcctId, new AccountDataHistory());
}
dataHistoryObject = mapGuestIdNewData.get(personAcctId);
bookingRevenue = booking.Price__c;
if(actionType.equals(actionRemove)) {
bookingRevenue = 0;
}
AccountDataHistory.Revenue revenue;
for(Id bookingId : dataHistoryObject.mapBookingRevenue.keySet()) {
revenue = dataHistoryObject.mapBookingRevenue.get(bookingId);
if(booking.Id == revenue.bookingId) {
revenue.bookingRevenue = bookingRevenue;
isFound = true;
break;
}
}
if(!isFound) {
dataHistoryObject.mapBookingRevenue.put(booking.Id, new AccountDataHistory.Revenue(Date.today().Year(), bookingRevenue, booking.Id));
}
mapGuestIdNewData.get(personAcctId).setTotalNights();
}
}
}
}*/
    
    public static void doCalculateCountryPercentage(Opportunity booking, Map<Id, AccountDataHistory> mapGuestIdNewData, String actionType, String strOldHotelCountry, Set<Integer> setGuestAccountFields) {
        system.debug('@@@ ap05 new doCalculateCountryPercentage');
        String strHotelCountry = strOldHotelCountry == null ? booking.HotelCountry__c : strOldHotelCountry;
        if(String.isNotEmpty(strHotelCountry) && (booking.StageName.equalsIgnoreCase(Label.StageChecked) || booking.StageName.equalsIgnoreCase(Label.StageBooked) )) {
            setCountryCodes = new Set<String>{'FR', 'IT', 'DE' , 'ES' , 'PL' , 'others'};
                Integer counter = actionType.equals(actionAdd) ? 1 : -1;
            Integer countryCounter = 0;
            String fieldName = null;
            String personAcctId = null;
            if(!setCountryCodes.contains(strHotelCountry)) {
                strHotelCountry = 'others';
            }
            //for(Integer i : setGuestAccountFields) { 
            //   fieldName = 'Guest_Account_' + i + '__c';
            personAcctId = (String)booking.get('person_Account__c');
            if(personAcctId != null) {
                if(!mapGuestIdNewData.containsKey(personAcctId)) {
                    mapGuestIdNewData.put(personAcctId, new AccountDataHistory());
                }
                if(strHotelCountry.equals('FR')) {
                    system.debug('@@@ fr fr fr');
                    mapGuestIdNewData.get(personAcctId).countryPercentage.france += counter;
                }
                else if(strHotelCountry.equals('DE')) {
                    mapGuestIdNewData.get(personAcctId).countryPercentage.germany += counter;
                }
                else if(strHotelCountry.equals('IT')) {
                    mapGuestIdNewData.get(personAcctId).countryPercentage.italy += counter;
                }
                else if(strHotelCountry.equals('ES')) {
                    mapGuestIdNewData.get(personAcctId).countryPercentage.spain += counter;
                }
                else if(strHotelCountry.equals('PL')) {
                    mapGuestIdNewData.get(personAcctId).countryPercentage.poland += counter;
                }
                else if(strHotelCountry.equals('others')) {
                    mapGuestIdNewData.get(personAcctId).countryPercentage.others += counter;
                }
            }
            // }
        }
    }
}