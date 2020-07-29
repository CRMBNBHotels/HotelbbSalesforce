/*
* Update the total nights field on person account and business account based on the opportunity max departure and min arrival (Person account on stay object)
* @author: Jenny Jawhar
* @date: 01/12/2017
* @Test: AP02_Stay_Test
*/
public class AP02_Stay 
{
    public static void UpdateTotalNights(List<Stay__c> triggerNew,Map<Id,Stay__c> oldMap,List<Stay__c> triggerOld)
    {
        List<string> ListAccountId = new List<string>();
        List<string> ListCurrentCompanyId = new List<string>();       
        if(triggerNew != null)
        {
            for(Stay__c stay: triggerNew)
            {
                Stay__c oldStay=oldMap==null ? stay : oldMap.get(stay.Id);
                ListAccountId.add(stay.Guest_account__c);
                if(stay.BusinessAccountId__c != null){  
                    ListCurrentCompanyId.add(stay.BusinessAccountId__c);                                        
                }
                if(oldMap!=null && oldStay.Guest_Account__c!=stay.Guest_Account__c)
                {
                    ListAccountId.add(oldStay.Guest_Account__c);                     
                }
                if(oldMap!=null &&  oldStay.BusinessAccountId__c != stay.BusinessAccountId__c)
                {
                    ListCurrentCompanyId.add(oldStay.BusinessAccountId__c);
                }
            }
        }
        else
        {
            for(Stay__c stay:triggerOld)
            {
                if(stay.Max_Departure__c!=null && stay.Min_Arrival__c!=null)
                {
                    ListAccountId.add(stay.Guest_Account__c);
                    if(stay.BusinessAccountId__c!=null)
                    {
                        ListCurrentCompanyId.add(stay.BusinessAccountId__c);
                    }
                }
            }
        }
        //Remove duplicates in the two lists
        Set<string> setAccount = new Set<string>(ListAccountId);
        ListAccountId = new List<string>(setAccount);
        setAccount = new set<string>(ListCurrentCompanyId);
        ListCurrentCompanyId = new list<string>(setAccount);
        if(ListAccountId.Size() > 0)
        {           
            List<Account> ListAccToUpdate = new List<Account>();
            list<Account> listSelectedAccount= [Select Id,RecordTypeId,
                                                (select Id,Min_Arrival__c,Max_Departure__c 
                                                 from Stays__r
                                                 where StageName__c=:Label.StatusChecked And OnTheCurrentYear__c =: true
                                                 And Max_Departure__c != null And Min_Arrival__c != null)
                                                from Account
                                                where Id IN: ListAccountId];            
            ListAccToUpdate =  NightCountForPersonAccount(listSelectedAccount);        
            Update ListAccToUpdate;
        }
        if(ListCurrentCompanyId.Size()>0)
        {        
            List<Account> listAccToUpdate = new List<Account>();
            List<Stay__c> listStays = [Select Id, BusinessAccountId__c,Min_Arrival__c,Max_Departure__c
                                       from Stay__c
                                       where BusinessAccountId__c IN: ListCurrentCompanyId                  
                                       And StageName__c=:Label.StatusChecked And OnTheCurrentYear__c =: true
                                       And Max_Departure__c != null And Min_Arrival__c != null
                                       And Trip_Context__c =: Label.BusinessCustomerType];
            List<Account> listAccounts = [Select Id 
                                          from Account
                                          Where Id IN:ListCurrentCompanyId];
            listAccToUpdate = NightCountForBusinessAccount(listAccounts,listStays);
            Update listAccToUpdate;
        }        
    }
    public static List<Account> NightCountForPersonAccount(List<Account> listAccount)
    {
        List<Account> ListAccToUpdate = new List<Account>();
        integer countNight;
        for(Account acc: listAccount)
        {
            countNight = 0;
            List<Stay__c> listStay =acc.Stays__r;                
            for(Stay__c stay:listStay)
            {                            
                Integer numberDays = stay.Min_Arrival__c.daysBetween(stay.Max_Departure__c);
                countNight =  countNight + numberDays ;                                                                                                                                                                     
            }
            acc.Total_nights__pc = countNight;    
            ListAccToUpdate.add(acc);
        }
        return ListAccToUpdate;
    }
    public static List<Account> NightCountForBusinessAccount(List<Account> listAccount, list<Stay__c> listStay)
    {
        List<Account> listAccToUpdate = new List<Account>();
        integer countNight;
        for(Account acc:listAccount)
        {                                           
            countNight = 0;
            for(Stay__c stay: listStay)
            {
                if(stay.BusinessAccountId__c == acc.Id)
                {
                    Integer numberDays = stay.Min_Arrival__c.daysBetween(stay.Max_Departure__c);
                    countNight =  countNight + numberDays ;                         
                }
            }
            acc.Total_Nights__c = countNight;	
            listAccToUpdate.add(acc);
        }
        return listAccToUpdate;
    }
}