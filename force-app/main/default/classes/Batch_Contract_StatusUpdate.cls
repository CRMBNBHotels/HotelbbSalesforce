/*
* Description: Batch to update the status of a contract according to its expiration date CRMSS - 347, and to send an email notification 2 months prior to the expiration date to the contract owner CRMSS -349
* @author: Cynthia Geagea
* @date: 31/10/2019
* @Test: Batch_Contract_StatusUpdate_Test
* @Coverage: 87%
*/

Global without sharing class Batch_Contract_StatusUpdate implements Database.Batchable<sObject>{
    
    global String[] ccAddress1 ;
        global date TodayDate = date.today();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'select id,Owner.Email, Status, EndDate from Contract where Corporate_Code__c !=null and Status != \'Expired\' and (RecordType.DeveloperName=\'Carte_Log_e\' or RecordType.DeveloperName=\'Corporate\') ';
        
        if(!test.isRunningTest()){
            query = query + ' and enddate < TODAY';
        }
        return Database.getQueryLocator(query);
        // and Expiration_Date__c < TODAY
    }
    
    global void execute(Database.BatchableContext bc, list<Contract> listContracts){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        List<Contract> listContractsFiltered = new List<Contract>();
        
        ccAddress1 =  new String[]{};
            
        For(Contract cont : listContracts){
            
            //Added by TMA Cynthia Geagea CRMSS - 347
            if(cont.EndDate  < TodayDate)
            {
                cont.Status = 'Expired';
                listContractsFiltered.add(cont);
            }
            
            //Added by TMA JD CRMSS - 349
            system.debug('### jka cont.Owner.Email'+cont.Owner.Email);
            system.debug('### jka cont.Expiration_Date__c'+cont.enddate);
            system.debug('### jka TodayDate.addMonths(2)'+TodayDate.addMonths(2));
            
            if(cont.Owner.Email != null && cont.EndDate == TodayDate.addMonths(2))
            {
                
                ccAddress1.add(cont.Owner.Email);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.ccaddresses = ccAddress1;
                mail.setSubject('Contract Expires in 2 months');
                mail.setPlainTextBody(label.EmailExpirationMessage);
                mails.add(mail);
            }
        }
        
        if(mails != null && mails.size() >0){
            
            Messaging.sendEmail(mails);  
        }
        
        if(listContractsFiltered != null && listContractsFiltered.size()>0){
            
            update listContractsFiltered;
        }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}