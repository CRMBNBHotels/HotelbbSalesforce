/*
* On insert,update and delete of a Stay__c record, this trigger will update the fields booking france, booking germany etc..
* the trigger will calculate the percentage of hotel bookings per country and store the calculated values in the person account fields
* @author: Mohamad El Kebbi
* @date: 06/27/2018 
* @ Test: AP05_Opportunity_Test 90%
*/
public class AP07_Stay {
    
    public static void UpdateCountryPercentages(list<Stay__c> triggerNew, map<Id, Stay__c> oldMap, list<Stay__c> triggerOld)
    {
         if(UserInfo.getUserId().contains('0050Y000000gQke')){  return;  }
        
        List<id>lstDeletedOPP = new List<Id>();
        List<id> lstDeleteStays = new List<Id>();
        List <id> lstPAIds = new List<Id>();
        List <Id> lstAllOppOfPA = new List<Id>();
        Map<Id,Id> mapOppStay = new Map<id,Id>();
        Map<Id,Id> mapStayAcc = new Map<id,Id>();
        Map<Id, Map<String,Integer>> mapAccountCountryNumber = new Map<Id, Map<String,Integer>>();
        Date myDate = date.newInstance(System.Today().year(), 1, 1);
        Date myDate2 = date.newInstance(System.Today().year()+1, 1, 1);
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Label.BookingRecordTypeName).getRecordTypeId();
        map<Id,list<Stay__c>> mapAccountStays = new  map<Id,list<Stay__c>>();
        
        Map<Id,List<Id>> mapOppPAs = new Map<Id,List<Id>>();
        
        if(triggerNew != null)
        {
            for(Stay__c stay: triggerNew){
              if(String.isNotBlank(stay.Guest_account__c))  lstPAIds.add(stay.Guest_account__c);
                //lstStaysIds.add(stay.Id);
            }
        }
        
        else if(triggerOld != null)
        { 
            for(Stay__c stay: triggerOld){
               if(String.isNotBlank(stay.Guest_account__c)) lstPAIds.add(stay.Guest_account__c);
            }
        }  
        
        if(lstPAIds.Size() >0){
           // List<Stay__c> lstAllStaysOfPA = [SELECT id,Booking__c,Guest_account__c FROM Stay__c where Guest_account__c IN : lstPAIds];
            MAp<Id,Account> mapAccount = new Map<Id,Account>([select id, (select id,Booking__c,Guest_account__c from stays__r where Booking__c != null and Guest_account__c != null ) from account Where Id in :lstPAIds]);

            for(Id accId : mapAccount.keyset()){
                List<Stay__c> lstAllStaysOfPA =mapAccount.get(accId).stays__r;
                if(lstAllStaysOfPA.size() >0){
                    for(Stay__c stay : mapAccount.get(accId).stays__r){
                        if(!mapOppPAs.containskey(stay.Booking__c)){
                            List <Id> lstAccounts= new List<Id>();
                            lstAccounts.add(stay.Guest_account__c);
                            mapOppPAs.put(stay.Booking__c ,lstAccounts );
                        } else{
                            mapOppPAs.get(stay.Booking__c).add(stay.Guest_account__c);
                        }
                        lstAllOppOfPA.add(stay.Booking__c);
                    }
                }
                else{
                     Map<String,Integer> mapCountryNumber = new Map<String,Integer>();
                            mapCountryNumber.put('FR', 0);
                            mapCountryNumber.put('DE', 0);
                            mapCountryNumber.put('IT', 0);
                            mapCountryNumber.put('ES', 0);
                            mapCountryNumber.put('PL', 0);
                            mapCountryNumber.put('others', 0);
                   mapAccountCountryNumber.put(accId, mapCountryNumber); 
                }
             
            }
			            
            
            
            List<Opportunity> lstAllOpp = [SELECT id,HotelCountry__c, Name , StageName,Min_Arrival__c,RecordTypeId
                                           FROM Opportunity
                                           WHERE id IN : lstAllOppOfPA
                                           AND  RecordTypeId =:recTypeId 
                                           AND  (StageName =: Label.StageBooked
                                                 OR StageName =: Label.StageChecked) ]; 
            if(!lstAllOpp.isEmpty()){
                for(Opportunity opp: lstAllOpp){
                    System.debug('inside the for loop opp : ' + opp);
                    for(Id accountId: mapOppPAs.get(opp.id)){
                        if(!mapAccountCountryNumber.containskey(accountId)){
                            Map<String,Integer> mapCountryNumber = new Map<String,Integer>();
                            mapCountryNumber.put('FR', 0);
                            mapCountryNumber.put('DE', 0);
                            mapCountryNumber.put('IT', 0);
                            mapCountryNumber.put('ES', 0);
                            mapCountryNumber.put('PL', 0);
                            mapCountryNumber.put('others', 0);
                            if(mapCountryNumber.containskey(opp.HotelCountry__c)){
                                mapCountryNumber.put((opp.HotelCountry__c) , mapCountryNumber.get(opp.HotelCountry__c) + 1);
                            }else{
                                if(!String.isBlank(opp.HotelCountry__c)){
                                    mapCountryNumber.put('others' , mapCountryNumber.get('others') + 1);   
                                }
                            }
                            mapAccountCountryNumber.put(accountId, mapCountryNumber);
                        } else{
                            Map<String,Integer> mapCountryNumber = mapAccountCountryNumber.get(accountId);
                            if(mapCountryNumber.containskey(opp.HotelCountry__c)){
                                mapAccountCountryNumber.get(accountId).put((opp.HotelCountry__c) , mapCountryNumber.get(opp.HotelCountry__c) + 1);
                            }else{
                                if(!String.isBlank(opp.HotelCountry__c)){
                                    mapCountryNumber.put('others' , mapCountryNumber.get('others') + 1); 
                                }
                            }  
                        } 
                    }  
                }   
            }
            
            System.debug('mapAccountCountryNumber : ' + mapAccountCountryNumber);
            
            
            list<Account> listAccToUpdate = new list<Account>(); 
            for(Id accId: mapAccountCountryNumber.keyset()){
                Account acc = new Account(Id = accId);
                acc.Booking_France__c = 0;
                acc.Booking_Spain__c =  0;
                acc.Booking_Others__c = 0;
                acc.Booking_Germany__c = 0;
                acc.Booking_Italy__c = 0;
                acc.Booking_Poland__c = 0;
                if(mapAccountCountryNumber.containsKey(accId)){
                    double fr = mapAccountCountryNumber.get(acc.id).get('FR'); 
                    double es = mapAccountCountryNumber.get(acc.id).get('ES'); 
                    double oth = mapAccountCountryNumber.get(acc.id).get('others'); 
                    double de = mapAccountCountryNumber.get(acc.id).get('DE'); 
                    double it= mapAccountCountryNumber.get(acc.id).get('IT'); 
                    double pl = mapAccountCountryNumber.get(acc.id).get('PL');
                    double sum = fr + es + oth + de + it + pl ;
                    if(sum>0){
                        acc.Booking_France__c = fr*100/sum;
                        acc.Booking_Spain__c = es*100/sum;
                        acc.Booking_Others__c = oth*100/sum;
                        acc.Booking_Germany__c = de*100/sum;
                        acc.Booking_Italy__c = it*100/sum;
                        acc.Booking_Poland__c = pl*100/sum; 
                    } if(sum==0){
                         acc.Booking_France__c = 0;
                        acc.Booking_Spain__c = 0;
                        acc.Booking_Others__c = 0;
                        acc.Booking_Germany__c = 0;
                        acc.Booking_Italy__c = 0;
                        acc.Booking_Poland__c = 0; 
                    }
                } 
                listAccToUpdate.add(acc); 
            }
            Update listAccToUpdate;  
        }
        
    }
}