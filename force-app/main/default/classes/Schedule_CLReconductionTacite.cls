/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/02/2021
* @details : Scheduler for Batch_carteLogeeNotifActions
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 08-FEB-2021  Amira      1.0      * CRMSS-975 : Une carte logée (Si au statut Actif uniquement) est renouvelée tacitement UN JOUR AVANT LA DATE DE FIN DE CONTRAT                                  
* @TestClass : AP03_Contract_Test
*********************************************************************************************************************************************************************/

global without sharing class Schedule_CLReconductionTacite implements Schedulable{

    global void execute(SchedulableContext ctx) {
            
        Integer batchsize = Utils.getBatchSize(String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));       
                              
        string query ='select id,Owner.Email,Owner.Name,ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c,ContractTerm '+
             'from Contract '+
             'where CorporateCode__c !=null and Status = \'Activated\' and RecordType.DeveloperName=\'Carte_log_e_RT_France\' and Expiration_Date__c=TOMORROW';
      
        Batch_carteLogeeNotifActions batchLaunch = new Batch_carteLogeeNotifActions(query, 'reconduction');
        database.executebatch(batchLaunch,batchsize);
    }
}