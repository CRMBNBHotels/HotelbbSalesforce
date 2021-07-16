/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Shiksha 
* @date: 24/06/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 24-JUN-2021  Shiksha      1.0     CRMSS-1218 : Opportunité Groupe France - Mail client lorsqu'une option arrive à échéance 
*                                      CRMSS-1219 : Opportunité Groupe France - Mail client relance offre tarifaire
*                                                   (Mail sent by code to ensure that we do not get issues of mail not received by clients as 
*                                                   previously seen with other clients when workflow or flows were used)
*-- 15-JUN-2021   Amira        2.0     CRMSS-1230 : Tâche à créer- Opportunité Groupe France - Mail client lorsqu'une option arrive à échéance
*                                      CRMSS-1229 : Tâche à créer - Opportunité Groupe France - Mail accusé reception à la création de l'opportunité dans SF
*
* @TestClass : Batch_GroupOppMail_Test
*********************************************************************************************************************************************************************/

global without sharing class Schedule_Batch_GroupOppMail  implements Schedulable{
    
    public String   query;
    public Date     emailDate;
    public String   template;   

    global void execute(SchedulableContext ctx) {
            
        Integer batchsize = Utils.getBatchSize(String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));       
                              
        Batch_GroupOppMail batchLaunch = new Batch_GroupOppMail (query, emailDate, template);
        database.executebatch(batchLaunch,batchsize);
    }
    
    public Schedule_Batch_GroupOppMail ( String aOppType) { 
        if (aOppType == 'OppGroupFrance_Relance_FR'){
            emailDate = System.Today().addDays(-2);         
            query = ' SELECT Id,Option_Date__c, ContactId, Opportunity.Hotel_Name__c,Arrival_Date__c, Contact__r.email, Owner.Email, Owner.Name,LanguageCom__c, ProposalDate__c '+
                    ' FROM Opportunity '+
                    ' WHERE ProposalDate__c =:emailDate AND LanguageCom__c =\'French\' ';
            template = 'FrenchOppGroupSendPricingOffer';
        }
        
        if (aOppType == 'OppGroupFrance_Relance_EN'){
            emailDate = System.Today().addDays(-2);         
            query = ' SELECT Id,Option_Date__c, ContactId, Contact__r.email, Owner.Email, Owner.Name,LanguageCom__c, ProposalDate__c '+
                    ' FROM Opportunity '+
                    ' WHERE ProposalDate__c =:emailDate AND LanguageCom__c =\'English\' ';
            template = 'EnglishOppGroupSendPricingOffer';
        }
        
        if (aOppType == 'OppGroupFrance_OptionExpiration_FR'){                  
            query = ' SELECT Id,Option_Date__c, ContactId, Contact__r.email, Owner.Email, Owner.Name,LanguageCom__c, ProposalDate__c '+
                    ' FROM Opportunity '+
                    ' WHERE Option_Date__c = TODAY AND LanguageCom__c =\'French\' ';
            template = 'FrenchOppGroupSaleAlertOnOptionDate';
        }
        
        if (aOppType == 'OppGroupFrance_OptionExpiration_EN'){                  
            query = ' SELECT Id,Option_Date__c,OwnerId,Opportunity.Hotel_Name__c,Arrival_Date__c, ContactId, Contact__r.email, Owner.Email, Owner.Name,LanguageCom__c, ProposalDate__c '+
                    ' FROM Opportunity '+
                    ' WHERE Option_Date__c = TODAY AND LanguageCom__c =\'English\' ';
            template = 'EnglishOppGroupSaleAlertOnOptionDate';
        }
    }
    
    
}