/**
 * @author TMA-EI JK
 * @date 28/03/2019
 * @description fill the lookup Masterbooking_Person_account__c or Booking_Person_account__c depending on opp record type
 */
public without sharing class AP08_Opportunity {
   
    public static void fillBookingLookups(List<Opportunity> insertedOpps){
         system.debug('@@@@@ in AP08_Opportunity fillBookingLookups');
        for(Opportunity opp: insertedOpps){
            if(opp.Person_Account__c != null){
                if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.MasterBookingRTDevName).getRecordTypeId()){
                    opp.Masterbooking_Person_account__c = opp.Person_Account__c;
                }else if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.BookingRecordTypeName).getRecordTypeId()){
                    opp.Booking_Person_account__c = opp.Person_Account__c;
                }
            }
        }
    }
}