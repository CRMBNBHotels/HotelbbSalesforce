/*
* Update and delete stays that are related to the updated and deleted opportunity
* @author: Jenny Jawhar
* @date: 01/12/2017
* @Test: AP02_Opportunity_Test
*/
public class AP02_Opportunity {
    public static void UpdateStayWhenBookingUpdate(Map<id,Opportunity> triggerNew, Map<Id,Opportunity> oldMap){
        System.debug('##### AP02_Opportunity Start');
        list<Opportunity> listOpportunity = new list<Opportunity>();
        for(Opportunity opp: triggerNew.values()){
            Opportunity oldOpp=oldMap==null ? opp : oldMap.get(opp.Id);
            if(opp.Trip_Context__c != oldOpp.Trip_Context__c || opp.Min_Arrival__c != oldOpp.Min_Arrival__c 
               || opp.Max_Departure__c != oldOpp.Max_Departure__c || opp.StageName != oldOpp.StageName || opp.Hotel__c != oldOpp.Hotel__c
               || opp.Price__c != oldOpp.Price__c || opp.LastModifiedDateInBookingRoomLine__c != oldOpp.LastModifiedDateInBookingRoomLine__c
               || opp.NumberOfBookingRoomLine__c != oldOpp.NumberOfBookingRoomLine__c){
                   listOpportunity.add(opp);
               }
        }
        if(listOpportunity.size() > 0){
            //removed ticket 88
            /*list<Opportunity> listOpportunityWithlistStay = [Select Id,Trip_Context__c,Min_Arrival__c,Max_Departure__c,StageName,Hotel__c,Price__c,
															   NumberOfBookingRoomLine__c,LastModifiedDateInBookingRoomLine__c,
															  (Select Id,Guest_Account__c,BusinessAccountId__c,Min_Arrival__c
															   From Stays__r)
															   From Opportunity
															   Where Id IN: listOpportunity
															   And recordTypeId =: label.BookingRecordTypeId];*/
            List<Stay__c> listStays = [Select Id,Guest_Account__c,BusinessAccountId__c,Min_Arrival__c,Booking__c,Booking__r.recordTypeId
                                       From Stay__c 
                                       where Booking__c in :listOpportunity and Booking__r.recordTypeId =: label.BookingRecordTypeId ];
            list<Stay__c> listStayToUpdateCustomerType = new list<Stay__c>();
            list<Stay__c> listStayToUpdateTotalNights = new list<Stay__c>();
            list<Stay__c> listStayToUpdateTotalRevenue = new list<Stay__c>();
            list<Stay__c> listStayToUpdateFavoriteHotel = new list<Stay__c>();
            list<Stay__c> listStayToUpdateMaxBookingMinArrival = new list<Stay__c>();
            list<Stay__c> listStayToUpdateFavorites = new list<Stay__c>();
            //Modified ticket 88 
            for(Stay__c stay: listStays){
                Opportunity oldOpp;
                Opportunity opp;
                if(triggerNew != null && triggerNew.containsKey(stay.Booking__c)){
                    opp = triggerNew.get(stay.Booking__c);
                    oldOpp = opp;
                }
                if(oldMap != null && oldMap.containsKey(stay.Booking__c)){
                    oldOpp =  oldMap.get(stay.Booking__c);
                } 
                if(opp != null ){
                    if(opp.Trip_Context__c != oldOpp.Trip_Context__c){
                        listStayToUpdateCustomerType.add(stay);
                    }
                    if(opp.Trip_Context__c != oldOpp.Trip_Context__c || opp.Min_Arrival__c != oldOpp.Min_Arrival__c 
                       || opp.Max_Departure__c != oldOpp.Max_Departure__c || opp.StageName != oldOpp.StageName){
                           listStayToUpdateTotalNights.add(stay);
                       }
                    if(opp.Trip_Context__c != oldOpp.Trip_Context__c || opp.Min_Arrival__c != oldOpp.Min_Arrival__c 
                       || opp.StageName != oldOpp.StageName || opp.Price__c != oldOpp.Price__c ){
                           listStayToUpdateTotalRevenue.add(stay);
                       } 
                    if(opp.Hotel__c != oldOpp.Hotel__c){
                        listStayToUpdateFavoriteHotel.add(stay);
                    }
                    if(opp.Min_Arrival__c != oldOpp.Min_Arrival__c){
                        listStayToUpdateMaxBookingMinArrival.add(stay);
                    }
                    if(opp.LastModifiedDateInBookingRoomLine__c != oldOpp.LastModifiedDateInBookingRoomLine__c
                       || opp.NumberOfBookingRoomLine__c != oldOpp.NumberOfBookingRoomLine__c){
                           listStayToUpdateFavorites.add(stay);
                       }
                    
                }
                
            }
            //end Modified ticket 88 
            //removed ticket 88
            /*for(Opportunity opp: listOpportunityWithlistStay){
                list<Stay__c> listStay = opp.Stays__r;
                Opportunity oldOpp=oldMap==null ? opp : oldMap.get(opp.Id);
                if(opp.Trip_Context__c != oldOpp.Trip_Context__c){
                    listStayToUpdateCustomerType.addAll(listStay);
                }
                if(opp.Trip_Context__c != oldOpp.Trip_Context__c || opp.Min_Arrival__c != oldOpp.Min_Arrival__c 
                   || opp.Max_Departure__c != oldOpp.Max_Departure__c || opp.StageName != oldOpp.StageName){
                       listStayToUpdateTotalNights.addAll(listStay);
                   }
                if(opp.Trip_Context__c != oldOpp.Trip_Context__c || opp.Min_Arrival__c != oldOpp.Min_Arrival__c 
                   || opp.StageName != oldOpp.StageName || opp.Price__c != oldOpp.Price__c ){
                       listStayToUpdateTotalRevenue.addAll(listStay);
                   }
                if(opp.Hotel__c != oldOpp.Hotel__c){
                    listStayToUpdateFavoriteHotel.addAll(listStay);
                }
                if(opp.Min_Arrival__c != oldOpp.Min_Arrival__c){
                    listStayToUpdateMaxBookingMinArrival.addAll(listStay);
                }
                if(opp.LastModifiedDateInBookingRoomLine__c != oldOpp.LastModifiedDateInBookingRoomLine__c
                   || opp.NumberOfBookingRoomLine__c != oldOpp.NumberOfBookingRoomLine__c){
                       listStayToUpdateFavorites.addAll(listStay);
                   }
            }*/
            //The methods are called one by one in order not to do all the calculations when it's not necessary 
            AP01_Stay.UpdateTypeAccount(listStayToUpdateCustomerType , null,null);
            AP02_Stay.UpdateTotalNights(listStayToUpdateTotalNights, null,null);
            AP03_Stay.UpdateTotalRevenue(listStayToUpdateTotalRevenue,null, null);
            AP04_Stay.UpdateFavoriteHotel(listStayToUpdateFavoriteHotel,null, null);
            AP05_Stay.UpdateMaxBookingMinArrival(listStayToUpdateMaxBookingMinArrival , null,null);
            AP06_Stay.calculateFavorites(listStayToUpdateFavorites,null, null);
        }
    }
    public static void getAccountOfStayWhenBookingDelete(list<Opportunity> triggerOld){
        list<Opportunity> listOpportunityWithlistStay = [Select Id,
                                                         (Select Id
                                                          From Stays__r)
                                                         From Opportunity
                                                         Where Id IN: triggerOld
                                                         And recordTypeId =: label.BookingRecordTypeId];
        System.debug('##### AP02_Opportunity listOpportunityWithlistStay F:getAccountOfStayWhenBookingDelete ' + listOpportunityWithlistStay);
        list<Stay__c> listStayAffected = new list<Stay__c>();
        for(Opportunity opp: listOpportunityWithlistStay){
            list<Stay__c> listStay = opp.Stays__r;
            if(listStay.size() > 0){
                listStayAffected.addAll(listStay);
            }
        }
        delete listStayAffected;
    }
}