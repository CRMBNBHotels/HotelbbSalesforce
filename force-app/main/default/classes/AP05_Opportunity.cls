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
        String strTripContextOld; //Added by TMA-EIL CRMSS-579 15/04/2020 
        String bookingStatus;
        Opportunity oldBooking;
        for(Opportunity booking : listBookings) {
            if(booking.RecordTypeId != null && booking.RecordTypeId == booking_RT && (booking.Trip_Context__c != null || booking.HotelCountry__c != null)) { 
                system.debug('@@@ Trigger.isupdate' + trigger.isupdate);
                setUpdatedGuestFields.clear();
                setGuestAccountFields.clear();
                setGuestAccountFields = new Set<Integer> {};
            	setUpdatedGuestFields = new Set<Integer> {};

                if(!Trigger.isUpdate ) {//&& setGuestAccountFields.size() > 0
                    actionType = Trigger.isDelete ? actionRemove : actionAdd;

                } 
                else if(Trigger.isUpdate) {
                    oldBooking = mapOldBookings.get(booking.Id);

                }
            }
        } 
        system.debug('mapGuestNewData ' + mapGuestNewData);
        if(mapGuestNewData.size() > 0) {
            AP04_Account.doUpdateGuestFields(mapGuestNewData);
        }
    } 

    
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