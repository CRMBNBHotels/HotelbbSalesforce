/*
* Update the total revenue field on person account and business account based on the booking room lines prices of the booking opportunities
* @author: Jenny Jawhar
* @date: 05/12/2017
* @Test: AP03_Stay_Test
*/
public class AP03_Stay {
    //public static void UpdateTotalRevenue(List<Stay__c> triggerNew,Map<Id,Stay__c> oldMap,List<Stay__c> triggerOld)
    //{
      /*  System.debug('##### AP03_Stay Start');
        List<Id> ListAccountId = new List<Id>();
        List<string> ListCurrentCompanyId = new List<string>();       
        if(triggerNew != null)
        {
            for(Stay__c stay: triggerNew)
            {
                Stay__c oldStay=oldMap==null ? stay : oldMap.get(stay.Id);
                ListAccountId.add(stay.Guest_account__c); 
                if(stay.BusinessAccountId__c != null)
                { 
                    ListCurrentCompanyId.add(stay.BusinessAccountId__c);                                        
                }
                if(oldMap!=null && oldStay.Guest_account__c!=stay.Guest_account__c)
                {
                    ListAccountId.add(oldStay.Guest_account__c);                     
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
                if(stay.Price__c!= null)
                {
                    ListAccountId.add(stay.Guest_account__c);
                    if(stay.BusinessAccountId__c!=null)
                    {
                        ListCurrentCompanyId.add(stay.BusinessAccountId__c);
                    }
                }
            }
        }
        if(listAccountId.Size() > 0)
        {
            list<Account> listAccToUpdate = new List<Account>();
            list<Account> listSelectedAccount= [Select Id,
                                                (select Id,Price__c,BusinessAccountId__c 
                                                 from Stays__r
                                                 where OnTheCurrentYear__c =: true
                                                 And Price__c != 0)
                                                from Account
                                                where Id IN: ListAccountId];  
            System.debug('##### AP03_Stay listSelectedAccount' + listSelectedAccount);
            listAccToUpdate =  RevenueCountForPersonAccount(listSelectedAccount);        
            Update listAccToUpdate;
        }
        if(ListCurrentCompanyId.Size() > 0)
        {
            List<Account> listAccToUpdate = new List<Account>();
            List<Stay__c> listStays = [Select Id, Price__c,BusinessAccountId__c
                                       from Stay__c
                                       where BusinessAccountId__c IN: ListCurrentCompanyId
                                       And OnTheCurrentYear__c =: true
                                       And Price__c != 0
                                       And Trip_Context__c =: label.BusinessCustomerType];
            System.debug('##### AP03_Stay listStays' + listStays);
            List<Account> listAccounts = [Select Id 
                                          from Account
                                          Where Id IN:ListCurrentCompanyId];
            System.debug('##### AP03_Stay listAccounts' + listAccounts);
            listAccToUpdate = PriceCountForBusinessAccount(listAccounts,listStays);
            Update listAccToUpdate;
        }*/
    //}
    /*
    public static list<Account> RevenueCountForPersonAccount(list<Account> listAccount)
    {
        list<Account> listAccToUpdate = new List<Account>();
       /* decimal price;
        for(Account acc: listAccount)
        {
            price = 0;
            list<Stay__c> listStay =acc.Stays__r;                
            for(Stay__c stay:listStay)
            {
                price += stay.Price__c;
            } 
            acc.Total_Revenue__pc = price;
            listAccToUpdate.add(acc);
        }
        return listAccToUpdate;
    }
    public static list<Account> PriceCountForBusinessAccount(list<Account> listAccount, list<Stay__c> listStay)
    {
        list<Account> listAccToUpdate = new List<Account>();
        /*        decimal price;
        for(Account acc:listAccount)
        {                                           
            price = 0;
            for(Stay__c stay: listStay)
            {
                if(stay.BusinessAccountId__c == acc.Id)
                {
                    price += stay.Price__c;                        
                }
            }
            acc.Total_Revenue__c = price;	
            listAccToUpdate.add(acc);
        } 
        return listAccToUpdate;
    }*/
}