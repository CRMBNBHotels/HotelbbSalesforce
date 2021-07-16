/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Shiksha 
* @date: 08/02/2021
* @details : Scheduler for Batch_carteLogeeNotifActions
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 22-FEB-2021  Shiksha      1.0     CRMSS-1042/1064: carte logée Génération du relevé de facture Batch, récupération des données et calculs
* -- 07 Jul-2021  Amira        2.0     CRMSS-1238 : Carte logée - Relevé de factures et factures unitaires : afficher code carte logée au lieu numéro de contrat
*                                  
* @TestClass : AP03_Contract_Test
*********************************************************************************************************************************************************************/


Global class Schedule_Batch_CLRelevedesFactures implements Schedulable{

    global void execute(SchedulableContext ctx) {
            
        Integer batchsize = Utils.getBatchSize(String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));       
     
        String query =  ' SELECT Id, ContractNumber,CorporateCode__r.name, Contact__c, Contact__r.Email , OwnerId, Owner.Email, Owner.Name, ContactComptabilite__r.Email, ContactComptabilite__c '+
                        ' FROM Contract '+
                        ' WHERE Id IN (SELECT Contrat__c FROM tableVente__c WHERE DateSejour__c =LAST_MONTH) AND RecordType.DeveloperName=\'Carte_log_e_RT_France\'';

        Batch_CLRelevedesFactures batchLaunch = new Batch_CLRelevedesFactures (query);
        database.executebatch(batchLaunch,batchsize);
    }
}