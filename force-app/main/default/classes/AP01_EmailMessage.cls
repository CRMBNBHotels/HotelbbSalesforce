/*
* Description: change case status to reset workflow ticket:CRMSS-55
* @author: Victor Khoury
* @date: 3/01/2019
* @Test: AP01_EmailMessage_Test
*/
public without sharing class AP01_EmailMessage {
    
    public static void ChangeCaseStatus(Map<Id,EmailMessage> MaptriggerNew){
        
        set<Id> HotelIds = new set<Id>();
        set<Id> PersonalAccountIds = new set<id>();
        Map<Id,List<Id>> CaseId_EmailMessagesIds = new Map<Id,List<Id>>();
        List<Case> CaseToUpdateWC = new List<Case>();
        List<Case> CaseToUpdateWH = new List<Case>();
        
        for(EmailMessage EmailM:MaptriggerNew.values()){
            if(EmailM.ParentId <> null){
                List<Id> EmailMessageIds = new List<Id>();
                
                if(CaseId_EmailMessagesIds.containsKey(EmailM.ParentId))
                    EmailMessageIds = CaseId_EmailMessagesIds.get(EmailM.ParentId);
                
                EmailMessageIds.add(EmailM.Id);
                //Case may have multiple EmailMessages
                CaseId_EmailMessagesIds.put(EmailM.ParentId, EmailMessageIds);
            }
        }
        
        system.debug('####CaseId_EmailMessagesIds:' + CaseId_EmailMessagesIds);
        
        if(CaseId_EmailMessagesIds.size() > 0){
            
            List<Case> ListCase = [select id,hotel__r.Email__c,Account.PersonEmail,Status 
                                   From Case 
                                   Where Id In: CaseId_EmailMessagesIds.keySet()];
            if(ListCase.size() > 0){
                for(Case CaseToLoop:ListCase){
                    for(Id EmailMessageId:CaseId_EmailMessagesIds.get(CaseToLoop.Id)){
                        system.debug('##CaseToLoop.Account.PersonEmail:' + CaseToLoop.Account.PersonEmail);
                        system.debug('##MaptriggerNew.get(EmailMessageId).ToAddress:' + MaptriggerNew.get(EmailMessageId).ToAddress);
                        if(CaseToLoop.hotel__r.Email__c == MaptriggerNew.get(EmailMessageId).FromAddress
                           && MaptriggerNew.get(EmailMessageId).ToAddress.Contains(CaseToLoop.Account.PersonEmail)){
                               if(CaseToLoop.Status == 'Waiting Customer'){
                                   if(!CaseToUpdateWC.contains(CaseToLoop))
                                       CaseToUpdateWC.add(CaseToLoop);
                               }
                               else if(CaseToLoop.Status == 'Waiting Hotel'){
                                   if(!CaseToUpdateWH.contains(CaseToLoop))
                                       CaseToUpdateWH.add(CaseToLoop);
                               }
                           }
                    }
                }
                
                system.debug('####CaseToUpdateWC:' + CaseToUpdateWC);
                system.debug('####CaseToUpdateWH:' + CaseToUpdateWH);
                
                if(CaseToUpdateWC.size() > 0){
                    for(Case CaseToLoop:CaseToUpdateWC){
                        CaseToLoop.Status = 'Waiting Hotel';
                    }
                    update CaseToUpdateWC;
                    
                    for(Case CaseToLoop:CaseToUpdateWC){
                        CaseToLoop.Status = 'Waiting Customer';
                    }
                    
                    update CaseToUpdateWC; 
                }
                
                if(CaseToUpdateWH.size() > 0){
                    for(Case CaseToLoop:CaseToUpdateWH){
                        CaseToLoop.Status = 'Waiting Customer';
                    }
                    
                    update CaseToUpdateWH; 
                }
            }
        }
    }
}