/*
* Description: CRMSS-401
* @author: TMA-EIL JKA
* @date: 
* @Test: Batch_HotelCountChecked_Test || Batch_FirstLastBooking_Test
* @Coverage:100% || 83%
*/
public without sharing class  AP17_Opportunity {
    
    Public static void  FillOldPArent(List<Opportunity> listOPP, map<id,opportunity> mapOldOpp){
        
        for(opportunity opp : listOPP){
            
            if(opp.Booking_Person_account__c != mapOldOpp.get(opp.id).Booking_Person_account__c && mapOldOpp.get(opp.id).Booking_Person_account__c != null){
                
                opp.OldParentAccount__c = mapOldOpp.get(opp.id).Booking_Person_account__c;
            }
            
            if(opp.Person_Account__c != mapOldOpp.get(opp.id).Person_Account__c && mapOldOpp.get(opp.id).Person_Account__c != null){
                
                opp.OldParent__c = mapOldOpp.get(opp.id).Person_Account__c;
            }
        }
    }
    
}