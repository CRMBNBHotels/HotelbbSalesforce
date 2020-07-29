/*
* Description: CRMSS-352 Class to update the field First_Booking_Date__c on PA based on its first MasterBooking's departure date 
               CRMSS-353 Class to update the field Last_Booking_Date__c on a PA based on its last MasterBooking's departure date
* @author: TMA-EIL Cynthia Geagea
* @date: 15/11/2019
* @Test class: AP16_Opportunity_Test 
* @Coverage:  100 %
*/

public without sharing class AP16_Opportunity {
    
    //If a master booking is inserted with a departure date and is attached to a PA, or it has uts PA updated, we fill the first booking date on the PA with this departure date in case it was null, i.e. we fill it with the first MB's departure date

    public static map<Id, Account> updateFirstBookDate(list<Opportunity> newListOpp, map<Id, Account> mapAccountsToUpdate){
        
        for(Opportunity opp : newListOpp){
            
            if(opp.Person_Account__c != null && mapAccountsToUpdate.containsKey(opp.Person_Account__c)){
                
                Account parentAcc = mapAccountsToUpdate.get(opp.Person_Account__c);
                
                //CRMSS - 352
                if(parentAcc.First_Booking_Date__c == null){
                    
                    parentAcc.First_Booking_Date__c = opp.Departure_Date__c;
                }
                
                //CRMSS - 353
                parentAcc.Last_Booking_Date__c = opp.Departure_Date__c;
            }
        }
        
        return mapAccountsToUpdate;  
    }
}