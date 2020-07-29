/*
* Description: Batch to fill the field "Person Email" of all created Person Accounts with the value of "Email__pc"
* @author: Cynthia Geagea
* @date: 13/05/2019
* @Test: BatchReprise_WebToCase_Test
* @Coverage: 92%
*/

global class BatchReprise_WebToCase implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id,Email__pc,PersonEmail from Account where IsPersonAccount = true and ((Email__pc != null and PersonEmail = null) or (Email__pc = null and PersonEmail != null))' ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Account> listAcc){
        
        List<Account> AccountToUpdate = new List<Account>();
        
        for(Account acc : listAcc){
            
            if(acc.Email__pc != null && acc.PersonEmail == null){
                
            acc.PersonEmail = acc.Email__pc;
                
            }
            
            if(acc.Email__pc == null && acc.PersonEmail != null){
                
            acc.Email__pc = acc.PersonEmail;
                
            }
            
            AccountToUpdate.add(acc);
            
        }
        update AccountToUpdate;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

}