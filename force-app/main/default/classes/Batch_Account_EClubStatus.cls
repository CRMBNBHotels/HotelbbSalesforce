/*
* Description: This batch will be executed only once at 00:01 , to modify the E-Club status for the person accounts depending on the Expiration date
* @author: TMA-EI JKA
* @date: 21/10/2019
* @Test: Batch_Account_EClubStatus_Test
* @Coverage: 100%
*/

Global class Batch_Account_EClubStatus implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('@@@@ batch start');
        // collect the batches of records or objects to be passed to execute
        String query = 'select id, E_club_Expiration_date__pc, E_Club_Status__c from Account ' + System.Label.Batch_Account_EClubStatus_WhereClause;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Account> listAcc){
        system.debug('@@@@ batch execute');
     
        // process each batch of records
        List<Account> listAccFiltered = new List<Account>();
        
        For(Account acc : listAcc){
            Account accToUpdate = new Account();
            // if(acc.E_club_Expiration_date__pc!=null){
            
            if(Date.today()>acc.E_club_Expiration_date__pc.addDays(-30) && Date.today()<=acc.E_club_Expiration_date__pc)
            {
                accToUpdate.E_Club_Status__c='Renewable';
            }
            else if(Date.today()>acc.E_club_Expiration_date__pc && Date.today()<=acc.E_club_Expiration_date__pc.addDays(+30))
            {
                accToUpdate.E_Club_Status__c='Expired and renewable';
            }
            else if(Date.today()>acc.E_club_Expiration_date__pc.addDays(+30))
            {
                accToUpdate.E_Club_Status__c='Closed';
            }
            else if(Date.today()<=acc.E_club_Expiration_date__pc.addDays(-30))
            {
                accToUpdate.E_Club_Status__c='Valid';
            }
            //}
            //else
            //  {
            //     acc.E_Club_Status__c=null;
            //  }                        
            accToUpdate.id=acc.id;
            listAccFiltered.add(accToUpdate); 
             system.debug('@@@ batch u');
        }
        
        if(listAccFiltered != null && listAccFiltered.size()>0){
           
            update listAccFiltered;
        } 
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('@@@@ batch finish');
    }
    
}