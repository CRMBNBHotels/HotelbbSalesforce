/*
* Description: Assign a created case (via web) to the user with the least number of assigned open cases in the queue owning the case
* @author: TMA-EI Cynthia Geagea
* @date: 29/05/2019
* @Test: AP03_Case_Test
* @Coverage: 81%
*/

public without sharing class AP03_Case {
    
    //method to assign a web case to the user with the least number of assigned open cases in the queue owning the case
    public static void AssignCaseToUser (List<Case> newList){
         system.debug('@@@ ap03 case AssignCaseToUser');
        Map<String,String> mapCaseQueue = new Map<String,String>();
        
        //Filter the cases to work on the ones that originate from the web, are open and owned by a queue only
        For(Case cas : newList){
            
            String OwnerIdString = cas.OwnerId;
            if(cas.Origin == 'Web' && cas.Status == 'Open' && OwnerIdString.substring(0,3) == '00G'){
                mapCaseQueue.put(cas.id,cas.OwnerId);
            }
        }
        
        List<GroupMember> listUserQueue = [select Id, GroupId, UserOrGroupId from GroupMember where GroupId IN : mapCaseQueue.values()]; 
        system.debug('listUserQueue'+listUserQueue);
        Map<String,set<String>> mapQueueListUser = new Map<String,set<String>>();
        Set<String> setUserId = new Set<String>();
        Set<String> setQueueUsers;
        For(GroupMember grpMbr : listUserQueue){
            if(mapQueueListUser.containsKey(grpMbr.GroupId)){
                setQueueUsers = mapQueueListUser.get(grpMbr.GroupId);
            }
            else{
                setQueueUsers = new  Set<String>();
            }
            String UserOrGroupIdString = grpMbr.UserOrGroupId;
            if(UserOrGroupIdString.substring(0,3) == '005'){
                if(!setUserId.contains(UserOrGroupIdString)){
                    setUserId.add(UserOrGroupIdString);
                }
                if(!setQueueUsers.contains(UserOrGroupIdString)){
                    setQueueUsers.add(UserOrGroupIdString);
                }
                mapQueueListUser.put(grpMbr.GroupId,setQueueUsers);
                
            }
        }
        
        //Retrieve all the open cases that are assigned to the members of the queue
        List<Case> listCase = [Select Id, OwnerId
                               From Case
                               Where OwnerId IN : setQueueUsers]; 
        
        //Calculate the number of open cases assigned to each member of the queue
        Map<String, Integer> mapCount = new Map<String, integer>();
        system.debug('### ' + setQueueUsers + ' * ' + listCase);
        For(Case cas : listCase){
           
            if(setQueueUsers.contains(cas.OwnerId)){
                
                Integer count;
                
                if(mapCount.get(cas.OwnerId) == null){
                    
                    mapCount.put(cas.OwnerId, 0);
                }
                
                count  = mapCount.get(cas.OwnerId);
                count++;
                
                mapCount.put(cas.OwnerId, count);
            }
            else{
                
                mapCount.put(cas.OwnerId, 1);
            }
                            
        }
        
        //In case a user in the queue doesn't have any assigned open  cases we need to add him to mapCount with a count = 0
        for(String QueueId : mapQueueListUser.KeySet()){
            
            set<String> setUsers = mapQueueListUser.get(QueueId);
            for(String UserId : setUsers){
                
                if(!mapCount.ContainsKey(UserId)){
                    
                    mapCount.put(UserId,0);
                }
            }
        }
        
        //Compare the number of assigned open cases of each user in the queue, and assign the new case to the one having the least numnber of assigned cases
        For(Case cas : newList){
            if(mapCaseQueue.containskey(cas.id)){
                
                Integer minAssignedCases;
                Set<String> setUserIdCase = mapQueueListUser.get(mapCaseQueue.get(cas.id));
                
                if(setUserIdCase != null && setUserIdCase.size()>0){
                    
                    String userIdMin;
                    For(String userId : setUserIdCase){
                        
                        if(mapCount.containsKey(userId) && minAssignedCases == null){
                            minAssignedCases = mapCount.get(userId);
                            userIdMin = userId;
                        }
                        if(mapCount.containsKey(userId) && minAssignedCases > mapCount.get(userId)){
                            
                            minAssignedCases = mapCount.get(userId);
                            userIdMin = userId;
                        }
                    }
                    
                    cas.OwnerId = userIdMin;
                    Integer newNb = mapCount.get(userIdMin);
                    newNb++;
                    mapCount.put(userIdMin,newNb);
                }
                
            }
        }
    }
    
    //method to send an email to a user whenever a case is assigned to him
    public static void SendEmailToCaseOwner(List<Case> newList, map<Id,Case> oldMap){
        system.debug('@@@ ap03 case SendEmailToCaseOwner');
        list<Case> listCase = new list<Case>();
        
        for(Case cas: newList)
        {
            if(cas.OwnerId != oldMap.get(cas.Id).OwnerId)
            {
                listCase.add(cas);
            }
             System.debug('@@@ listCase'+listCase);
        }
       
        Map<String, String> mapCaseOwnerId = new Map<String, String>();
        Map<String, String> mapOwnerIdEmail = new Map<String, String>();
        
        for(Case cas : listCase){
            
            string OwnerIdString = cas.OwnerId;
            
            if(OwnerIdString.substring(0,3) == '005'){
                
                mapCaseOwnerId.put(cas.Id,cas.OwnerId);
            }
        }
        
        List<User> listUser = [select id, Email, FirstName, LastName from user where Id IN : mapCaseOwnerId.values()];
        system.debug('@@@ listUser'+listUser);
        For(User user : listUser){
            
            mapOwnerIdEmail.put(user.id,user.Email);
        }
        
        List<Messaging.SingleEmailMessage> listMails = new List<Messaging.SingleEmailMessage>();  
        
        EmailTemplate emailTemplateObj = [SELECT Id, HtmlValue, Body,subject FROM EmailTemplate WHERE Name =: Label.EmailTemplate_SendNotifToOwner];
        String subject = emailTemplateObj.Subject;
        String plainBody = emailTemplateObj.Body;
        
        Organization org = [select Name from Organization ];
        String orgName = org.Name;
        
        for(Case cas : listCase){
            if(mapOwnerIdEmail.ContainsKey(cas.OwnerId)){
                
                if(mapOwnerIdEmail.get(cas.OwnerId) != null){
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add(mapOwnerIdEmail.get(cas.OwnerId));
                    Messaging.SingleEmailMessage mail = Utils.CreateSingleEmailMessage(sendTo,null,cas.OwnerId,null,emailTemplateObj.Id,'noreply@hotelbb.com');
                    mail.setSaveAsActivity(false);
                    mail.setTreatTargetObjectAsRecipient(false);
                    system.debug('cas.Hotel_Name_1__c '+cas.Hotel_Name_1__c);
                    subject = subject.replace('{!Organization.Name}', orgName);
                    subject = subject.replace('{!Case.CaseNumber}', cas.CaseNumber);
                    subject = subject.replace('{!Case.Subject}', cas.Type);
                    mail.setSubject(subject);
                    
                    plainBody = plainBody.replace('{!Case.CaseNumber}', cas.CaseNumber);
                    plainBody = plainBody.replace('{!Case.Type}', cas.Type);
                    if(cas.Hotel_Name_1__c != null){
						//modified tkt MS-3072 21/02/2020
                        plainBody = plainBody.replace('{!Case.Hotel_Name_1__c}', cas.Hotel_Name_1__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Hotel_Name_1__c}', ' '); 
                    }
                    //end
                    if(cas.Last_Name__c != null){
                        plainBody = plainBody.replace('{!Case.Last_Name__c}', cas.Last_Name__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Last_Name__c}', ' '); 
                    }
                    if(cas.First_Name__c != null){
                        plainBody = plainBody.replace('{!Case.First_Name__c}', cas.First_Name__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.First_Name__c}', ' '); 
                    }
                    if(cas.E_club_ID__c != null){
                        plainBody = plainBody.replace('{!Case.E_club_ID__c}', cas.E_club_ID__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.E_club_ID__c}', ' '); 
                    }
                    if(cas.SuppliedEmail != null){
                        plainBody = plainBody.replace('{!Case.SuppliedEmail}', cas.SuppliedEmail);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.SuppliedEmail}', ' '); 
                    }
                    if(cas.SuppliedPhone != null){
                        plainBody = plainBody.replace('{!Case.SuppliedPhone}', cas.SuppliedPhone);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.SuppliedPhone}', ' '); 
                    }
                    if(cas.Guest_Adress__c != null){
                        plainBody = plainBody.replace('{!Case.Guest_Adress__c}', cas.Guest_Adress__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Guest_Adress__c}', ' '); 
                    }
                    if(cas.Zip_code__c != null){
                        plainBody = plainBody.replace('{!Case.Zip_code__c}', cas.Zip_code__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Zip_code__c}', ' '); 
                    }
                    if(cas.City__c != null){
                        plainBody = plainBody.replace('{!Case.City__c}', cas.City__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.City__c}', ' '); 
                    }
                    if(cas.Country__c != null){
                        plainBody = plainBody.replace('{!Case.Country__c}', cas.Country__c);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Country__c}', ' '); 
                    }
                    if(cas.Description != null){
                        plainBody = plainBody.replace('{!Case.Description}', cas.Description);
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Description}', ' '); 
                    }
                    if(cas.Arrival_Date__c != null){
                        plainBody = plainBody.replace('{!Case.Arrival_Date__c}', string.valueOf(cas.Arrival_Date__c));
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Arrival_Date__c}', ' '); 
                    }
                    if(cas.Departure_date__c != null){
                        plainBody = plainBody.replace('{!Case.Departure_date__c}', string.ValueOf(cas.Departure_date__c));
                    }
                    else{
                       plainBody = plainBody.replace('{!Case.Departure_date__c}', ' '); 
                    }
                    plainBody = plainBody.replace('{!Case.Thread_Id}', cas.ThreadId_Case__c);
                    mail.setPlainTextBody(plainBody);
                    
                    listMails.add(mail);
                }
            }
        }
            
        Messaging.sendEmail(listMails);    
    }
}