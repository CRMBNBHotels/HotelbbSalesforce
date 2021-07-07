/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/02/2021
* @details : Scheduler for Batch_carteLogeeNotifActions
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 08-FEB-2021  Amira      1.0      CRMSS-359 : Carte logée credit card expire dans 1 mois - notification owner un mois avant la date d’expiration de la carte bancaire                                      
* @TestClass : AP03_Contract_Test
*********************************************************************************************************************************************************************/

global without sharing class Schedule_CLCreditExpirationDate implements Schedulable{

    global void execute(SchedulableContext ctx) {
            
        Integer batchsize = Utils.getBatchSize(String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));       
       
        string query ='select id,Owner.Email,Owner.Name, ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c '+
             'from Contract '+
             'where CorporateCode__c !=null and Status = \'Activated\' and RecordType.DeveloperName=\'Carte_log_e_RT_France\' and CreditCardExpDate__c=:expectedresult ';
       
         Batch_carteLogeeNotifActions batchLaunch = new Batch_carteLogeeNotifActions(query, 'avant expiration');
        database.executebatch(batchLaunch,batchsize);

    }
}