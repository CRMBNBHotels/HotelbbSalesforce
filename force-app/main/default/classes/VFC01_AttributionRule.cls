public without sharing class VFC01_AttributionRule {
    Public List<SelectOption> QueueList {get;set;}
    public List<Group> GroupNameList {get;set;}
    Public list<GroupMember> mlist  {get;set;} 
    public String queue {get;set;}
    public String queueid {get;set;}
    public List<String> selectedUserIds { get; set; }
    public List<String> removedUserIds { get; set; }
    public String whereClause { get; set; }
    private Map<Id, String> availableUsersMap;
    private Map<Id, String> selectedUsersMap;
    String ProfileName;
    Public String ProfileManagerName;
    public  VFC01_AttributionRule() {
        initializeCollections();
        ID Userid= userinfo.getProfileid();
        String QueueName='';
        List<String> ListQueueName = new List<String>(); 
        Profile Userprofile = new Profile();
        Userprofile=[select id,name from Profile where id =: Userid]; 
        Map<String, Queue_Profile__c> QueueProfile = Queue_Profile__c.getAll();
        Map<String, Agent_Manager__c> AgentManager = Agent_Manager__c.getAll();
        system.debug('QueueProfile###'+QueueProfile);
        system.debug('Userprofile.name###'+Userprofile.name);
        if(Userprofile.name!=null) 
        {
            system.debug('TesttUser'+Userprofile);
            system.debug('TestbeforeIF'+QueueProfile);
            if(QueueProfile.containsKey(Userprofile.name))
            {
                system.debug('TestIF'+QueueProfile); 
                ListQueueName=QueueProfile.get(Userprofile.name).queue__c.split(','); 
            }
            if(AgentManager.containskey(Userprofile.name))
            {
                ProfileName=AgentManager.get(Userprofile.name).Agent__c; 
                ProfileManagerName = Userprofile.name;
                system.debug('ProfileName###'+ProfileName);
                system.debug('ProfileManagerName'+ProfileManagerName);
            }
        }
        GroupNameList = new List<Group>();
        if(ListQueueName!=null && ListQueueName.size()>0)
        {
            GroupNameList = [select g.Id, g.Name from Group g where Type = 'Queue' and Name IN :ListQueueName  Order by Name Asc]; 
        }
        QueueList = new List<SelectOption>(); 
        for(Group temp : GroupNameList)
        {   
            queueid = temp.id; 
            QueueList.add(new SelectOption(temp.Id, temp.Name)); 
        }
        if(queue  == null && queueid!=null){
            queue = queueid;
            getUsers();
        }
        system.debug('QueueList++++++'+QueueList);
        system.debug('queue ++++++'+queue );
    }
    
    public PageReference UpdateList() {
        system.debug('##### queue' + queue);
        initializeCollections();
        getUsers();
        return null;
    }
    public void filterAvailableOptions() {
        availableUsersMap = new Map<Id, String>();
        selectedUserIds = new List<String>();
        String likeClause = '%' + whereClause + '%';
        for (User u : [SELECT id, name,profile.name FROM User WHERE name like :likeClause AND Name!='Chatter Expert' AND IsActive = true  order by Name Asc]) {
            
            if (!selectedUsersMap.containsKey(u.Id)) {
                system.debug('TesttttProf##'+u.profile.name);
                system.debug('ProfileName###'+ProfileName);
                system.debug('ProfileManagerName'+ProfileManagerName);
                if(u.profile.name==ProfileName || (u.profile.name == ProfileManagerName && (ProfileManagerName == 'Italy Service Manager' || ProfileManagerName == 'Spain Service Manager' || ProfileManagerName == 'French Service Manager')))
                {
                    system.debug('Done###');
                    system.debug('u.profile.name'+u.profile.name);
                    system.debug('u.Name'+u.Name);
                    availableUsersMap.put(u.Id, u.Name); 
                }
            }
        }
    }
    public void add() {
        if (!selectedUserIds.isEmpty()) {
            for (String userId : selectedUserIds) {
                selectedUsersMap.put(userId, availableUsersMap.get(userId));
                availableUsersMap.remove(userId);
            }
        }
    }
    
    public void remove() {
        if (!removedUserIds.isEmpty()) {
            for (String userId : removedUserIds) {
                availableUsersMap.put(userId, selectedUsersMap.get(userId));
                selectedUsersMap.remove(userId);
            }
        }
    }
    
    public List<SelectOption> getAvailableUsers() {
        List<SelectOption> availableUsers = new List<SelectOption>();
        for (Id userId : availableUsersMap.keySet()) {
            availableUsers.add(new SelectOption(userId, availableUsersMap.get(userId)));
        }
        return availableUsers;
    }
    
    public List<SelectOption> getSelectedUsers() {
        List<SelectOption> selectedUsers = new List<SelectOption>();
        for (String userId : selectedUsersMap.keySet()) {
            selectedUsers.add(new SelectOption(userId, selectedUsersMap.get(userId)));
        }
        return selectedUsers;
    }
    
    private void initializeCollections() {
        selectedUserIds = new List<String>();
        removedUserIds = new List<String>();
        availableUsersMap = new Map<Id, String>();
        selectedUsersMap = new Map<Id, String>();
    }
    
    private void getUsers() {
        if(queue!=null)
        {
        QueueSobject qs = [SELECT QueueId,SobjectType FROM QueueSobject where QueueId=:queue];
        list<GroupMember> gms = [SELECT Group.Name,UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND GroupId =:qs.QueueId];
        system.debug(gms);
        set<id> gids =new set<id>();
        for(GroupMember g:gms){
            gids.add(g.UserOrGroupId);
        }
              system.debug('ProfileName###'+ProfileName);
             system.debug('gids###'+gids);
        list<user> urs = [SELECT id, Name,profile.name FROM User where IsActive = true AND id NOT IN:gids AND Name!='Chatter Expert' and (profile.name =:ProfileName or profile.name =:ProfileManagerName) and profile.name!='' order by Name Asc];
        system.debug('Userr###'+urs);
        for(user u : urs){
            availableUsersMap.put(u.Id, u.Name);
            system.debug('availableUsersMap####'+availableUsersMap.get(u.id));
        }
        list<user> urss = [SELECT id, Name FROM User where IsActive = true AND id IN:gids AND Name!='Chatter Expert' order by Name Asc];
        system.debug(urs);
        for(user ur : urss){
            selectedUsersMap.put(ur.Id, ur.Name);
        }
        }
    }
    public PageReference save(){
        List<GroupMember> groups = new List<GroupMember>();
        List<GroupMember> groupss = [select Id from GroupMember where Group.Type = 'Queue' and GroupId =:queue ];
        if( !groupss.isEmpty() )
        {
            delete groupss;        
        }
        if(selectedUsersMap.size() == 0){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Please select a user to Add to Queue') );
        }
        else{
            for(id ids:selectedUsersMap.keyset()){
                // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.INFO, 'Added user to Queue'+queue) );
                insert new GroupMember( GroupId = queue , UserOrGroupId = ids); 
            }
        }
        return null;
    }
    public PageReference Cancel(){
        UpdateList();       
        return null;
    }
}