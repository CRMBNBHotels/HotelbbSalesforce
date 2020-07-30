/*
* Update the total transactions field on person account and business account based on the master booking opportunity 
* @author: Jenny Jawhar
* @date: 04/12/2017
* @Test: AP04_Opportunity_Test
*/
public class AP04_Opportunity 
{
    public static void UpdateTotalTransactions(List<Opportunity> triggerNew,Map<Id,Opportunity> oldMap,List<Opportunity> triggerOld)
    {
        system.debug('#### AP04_Opportunity Start');
        Set<Id> ListAccountId = new Set<Id>();
        Set<string> ListCurrentCompanyId = new Set<string>();       
        if(triggerNew != null)
        {
            for(Opportunity opp: triggerNew)
            {
                Opportunity oldOpp=oldMap==null ? opp : oldMap.get(opp.Id);
                if((oldMap==null || oldOpp.Person_Account__c != opp.Person_Account__c
                    || oldOpp.OnTheCurrentYear__c != opp.OnTheCurrentYear__c
                    || oldOpp.BusinessAccountId__c != opp.BusinessAccountId__c)
                   && (opp.recordTypeId == Label.MasterBookingRecordTypeId) && (opp.Person_Account__c!=null))
                {
                   if(String.isNotBlank(opp.Person_Account__c)) ListAccountId.add(opp.Person_Account__c); 
                   if(String.isNotBlank(opp.BusinessAccountId__c)) ListCurrentCompanyId.add(opp.BusinessAccountId__c);                                        
                }
                if((opp.RecordTypeId == label.BookingRecordTypeId) && (opp.Master_Booking_FK__c != null)
                   && (oldMap == null || oldOpp.Trip_Context__c != opp.Trip_Context__c || oldOpp.Master_Booking_FK__c != opp.Master_Booking_FK__c))
                {
                   if(String.isNotBlank(opp.MasterBookingPersonAccount__c)) ListAccountId.add(opp.MasterBookingPersonAccount__c);
                   if(String.isNotBlank(opp.MasterBookingBusinessAccount__c))  ListCurrentCompanyId.add(opp.MasterBookingBusinessAccount__c);
                }
                if(oldMap!=null && oldOpp.Person_Account__c!=opp.Person_Account__c)
                {
                  if(String.isNotBlank(oldOpp.Person_Account__c))  ListAccountId.add(oldOpp.Person_Account__c);                     
                }
                if(oldMap!=null &&  oldOpp.BusinessAccountId__c != opp.BusinessAccountID__c)
                {
                    if(String.isNotBlank(oldOpp.BusinessAccountId__c))  ListCurrentCompanyId.add(oldOpp.BusinessAccountId__c);
                }
            }
        }
        else
        {
            for(Opportunity opp:triggerOld)
            {
                if(opp.RecordTypeId == Label.MasterBookingRecordTypeId && opp.Person_Account__c!=null)
                {
                    ListAccountId.add(opp.Person_Account__c);
                    if(opp.BusinessAccountId__c!=null)
                    {
                      if(String.isNotBlank(opp.BusinessAccountId__c))  ListCurrentCompanyId.add(opp.BusinessAccountId__c);
                    }
                }
                if(opp.RecordTypeId == label.BookingRecordTypeId && opp.Master_Booking_FK__c != null && !string.IsBlank(opp.Trip_Context__c)
                   && (opp.Trip_Context__c).equalsIgnoreCase(Label.BusinessCustomerType))
                {
                     if(String.isNotBlank(opp.MasterBookingPersonAccount__c))  ListAccountId.add(opp.MasterBookingPersonAccount__c);
                    if(String.isNotBlank(opp.MasterBookingBusinessAccount__c))   ListCurrentCompanyId.add(opp.MasterBookingBusinessAccount__c);                
                }
            }
        }
        if(ListAccountId.Size() > 0)
        {
            list<Account> listAccToUpdate = new list<Account>();
            list<AggregateResult> CountOpportunityBYAccount = [Select Person_Account__c,count(id) countdata 
                                                               from Opportunity
                                                               where RecordTypeId =: Label.MasterBookingRecordTypeId
                                                               And OnTheCurrentYear__c =: true 
                                                               and  Person_Account__c IN: ListAccountId 
                                                               group by Person_Account__c];
            //and Person_Account__c != null
            for (AggregateResult ar : CountOpportunityBYAccount)  {
                if(ar.get('Person_Account__c')!= null  && String.isNotBlank(ar.get('Person_Account__c').tostring())){
                    Account toupdate = new Account();
                    toupdate.id = ar.get('Person_Account__c').tostring();
                    system.debug('$$$$ (Integer)ar.get(' + (Integer)ar.get('countdata'));
                    toupdate.Total_Transactions__pc = (Integer)ar.get('countdata') ; 
                    system.debug('$$$$ toupdate' + toupdate);
                    listAccToUpdate.add(toupdate);   
                } 
            }
            if(listAccToUpdate != null && listAccToUpdate.size()>0)
                Update listAccToUpdate; 
        }
        
       if(ListCurrentCompanyId!= null && ListCurrentCompanyId.Size() > 0)
        {
            List<Account> listAccToUpdate = new List<Account>();
            List<Opportunity> listOpportunities = [Select Trip_context__c,Master_Booking_FK__r.BusinessAccountId__c,Master_Booking_FK__r.RecordTypeId, Master_Booking_FK__r.OnTheCurrentYear__c ,Master_Booking_FK__c
                                                   From Opportunity  
                                                   where Trip_Context__c = :label.BusinessCustomerType and Master_Booking_FK__c != null and Master_Booking_FK__r.BusinessAccountId__c IN :ListCurrentCompanyId and Master_Booking_FK__r.RecordTypeId =:Label.MasterBookingRecordTypeId and 
												   Master_Booking_FK__r.OnTheCurrentYear__c =: true];
            system.debug('#### AP04_Opportunity listOpportunities' + listOpportunities);
            //Get only the master bookings that have at least one Booking with trip_Context__c = Business
            Map<Id,Id> mapOppBA = new Map<Id,Id>();
            for(Opportunity booking : listOpportunities )
			{
				if(booking.Trip_Context__c == label.BusinessCustomerType)
                {
					if(!mapOppBA.containsKey(booking.Master_Booking_FK__c))
						mapOppBA.put(booking.Master_Booking_FK__c,booking.Master_Booking_FK__r.BusinessAccountId__c);
                } 
			} 
			 
            integer countMBOpportunity;
            for(String acc:ListCurrentCompanyId)
			{
				countMBOpportunity = 0;
                for(Id oppID: mapOppBA.keyset())
                {
					if(mapOppBA.get(oppID) == acc ){
						countMBOpportunity ++;
					}
				}
                
                if(String.isNotBlank(acc))
                {
                    Account tempacc= new account();
                    tempacc.id=acc;
                    tempacc.Total_Transactions__c = countMBOpportunity;	
                    listAccToUpdate.add(tempacc); 
                    System.debug('&&&&&&&&' + tempacc);
                }
                
			}
			if(listAccToUpdate != null && listAccToUpdate.size()>0)
				update listAccToUpdate;
        }
    }
}