/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Shiksha 
* @date: 08/02/2021
* @details : Scheduler for Batch_carteLogeeNotifActions
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 08-FEB-2021  Shiksha      1.0     CRMSS-1051: carte logée credit card expire avant la fin du contrat : Statut du contrat devient “Expiré” + Notification Owner 
                                  
* @TestClass : AP03_Contract_Test
*********************************************************************************************************************************************************************/


Global class Schedule_Batch_CLNotifyCreditCardExp implements Schedulable{

    global void execute(SchedulableContext ctx) {
            
        Integer batchsize = Utils.getBatchSize(String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));       
     
        String query ='SELECT id,Owner.Email,Owner.Name,ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c '+
             'FROM Contract '+
             'WHERE CorporateCode__c != Null AND Status != \'Expired\' AND RecordType.DeveloperName=\'Carte_log_e_RT_France\' AND CreditCardExpDate__c=TODAY ';
               
        Batch_carteLogeeNotifActions batchLaunch = new Batch_carteLogeeNotifActions(query, 'expiration');
        database.executebatch(batchLaunch,batchsize);
    }
}