/* Description : This class is used to filter / update records and call other classes
 * When a master booking opportunity is inserted,updated or created, the value of the Total_Transactions__pc on the person account it's related to is changed
* Test Class : public class MasterBookingHandlerTest 
*/
public class MasterBookingHandler {
    
    Public static void FilterOpportunity(List<Opportunity> listOpp, Map<Id,Opportunity> MapOppOld){
        
        Map<id,Account> mapAccountToTreat=new Map<id,Account>();
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        List<Opportunity> listMBCheckedToTreat = new List<Opportunity>();  
        
        
        //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - Start
        list<Opportunity> listMBwithDepartureDate = new list<Opportunity>();
        //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - End
        
        //Case of insert
        if(listOpp != null && listOpp.size()>0 && MapOppOld == null ){
            
            //CRMSS - 354 Start
            Set<id> setAccountIds=new Set<id>();
            
            for(Opportunity opp: listOpp){
                
                system.debug('### nta opp.RecordTypeId'+opp.RecordTypeId );
                system.debug('### nta masterBookingRTId'+masterBookingRTId);
                 system.debug('### nta opp.Person_Account__c'+opp.Person_Account__c);
                if(opp.RecordTypeId == masterBookingRTId && opp.Person_Account__c != null){
                    
                    
                   // if(opp.StageName == Label.StageNameBooking_Checked){
                   if(opp.Bookings_Checked_Count__c>0){
                        system.debug('### nta in insert');
                        listMBCheckedToTreat.add(opp);
                        setAccountIds.add(opp.Person_Account__c);
                    }
                    
                    //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - Start
                    if(opp.Departure_Date__c != null){
                        
                        listMBwithDepartureDate.add(opp);
                        setAccountIds.add(opp.Person_Account__c);
                    }
                    //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - End
                }
            }
            
            if(setAccountIds !=null && setAccountIds.size()>0){
                
                Map<id,account> mapAccountsToUpdate=new Map<id,Account>([Select id,Total_Transactions__pc,First_Booking_Date__c,Last_Booking_Date__c from account where id in :setAccountIds]);
                
                if(listMBCheckedToTreat !=null && listMBCheckedToTreat.size()>0){
                    
                    mapAccountToTreat = AP15_Opportunity.CalculateOnInsert(listMBCheckedToTreat,mapAccountsToUpdate);
                }
                
                //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - Start
                if(listMBwithDepartureDate != null && listMBwithDepartureDate.size()>0){
                    
                    mapAccountToTreat = AP16_Opportunity.updateFirstBookDate(listMBwithDepartureDate, mapAccountsToUpdate);
                }
                //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - End
            }
            
        }
        
        //Case of update
        if(listOpp != null && listOpp.size()>0 && MapOppOld != null && MapOppOld.size()>0 )
        {
            Set<id> setAccountIds=new Set<id>();
            
            for(Opportunity opp: listOpp){
                
                //if((opp.Person_Account__c!=MapOppOld.get(opp.id).Person_Account__c || opp.StageName!=MapOppOld.get(opp.id).StageName) && (opp.StageName == Label.StageNameBooking_Checked || MapOppOld.get(opp.id).StageName == Label.StageNameBooking_Checked) && opp.RecordTypeId == masterBookingRTId){
                //if((opp.Person_Account__c!=MapOppOld.get(opp.id).Person_Account__c ||  (opp.Bookings_Checked_Count__c!= MapOppOld.get(opp.id).Bookings_Checked_Count__c && opp.Bookings_Checked_Count__c>0 && MapOppOld.get(opp.id).Bookings_Checked_Count__c>0 ))   && opp.RecordTypeId == masterBookingRTId){
                if( opp.RecordTypeId == masterBookingRTId && ( (opp.Person_Account__c != MapOppOld.get(opp.id).Person_Account__c && opp.Bookings_Checked_Count__c > 0) ||  opp.Bookings_Checked_Count__c != MapOppOld.get(opp.id).Bookings_Checked_Count__c ) ){
                    
                    listMBCheckedToTreat.add(opp);
                    
                    if(opp.Person_Account__c != MapOppOld.get(opp.id).Person_Account__c){
                        
                        if(opp.Person_Account__c != null){
                            
                            setAccountIds.add(opp.Person_Account__c);
                        }
                        if(MapOppOld.get(opp.id).Person_Account__c != null){
                            
                            setAccountIds.add(MapOppOld.get(opp.id).Person_Account__c);
                        }
                    }
                    else{
                        
                        setAccountIds.add(opp.Person_Account__c);
                    }
                    
                }
                
                //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - Start
                if(opp.RecordTypeId == masterBookingRTId && opp.Person_Account__c != MapOppOld.get(opp.id).Person_Account__c && opp.Departure_Date__c != null){
                    
                    listMBwithDepartureDate.add(opp);
                        
                    if(opp.Person_Account__c != null){
                        
                        setAccountIds.add(opp.Person_Account__c);
                    }
                    
                }
                //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - End
            }
            
            if(setAccountIds != null && setAccountIds.size()>0){
                
                Map<id,account> mapAccountsToUpdate = new Map<id,Account>([Select id,Total_Transactions__pc,First_Booking_Date__c,Last_Booking_Date__c from account where id in :setAccountIds]);
                
                if(listMBCheckedToTreat !=null && listMBCheckedToTreat.size()>0){
                    
                    mapAccountToTreat = AP15_Opportunity.CalculateOnUpdate(listMBCheckedToTreat,MapOppOld,mapAccountsToUpdate);
                }
                
                //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - Start
                if(listMBwithDepartureDate !=null && listMBwithDepartureDate.size()>0){
                    
                    mapAccountToTreat = AP16_Opportunity.updateFirstBookDate(listMBwithDepartureDate,mapAccountsToUpdate);
                }
                //Added by TMA-EIL Cynthia Geagea CRMSS-352-353 - 18/11/2019 - End
            }
        }
        
        //Case of delete
        if(listOpp == null && MapOppOld != null && MapOppOld.size()>0 )
        {
            Set<id> setAccountIds=new Set<id>();
            
            for(Opportunity opp: MapOppOld.values()){
               // if(opp.StageName == Label.StageNameBooking_Checked && opp.RecordTypeId == masterBookingRTId && opp.Person_Account__c != null){
                if(opp.Bookings_Checked_Count__c>0 && opp.RecordTypeId == masterBookingRTId && opp.Person_Account__c != null){
                    
                    listMBCheckedToTreat.add(opp);
                    setAccountIds.add(opp.Person_Account__c);
                }
            }
            if(setAccountIds !=null && setAccountIds.size()>0){
                
                Map<id,account> mapAccountsToUpdate=new Map<id,Account>([Select id,Total_Transactions__pc from account where id in :setAccountIds]);
                
                if(listMBCheckedToTreat !=null && listMBCheckedToTreat.size()>0){
                    
                   mapAccountToTreat = AP15_Opportunity.CalculateOnDelete(listMBCheckedToTreat,mapAccountsToUpdate);
                    
                }
            }
        }
        if(mapAccountToTreat!=null && mapAccountToTreat.size()>0)
        {
            update mapAccountToTreat.values();
        }
        
    }
}