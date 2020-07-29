/*
* Update and delete stays or master bookings (Opportunity) that are related to the updated and deleted GuestAccount
* @author: Jenny Jawhar
* @date: 21/12/2017
* @Test: AP02_Account_Test
*/
public class AP02_Account 
{
    //when the field current_compagny__c is updated in the guest account,the fields total_nights__c, total_revenue__c and total_transactions__c should be recalculated on the old and new
    //current_compagny__c business account
    public static void UpdateStayOppWhenGuestAccountUpdate(list<Account> triggerNew, map<Id,Account> oldMap)
    {
        list<Account> listAccount = new list<Account>();
        for(Account acc: triggerNew)
        {
            if(acc.Current_Compagny__pc != oldMap.get(acc.Id).Current_Compagny__pc && acc.RecordTypeId == label.PersonAccountRecordTypeId)
            {
                listAccount.add(acc);
            }
        }
        if(listAccount.size() > 0)
        {
            list<Stay__c> listStayToUpdate = new list<Stay__c>();
            list<Opportunity> listOpportunityToUpdate = new list<Opportunity>();
            list<Account> listBusinessAccountToUpdate = new list<Account>();
            list<Id> listBusinessAccount = new list<Id>();
            //Get the Stays and the Opportunities related to the updated person Account
            list<Account> listAccountWithlistStayAndOpp = [Select Id,Current_Compagny__pc,
                                                           (Select Id ,BusinessAccountId__c,Guest_Account__c,Min_Arrival__c
                                                            From Stays__r),
                                                           (Select Id,recordTypeId,Person_Account__c,BusinessAccountId__c
                                                            From Opportunities__r
                                                            Where RecordTypeId =: label.MasterBookingRecordTypeId)
                                                           From Account
                                                           Where Id IN: listAccount];
            for(Account acc:listAccountWithlistStayAndOpp)
            {
                //Get the old Business accounts that have to be recalculated
                if(oldMap.get(acc.Id).Current_Compagny__pc != null)
                {
                    listBusinessAccount.add(oldMap.get(acc.Id).Current_Compagny__pc);
                }
                list<Stay__c> listStay = acc.Stays__r;
                list<Opportunity> listOpportunity = acc.Opportunities__r;
                if(listOpportunity.size() > 0)
                {
                    listOpportunityToUpdate.addAll(listOpportunity);
                }
                if(listStay.size() > 0)
                {
                    listStayToUpdate.addAll(listStay);
                }
            }
            
            list<Contact> listContact = new list<Contact>();
            list<Id> listPersonAccountId = new list<Id>();
            //Get the business account that have to be recalculated
            list<Account> listBusinessAccountWithStayAndOpp = [Select Id,
                                                               (Select Id,AccountId
                                                                From Contacts1__r
                                                                Where IsPersonAccount =: true)
                                                               From Account
                                                               Where Id IN: listBusinessAccount];
            if(listBusinessAccount.size() > 0)
            {
                for(Account acc: listBusinessAccountWithStayAndOpp)
                {
                    list<Contact> listGuestAccount = acc.Contacts1__r;
                    //If the business account has not guests accounts, update all fiels to zero
                    if(listGuestAccount.size() <= 0)
                    {
                        acc.Total_Nights__c = 0;
                        acc.Total_Revenue__c = 0;
                        acc.Total_Transactions__c = 0;
                        acc.MaxBookingMinArrival__c = null;
                        listBusinessAccountToUpdate.add(acc);
                    }
                    //else get the list of the remaining guest accounts
                    else
                    {
                        listContact.addall(acc.Contacts1__r);
                    }
                } 
                for(Contact con: listContact)
                {
                    listPersonAccountId.add(con.AccountId);
                }
                listAccountWithlistStayAndOpp = [Select Id,Current_Compagny__pc,
                                                 (Select Id,BusinessAccountId__c,Guest_Account__c,Min_Arrival__c
                                                  From Stays__r),
                                                 (Select Id,recordTypeId,Person_Account__c,BusinessAccountId__c
                                                  From Opportunities__r
                                                  Where RecordTypeId =: label.MasterBookingRecordTypeId)
                                                 From Account
                                                 Where Id IN: listPersonAccountId];
                //get the stays and master Bookings of these remaining guests accounts in order to recalculate the fields
                for(Account acc:listAccountWithlistStayAndOpp)
                { 
                    list<Stay__c> listStay = acc.Stays__r;
                    list<Opportunity> listOpportunity = acc.Opportunities__r;
                    if(listOpportunity.size() > 0)
                    {
                        listOpportunityToUpdate.addAll(listOpportunity);
                    }
                    if(listStay.size() > 0)
                    {
                        listStayToUpdate.addAll(listStay);
                    }
                }
            }
            
            //update all the lists
            //The methods are called one by one because the other methods in the AfterUpdateStay and AfterUpdateOpportunity trigger should not be called
            AP02_Stay.UpdateTotalNights(listStayToUpdate , null,null);
            AP03_Stay.UpdateTotalRevenue(listStayToUpdate , null,null);
            AP05_Stay.UpdateMaxBookingMinArrival(listStayToUpdate , null,null);
            AP04_Opportunity.UpdateTotalTransactions(listOpportunityToUpdate, null, null);
            update listBusinessAccountToUpdate;
        }
    }
    public static void getAccountOfStayWhenGuestAccountDelete(list<Account> triggerOld)
    {
        list<Account> listAccountWithlistStay = [Select Id,
                                                 (Select Id
                                                  From Stays__r)
                                                 From Account
                                                 Where Id IN: triggerOld
                                                 And recordTypeId =: label.PersonAccountRecordTypeId];
        list<Stay__c> listStayAffected = new list<Stay__c>();
        for(Account acc: listAccountWithlistStay)
        {
            list<Stay__c> listStay = acc.Stays__r;
            if(listStay.size() > 0)
            {
                listStayAffected.addAll(listStay);
            }
        }
        delete listStayAffected;
    }
    public static void updatePartnerShipFieldsWhenPartnerCodeChange(list<Account> triggerNew, map<Id,Account> oldMap)
    {
        list<String> listPartnerCode = new list<string>();
        for(Account acc:triggerNew)
        {
            if(acc.RecordTypeId != label.PersonAccountRecordTypeId && (oldMap==null || oldMap.get(acc.Id).Partner_Code__c != acc.Partner_Code__c))
            {
                if(!string.IsBlank(acc.Partner_Code__c))
                {
                    listPartnerCode.add(acc.Partner_Code__c);
                }
            }
        }
        if(listPartnerCode.size() > 0)
        {
            list<Opportunity> listBookingAffected = [Select Id,Partner_Code__c,recordTypeId
                                                     From Opportunity
                                                     Where Partner_Code__c IN: listPartnerCode];
            AP03_Opportunity.UpdateTotalNightsPartnerShip(listBookingAffected ,null, null);
            AP03_Opportunity.UpdateTotalRevenuePartnerShip(listBookingAffected ,null, null);
            AP03_Opportunity.UpdateTotalTransactionsPartnerShip(listBookingAffected,null,null);
        }
    }
}