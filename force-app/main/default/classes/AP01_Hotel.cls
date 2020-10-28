/*
* On insert,update and delete of a Hotel__c record, this trigger will update the fields booking france, booking germany etc..
* the trigger will calculate the percentage of hotel bookings per country and store the calculated values in the person account fields
* @author: Mohamad El Kebbi
* @date: 06/27/2018 
* @ Test: AP05_Opportunity_Test 91%
*/
public without sharing class AP01_Hotel { 
    
    public static void updateBookingsCountryPercentages(List<Hotel__c> listHotels, Map<Id, Hotel__c> mapOldHotels) {
    	
       String actionAdd = 'ADD';
       String actionRemove = 'REMOVE';
        
       Id booking_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId();
        
        // Get the hotels with country changed
        Set<Id> setHotelsToTreat = new Set<Id>();
        String country;
        String oldCountry;
        
        //Added by TMA-EIL CG MS-5094 15/09/2020 Start
        String lowerCountry;
        String lowerOldCountry;
        //Added by TMA-EIL CG MS-5094 15/09/2020 End
        
        Hotel__c oldHotel;
        
        for(Hotel__c hotel : listHotels) {
            
            oldHotel = mapOldHotels.get(hotel.Id);
            country  = hotel.Country__c == null ? '' : hotel.Country__c;
            oldCountry = oldHotel.Country__c == null ? '' : oldHotel.Country__c;
            
            //Added by TMA-EIL CG MS-5094 15/09/2020 Start
            lowerCountry = country.toLowercase();
            lowerOldCountry = oldCountry.toLowerCase();
            //Added by TMA-EIL CG MS-5094 15/09/2020 End
                
            if(lowerCountry != lowerOldCountry){//Condition modified by TMA-EIL CG MS-5094 15/09/2020
                
               setHotelsToTreat.add(hotel.Id); 
            }    
        }
        system.debug('### cg listHotels.size: '+listHotels.size());
        system.debug('### cg setHotelsToTreat.size: '+setHotelsToTreat.size());
        
        if(setHotelsToTreat.size() > 0) {
            
            Map<Id, AccountDataHistory> mapGuestIdDataHistory = new Map<Id, AccountDataHistory>();
            String strOldHotelCountry;
            
            // iterate over all bookings in the hotels to treat
            for(Opportunity booking : [SELECT Id,Hotel__c,HotelCountry__c, Guest_Account_1__c,Guest_Account_2__c,Guest_Account_3__c, Guest_Account_4__c, Guest_Account_5__c, StageName,Person_Account__c
                                       FROM Opportunity
                                       WHERE RecordTypeId = :booking_RT AND Hotel__c IN :setHotelsToTreat 
                                       AND (StageName =: Label.StageBooked OR StageName =: Label.StageChecked)
                                      ]) {
                                           if(booking.Hotel__c != null && booking.HotelCountry__c != null) {
                                               AP05_Opportunity.doCalculateCountryPercentage(booking, mapGuestIdDataHistory, actionAdd, null, new Set<Integer> {1,2,3,4,5});
                                           }
                                           oldHotel = mapOldHotels.get(booking.Hotel__c);
                                           strOldHotelCountry = oldHotel.Country__c;
                                           if(strOldHotelCountry != null) {
                                               AP05_Opportunity.doCalculateCountryPercentage(booking, mapGuestIdDataHistory, actionRemove, strOldHotelCountry, new Set<Integer> {1,2,3,4,5});
                                           }
                                       }
            AP04_Account.doUpdateGuestFields(mapGuestIdDataHistory);
            
        }
    }
    
}