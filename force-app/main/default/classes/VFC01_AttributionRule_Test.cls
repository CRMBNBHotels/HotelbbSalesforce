@isTest
public class VFC01_AttributionRule_Test {
    static TestMethod void testAttribution(){
        
        Id ProfileIdSpainManager = [SELECT Id FROM Profile WHERE Name = 'Spain Service Manager'].Id;
        Id ProfileIdSpainAgent = [SELECT Id FROM Profile WHERE Name = 'Spain Service Agent'].Id;
        user u = new user();
        u.ProfileId=ProfileIdSpainManager;
        u.LastName = 'Spain';
        u.isactive=true;
        u.Email = 'Spain@test.com';
        u.Username = 'SpainService@manager.com';
        u.CompanyName = 'TEST';
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        insert u;
        
        user u1 = new user();
        u1.ProfileId=ProfileIdSpainAgent;
        u1.LastName = 'Spain2';
        u1.isactive=true;
        u1.Email = 'Spain2@test.com';
        u1.Username = 'Spain2Service@manager.com';
        u1.CompanyName = 'TEST';
        u1.Title = 'title';
        u1.Alias = 'alias';
        u1.TimeZoneSidKey = 'America/Los_Angeles';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.LocaleSidKey = 'en_US'; 
        insert u1;
        
        System.runAs(u){
            system.debug('u$$$$'+u.ProfileId);
            Queue_Profile__c qp= new Queue_Profile__c();
            qp.name='Spain Service Manager';
            qp.Queue__c='Spain Queue Hotel Case';
            insert qp;
            Agent_Manager__c AM= new Agent_Manager__c();
            AM.name='Spain Service Manager';
            AM.Agent__c='Spain Service Agent';
            insert AM;
            test.startTest();
            VFC01_AttributionRule controleur = new VFC01_AttributionRule();
            controleur.Cancel();
            controleur.getAvailableUsers();
            controleur.filterAvailableOptions();
            controleur.add();
            controleur.getSelectedUsers(); 
            controleur.remove(); 
            test.StopTest();
        }
    }
}