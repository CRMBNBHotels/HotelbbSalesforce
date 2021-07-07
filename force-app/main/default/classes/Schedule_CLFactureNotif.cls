/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira
* @date: 25/02/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 25-FEB-2021  Amira        1.0     CRMSS-1039: Notification au travel manager lorsque une facture est rattaché à un contrat carte logée
* -- 
* @TestClass : AP03_Contract_Test
*****************/

global without sharing class Schedule_CLFactureNotif implements Schedulable{

    global void execute(SchedulableContext ctx) {
        Integer batchsize = Utils.getBatchSize(String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));       
                                 
        string query ='select id,Owner.Email,Owner.Name,ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c,contact__r.Email,ContactComptabilite__r.Email,ContactComptabilite__c, ContractTerm '+
             'from Contract '+
             'where CorporateCode__c !=null and Status = \'Activated\' and RecordType.DeveloperName=\'Carte_log_e_RT_France\'';
      
        Batch_FactureNotifs batchLaunch = new Batch_FactureNotifs(query);
        database.executebatch(batchLaunch,batchsize);
    }
}