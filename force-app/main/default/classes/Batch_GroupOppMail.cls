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
* -- 15-JUN-2021   Amira        2.0    CRMSS-1230 : Tâche à créer- Opportunité Groupe France - Mail client lorsqu'une option arrive à échéance
*                                      CRMSS-1229 : Tâche à créer - Opportunité Groupe France - Mail accusé reception à la création de l'opportunité dans SF
*
* @TestClass : Batch_GroupOppMail_Test
*********************************************************************************************************************************************************************/

Global class Batch_GroupOppMail implements Database.Batchable<sObject>, Database.stateful{
    global String   query;
    global Date     emailDate;
    global String   template;
   
    global Batch_GroupOppMail (String aQuery, Date aEmailDate, String aTemplate) {
        query     = aQuery;
        emailDate = aEmailDate;
        template  = aTemplate;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){       
        Database.QueryLocator qloc = Database.getQueryLocator(query); 
        return qloc;    
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> oppList){
       
        List<EmailMessageWrapper> msgWrapperList = New List<EmailMessageWrapper>(); 
  		List<Task> tskList = new List<Task>();
        
        EmailTemplate templateList = [SELECT Id,Name,DeveloperName,Subject
                                            FROM EmailTemplate
                                            WHERE DeveloperName =: template];

        for (Opportunity opp: oppList){
            EmailMessageWrapper msg = New EmailMessageWrapper(opp.Owner.Email, opp.Owner.Name, New List<String> {opp.contact__r.email}, opp.Contact__c, null,null, null, null, false , opp.Id );
            msgWrapperList.add(msg);    
            
            Messaging.SingleEmailMessage emailRender = Messaging.renderStoredEmailTemplate(templateList.Id, opp.Contact__c, opp.Id);
            String emailBody = emailRender.getPlainTextBody();
            String Subject= emailRender.getSubject();
            
            			
            Task Tsk= Utils.CreateTask('Terminé',opp.Contact__c ,opp.Id ,system.today(),'Low',Subject,emailBody);
            tskList.add(Tsk);
        }           
        
		Database.Insert(tskList);
        Utils_Email.sendEmail(msgWrapperList, template);
    }
        
    global void finish(Database.BatchableContext BC){
        
    }
}