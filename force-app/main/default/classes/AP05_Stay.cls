/*
* Get the maximum date of Min_Arrival__c on opportunity with record type booking and put it in the technical custom field MaxBookingMinArrival__c on account
* @author: Jenny Jawhar
* @date: 13/11/2017
* @Test: AP05_Stay_Test
*/
public class AP05_Stay 
{
    public static void UpdateMaxBookingMinArrival(list<Stay__c> triggerNew, Map<Id,Stay__c> oldMap, List<Stay__c> triggerOld)
    {
        list<string> listAccountId = new list<string>();     
        list<string> listPersonAccount = new list<string>();
        if(triggerNew != null)
        {
            for(Stay__c stay: triggerNew)
            {
                Stay__c oldStay=oldMap==null ? stay : oldMap.get(stay.Id);
                if(stay.Min_Arrival__c != null)
                {
                    listPersonAccount.add(stay.Guest_account__c);
                    if(stay.BusinessAccountId__c!=null)
                    {
                        listAccountId.add(stay.BusinessAccountId__c);                       
                    }
                    if(oldMap != null && oldStay.Guest_account__c != stay.Guest_account__c)
                    {
                        listPersonAccount.add(oldStay.Guest_account__c);
                    }
                    if(oldMap!=null && oldStay.BusinessAccountId__c!=stay.BusinessAccountId__c )
                    {
                        listAccountId.add(oldStay.BusinessAccountId__c);                     
                    }
                }                
            }
        }
        else
        {
            for(Stay__c stay:triggerOld)
            {
                if(stay.Min_Arrival__c!=null)
                {
                    listPersonAccount.add(stay.Guest_account__c);
                    if(stay.BusinessAccountId__c!=null)
                    {
                        listAccountId.add(stay.BusinessAccountId__c);                    
                    }
                }   
            }
        }
        if(listPersonAccount.size() > 0)
        {
            List<Account> ListAccToUpdate = new List<Account>();
            list<Account> listSelectedAccount= [Select Id,MaxBookingMinArrival__c,
                                                (select Id,Min_Arrival__c
                                                 from Stays__r
                                                 where Min_Arrival__c != null
                                                 Order by Min_Arrival__c desc)
                                                from Account
                                                where Id IN: listPersonAccount];   
            for(Account acc : listSelectedAccount)
            {
                list<Stay__c> listStay = acc.Stays__r;
                if(listStay.size() > 0)
                {
                    acc.MaxBookingMinArrival__c = listStay[0].Min_Arrival__c;
                }
                else
                {
                    acc.MaxBookingMinArrival__c  = null;
                }
                ListAccToUpdate.add(acc);
            }
            update ListAccToUpdate;
        }
        if(listAccountId.size() > 0)
        {           
            List<Account> listAccToUpdate = new List<Account>();
            List<Stay__c> listStays = [Select Id, BusinessAccountId__c,Min_Arrival__c
                                       From Stay__c
                                       where BusinessAccountId__c IN: listAccountId
                                       And Min_Arrival__c != null];
            list<Account> listAccount = [Select Id, MaxBookingMinArrival__c
                                         From Account
                                         Where Id IN:listAccountId];
            for(Account acc: listAccount)
            {
                Date minArrDate;
                for(Stay__c stay: listStays)
                {
                    if(stay.BusinessAccountId__c == acc.Id)
                    {                       
                        if(stay.Min_Arrival__c > minArrDate || minArrDate==null)
                        {  
                            minArrDate = stay.Min_Arrival__c; 
                        }
                    }
                }
                acc.MaxBookingMinArrival__c = minArrDate;
                listAccToUpdate.add(acc);
            }
            update listAccToUpdate;
        }
    }    
}