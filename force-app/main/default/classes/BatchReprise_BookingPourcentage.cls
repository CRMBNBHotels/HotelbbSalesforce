global class BatchReprise_BookingPourcentage  implements Database.Batchable<sObject>, Database.Stateful{
    Global Map<Id,List<Id>> mapOppPAs = new Map<Id,List<Id>>();
    Global Map<Id, Map<String,Integer>> mapAccountCountryNumber = new Map<Id, Map<String,Integer>>();
    Global set<id> SetAccId = new set<id>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Label.BookingRecordTypeName).getRecordTypeId();
        String whereCond = '';
        if(!test.isRunningTest()){
            whereCond = ' where booking__r.RecordTypeId=\''+ recTypeId +'\' and (booking__r.StageName = \''+Label.StageBooked+'\' or booking__r.StageName=\''+Label.StageChecked+'\')';
           //(Guest_account__r.Booking_France__c = null or Guest_account__r.Booking_Germany__c = null or Guest_account__r.Booking_Italy__c = null or Guest_account__r.Booking_Poland__c = null or Guest_account__r.Booking_Spain__c = null or Guest_account__r.Booking_Others__c =null) and 
            /*whereCond = ' where Booking_France__c = null or Booking_Germany__c = null or Booking_Italy__c = null or Booking_Poland__c = null or Booking_Spain__c = null or Booking_Others__c =null';*/
        }
        //string query='select id, (select id,Booking__c,Guest_account__c from stays__r) from account'+whereCond;
        
        string query='select id,Booking__c,Guest_account__c from stay__c'+whereCond +' order by Guest_account__c';
        system.debug('query' + query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<stay__c> liststay)
    {
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Label.BookingRecordTypeName).getRecordTypeId();
        List <Id> lstAllOppOfPA = new List<Id>();
        Boolean isFirst = true;
        
        for(stay__c stay:liststay){
            if(isFirst){
                
                if(!SetAccId.contains(stay.Guest_account__c)){
                    SetAccId = new set<id>();
                    mapOppPAs = new Map<Id,List<Id>>();
                    mapAccountCountryNumber = new Map<Id, Map<String,Integer>>();
                }
                isFirst=false;
            }
            if(!mapOppPAs.containskey(stay.Booking__c)){
                List <Id> lstAccounts= new List<Id>();
                lstAccounts.add(stay.Guest_account__c);
                mapOppPAs.put(stay.Booking__c ,lstAccounts );
            } else{
                mapOppPAs.get(stay.Booking__c).add(stay.Guest_account__c);
            }
            lstAllOppOfPA.add(stay.Booking__c);
            SetAccId.add(stay.Guest_account__c);
            
        }
        system.debug('SetAccId' + SetAccId);
        
        
        
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
        
        
        system.debug('mapAccountCountryNumber' + mapAccountCountryNumber);
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
    global void finish(Database.BatchableContext BC)
    {
    }
}