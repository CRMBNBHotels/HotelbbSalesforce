/*
* Description: Assign a created case (via web) to the user with the least number of assigned open cases in the queue owning the case
* @author: TMA-EI Cynthia Geagea
* @date: 29/05/2019
* @Test: AP03_Case_Test
* @Coverage: 81%
*/

public without sharing class AP03_Case {
    
    public static Map<String,String> getItemsList(){
        Map<String,String> options = new Map<String,String>(); 
        List<Schema.Picklistentry> fieldResult = Case.type.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry f : fieldResult) {
            options.put(f.getValue(), f.getLabel());
        }
        return options;
    }
    //method to assign a web case to the user with the least number of assigned open cases in the queue owning the case
    public static void AssignCaseToUser (List<Case> newList, Map<ID,Case> mapOldCases){
        
        Map<String,String> mapCaseQueue = new Map<String,String>();
        
        //Filter the cases to work on the ones that originate from the web, are open and owned by a queue only
        For(Case cas : newList){
            
            String OwnerIdString = cas.OwnerId;
            
            if( (mapOldCases == null || (mapOldCases != null && mapOldCases.get(cas.id).ownerid!=cas.OwnerId) ) ){
                if(mapOldCases != null && OwnerIdString.substring(0,3) == '005' ){
                    String OwnerIdStringOld = mapOldCases.get(cas.id).OwnerId;
                    if(OwnerIdStringOld !=null && OwnerIdStringOld.substring(0,3) == '00G'){ 
                        cas.Tech_case_queue__c = mapOldCases.get(cas.id).Tech_old_queu_name__c;
                    }
                }else if(OwnerIdString.substring(0,3) == '00G' ){
                    cas.Tech_case_queue__c = cas.Tech_old_queu_name__c;
                    mapCaseQueue.put(cas.id,cas.OwnerId);
                }
            }
            //if 
        }
        
        List<GroupMember> listUserQueue = [select Id, GroupId, UserOrGroupId from GroupMember where GroupId IN : mapCaseQueue.values()]; 
        
        Map<String,set<String>> mapQueueListUser = new Map<String,set<String>>();
        Set<String> setUserId = new Set<String>();
        Set<String> setQueueUsers;
        Map<String,String> PublicGrpQueID = new Map<String,String>();
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
                if(!setQueueUsers.contains(UserOrGroupIdString) && UserOrGroupIdString != null){
                    setQueueUsers.add(UserOrGroupIdString);
                }
                mapQueueListUser.put(grpMbr.GroupId,setQueueUsers);
                
            }else if(UserOrGroupIdString.substring(0,3) == '00G'){
                PublicGrpQueID.put(UserOrGroupIdString,grpMbr.GroupId);
            }
        }
        
        if(PublicGrpQueID != null && PublicGrpQueID.size()>0){
            List<GroupMember> listUserPG = [select Id, GroupId, UserOrGroupId from GroupMember where GroupId IN : PublicGrpQueID.keyset()]; 
            
            For(GroupMember grpMbr : listUserPG){
                
                //Modified by TMA-EIL CG CRMSS-774 06/07/2020 Start
                if(mapQueueListUser.containsKey(PublicGrpQueID.get(grpMbr.GroupId)) && mapQueueListUser.get(PublicGrpQueID.get(grpMbr.GroupId)) != null){
                    
                    setQueueUsers = mapQueueListUser.get(PublicGrpQueID.get(grpMbr.GroupId));
                }
                else{
                    setQueueUsers = new Set<String>();
                }
                //Modified by TMA-EIL CG CRMSS-774 06/07/2020 End
                
                String UserOrGroupIdString = grpMbr.UserOrGroupId;
                if(UserOrGroupIdString.substring(0,3) == '005'){
                    
                    if(!setUserId.contains(UserOrGroupIdString)){
                        
                        setUserId.add(UserOrGroupIdString);
                    }
                    if(!setQueueUsers.contains(UserOrGroupIdString) && UserOrGroupIdString!= null){
                        
                        setQueueUsers.add(UserOrGroupIdString);
                    }
                    mapQueueListUser.put(PublicGrpQueID.get(grpMbr.GroupId),setQueueUsers);
                    
                }
            }
        }
        //Retrieve all the open cases that are assigned to the members of the queue
        
        List<Case> listCase = [Select Id, OwnerId
                               From Case
                               Where OwnerId IN : setQueueUsers and status != 'Closed' and status != 'Closed Done' and ClosedDate = null]; 
        
        //Calculate the number of open cases assigned to each member of the queue
        Map<String, Integer> mapCount = new Map<String, integer>();
        
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
        system.debug('mapCount first '+ mapCount);
        //In case a user in the queue doesn't have any assigned open  cases we need to add him to mapCount with a count = 0
        for(String QueueId : mapQueueListUser.KeySet()){
            
            set<String> setUsers = mapQueueListUser.get(QueueId);
            for(String UserId : setUsers){
                
                if(!mapCount.ContainsKey(UserId)){
                    
                    mapCount.put(UserId,0);
                }
            }
        }
        system.debug('mapCount second '+ mapCount);
        system.debug('newList  '+ newList);
        //Compare the number of assigned open cases of each user in the queue, and assign the new case to the one having the least numnber of assigned cases
        For(Case cas : newList){
            if(mapCaseQueue.containskey(cas.id)){
                
                Integer minAssignedCases;
                Set<String> setUserIdCase = mapQueueListUser.get(mapCaseQueue.get(cas.id));
                system.debug('mapQueueListUser  '+ mapQueueListUser);
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
                    system.debug('userIdMin  '+ userIdMin);
                }
                
            }
        }
    }
    
    //method to send an email to a user whenever a case is assigned to him
    public static void SendEmailToCaseOwner(List<Case> newList, map<Id,Case> oldMap){
        
        Map<String,String> mapTypeValue = getItemsList();
        list<Case> listCase = new list<Case>();
        
        for(Case cas: newList)
        {
            if(cas.OwnerId != oldMap.get(cas.Id).OwnerId)
            {
                listCase.add(cas);
            }
        }
        
        Map<String, String> mapCaseOwnerId = new Map<String, String>();
        Map<String, String> mapOwnerIdEmail = new Map<String, String>();
        
        for(Case cas : listCase){
            
            string OwnerIdString = cas.OwnerId;
            
            if(OwnerIdString.substring(0,3) == '005'){
                
                mapCaseOwnerId.put(cas.Id,cas.OwnerId);
            }
        }
        
        //Added by TMA-EIL CG CRMSS-712 30/06/2020 Start
        list<Case> listQuerriedCase = new list<Case>([select id, OwnerId, concerned_country__c, SuppliedEmail,SuppliedPhone, contactId, contact.email__c, contact.MobilePhone, Hotel_Name_1__c, CaseNumber, Subject, Salesforce_Case_Type__c,Type, Last_Name__c, First_Name__c, E_club_ID__c, Guest_Adress__c,Zip_code__c,City__c,Country__c,Description,  Arrival_Date__c, Departure_date__c, ThreadId_Case__c 
                                                      from case
                                                      where id in:mapCaseOwnerId.KeySet()]);
        //Added by TMA-EIL CG CRMSS-712 30/06/2020 End
        
        List<User> listUser = [select id, Email, FirstName, LastName from user where Id IN : mapCaseOwnerId.values()];
        
        For(User user : listUser){
            
            mapOwnerIdEmail.put(user.id,user.Email);
        }
        
        List<Messaging.SingleEmailMessage> listMails = new List<Messaging.SingleEmailMessage>();  
        
        EmailTemplate emailTemplateObj = [SELECT Id, HtmlValue, Body,subject FROM EmailTemplate WHERE Name =: Label.EmailTemplate_SendNotifToOwner];
        String subject = emailTemplateObj.Subject;
        String plainBody = emailTemplateObj.Body;
        
        Organization org = [select Name from Organization ];
        String orgName = org.Name;
        
        for(Case cas : listQuerriedCase){
            
            if(mapOwnerIdEmail.ContainsKey(cas.OwnerId)){
                
                if(mapOwnerIdEmail.get(cas.OwnerId) != null){
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add(mapOwnerIdEmail.get(cas.OwnerId));
                    Messaging.SingleEmailMessage mail = Utils.CreateSingleEmailMessage(sendTo,null,cas.OwnerId,null,emailTemplateObj.Id,Label.Email_NoReplyHotelBB);
                    mail.setSaveAsActivity(false);
                    mail.setTreatTargetObjectAsRecipient(false);
                    subject = subject.replace('{!Organization.Name}', orgName);
                    subject = subject.replace('{!Case.CaseNumber}', cas.CaseNumber);
                    
                    if(cas.concerned_country__c != 'FR' && cas.concerned_country__c != 'ES' && cas.concerned_country__c != 'PT'){ subject = subject.replace('{!Case.Subject}', mapTypeValue.containskey(cas.Type)?mapTypeValue.get(cas.Type):cas.Type);
                    }
                    else{
                        //subject = subject.replace('{!Case.Subject}', mapTypeValue.containskey(cas.Salesforce_Case_Type__c)?mapTypeValue.get(cas.Salesforce_Case_Type__c):cas.Salesforce_Case_Type__c);
                        if(mapTypeValue.containskey(cas.Salesforce_Case_Type__c)){
                            subject = subject.replace('{!Case.Type}',mapTypeValue.get(cas.Salesforce_Case_Type__c));
                        }
                        else if(cas.Salesforce_Case_Type__c != null){subject = subject.replace('{!Case.Type}',cas.Salesforce_Case_Type__c);
                        }
                    }
                    
                    mail.setSubject(subject);
                    plainBody = plainBody.replace('{!Case.CaseNumber}', cas.CaseNumber);
                    if(cas.concerned_country__c != 'FR' && cas.concerned_country__c != 'ES' && cas.concerned_country__c != 'PT'){
                        plainBody = plainBody.replace('{!Case.Type}', mapTypeValue.containskey(cas.Type)?mapTypeValue.get(cas.Type):cas.Type);
                    } else {
                        //plainBody = plainBody.replace('{!Case.Type}', mapTypeValue.containskey(cas.Salesforce_Case_Type__c)?mapTypeValue.get(cas.Salesforce_Case_Type__c):cas.Salesforce_Case_Type__c);
                        
                        if(mapTypeValue.containskey(cas.Salesforce_Case_Type__c)){plainBody = plainBody.replace('{!Case.Type}',mapTypeValue.get(cas.Salesforce_Case_Type__c));
                        }
                        else if(cas.Salesforce_Case_Type__c != null){plainBody = plainBody.replace('{!Case.Type}',cas.Salesforce_Case_Type__c);
                        }
                    }
                    
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
                    
                    //Added by TMA-EIL CG CRMSS-712 30/06/2020 Start
                    if(cas.SuppliedEmail != null){
                                                  plainBody = plainBody.replace('{!Case.SuppliedEmail}', cas.SuppliedEmail);
                                                 }
                    else if(cas.SuppliedEmail == null && cas.contactId != null && cas.contact.Email__c != null){
                                                                                                                plainBody = plainBody.replace('{!Case.SuppliedEmail}', cas.contact.Email__c); 
                                                                                                               }
                    else{
                         plainBody = plainBody.replace('{!Case.SuppliedEmail}', ' '); 
                        }
                    if(cas.SuppliedPhone != null){
                                                  plainBody = plainBody.replace('{!Case.SuppliedPhone}', cas.SuppliedPhone);
                                                 }
                    else if(cas.SuppliedPhone == null && cas.contactId != null && cas.contact.MobilePhone != null){
                                                                                                                   plainBody = plainBody.replace('{!Case.SuppliedPhone}', cas.contact.MobilePhone); 
                                                                                                                  }
                    else{
                        plainBody = plainBody.replace('{!Case.SuppliedPhone}', ' '); 
                    }
                    //Added by TMA-EIL CG CRMSS-712 30/06/2020 End
                    
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