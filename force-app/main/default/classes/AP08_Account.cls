/*
* Description: Class to check status of account
* @author: TMA-EI PG
* @date: 09/09/2019
* @Test class: AP08_Account_Test
* @Coverage: 
*/

public without sharing class AP08_Account {
    
    public static void checkEClubStatus(List<Account> listAcc,map<Id,Account> mapOldAcc)
    {
        system.debug('@@@ checkEClubStatus');
        if(listAcc.size()>0)
        {
            Id recordTypeIdGuestAccount =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            if(mapOldAcc==null)
            {
                for(Account acc : listAcc)
                {
                    if(acc.E_club_Expiration_date__pc!=null && acc.E_Club_Status__c==null && acc.RecordTypeId==recordTypeIdGuestAccount)
                    {
                        acc.E_Club_Status__c='Valid';
                    }
                }
            }
            else
            {
                for(Account acc : listAcc)
                {
                    //TMA PG 12-9-2019 276 Start
                    /*if((mapOldAcc.get(acc.Id)).E_club_Expiration_date__pc==null && acc.E_club_Expiration_date__pc!=null && acc.E_Club_Status__c==null && acc.RecordTypeId==recordTypeIdGuestAccount){
                        acc.E_Club_Status__c='Valid';
                      }*/
                    
                    //Added by TMA Cynthia Geagea - CRMSS 270-271 - 19/09/2019 - Start
                    if(acc.E_club_Expiration_date__pc != mapOldAcc.get(acc.Id).E_club_Expiration_date__pc){
                        //Added by TMA Cynthia Geagea - CRMSS 270-271 - 19/09/2019 - End
                        if(acc.E_club_Expiration_date__pc!=null){
                            if(Date.today()>acc.E_club_Expiration_date__pc.addDays(-30) && Date.today()<=acc.E_club_Expiration_date__pc)
                            {
                                acc.E_Club_Status__c='Renewable';
                            }
                            else if(Date.today()>acc.E_club_Expiration_date__pc && Date.today()<=acc.E_club_Expiration_date__pc.addDays(+30))
                            {
                                acc.E_Club_Status__c='Expired and renewable';
                            }
                            else if(Date.today()>acc.E_club_Expiration_date__pc.addDays(+30))
                            {
                                acc.E_Club_Status__c='Closed';
                            }
                            else if(Date.today()<=acc.E_club_Expiration_date__pc.addDays(-30))
                            {
                                acc.E_Club_Status__c='Valid';
                            }
                        }
                        else
                        {
                            acc.E_Club_Status__c=null;
                        }
                    }
                    //TMA PG 12-9-2019 276 End
                }
            }
        }
    }
}