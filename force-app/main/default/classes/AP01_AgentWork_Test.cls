/**
* ********************************************************************************** PS *************************************************************************************************************
* *********************************** Before Runing it, we should connect to omni-channel -> Make the user Online ***********************************************************************************
* ********************************************************************************** End PS ********************************************************************************************************
* @version 1.00 14/03/2019
* @author TMA-EI JK
* @CodeCoverage 
*/
@IsTest
public class AP01_AgentWork_Test {
    @isTest
    public static void test_flagCase(){
        Account PersonAccount1 =  Utils.CreatePersonAccount('Person', null); 
        insert PersonAccount1; 
        
        
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);      
        insert PartnerAccount;
        
        Account PersonAccount = Utils.CreatePersonAccount('Person', PartnerAccount.Id);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        insert PersonAccount;
        
        list<Contact> listContactToInsert = new list<Contact>();  
        Contact cont = Utils.CreateContact('ContactTest',PartnerAccount.Id,'FR');
        cont.Email = 'customer@gmail.com';
        listContactToInsert.add(cont);
        Contact cont1 = Utils.CreateContact('ContactTest1', PartnerAccount.Id, 'FR');
        cont1.Email = 'Person@hotmail.com';
        listContactToInsert.add(cont1);
        insert listContactToInsert;    
        
        //User user1 = new User();
        //user1 = [select ID from user where  id='0050Y0000035GDI' limit 1];
        //system.debug('user1' + user1);
       // System.runAs(user1){
            Hotel__c hotel = Utils.CreateHotel('Hotel 1');
            hotel.Email__c = 'hotel1@gmail.com';
            hotel.Hotel_ID__c = 'test';
            hotel.Country__c = label.FR;
            insert hotel;
            
            list<Case> listCaseToInsert = new list<Case>();
            
            Case cas = Utils.CreateCase();
            cas.Origin = 'Web';
            cas.Type = label.Information_request;
            cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
            cas.Hotel_ID__c = hotel.Hotel_ID__c;
            cas.SuppliedEmail = 'customer1@gmail.com';
            cas.First_Name__c = 'First1';
            cas.Last_Name__c = 'Last1';
            cas.Concerned_country__c = 'IT';
            listCaseToInsert.add(cas);
            
            insert listCaseToInsert;
            ServiceChannel[] SChannel= [SELECT Id,RelatedEntity FROM ServiceChannel Where DeveloperName='Cases' ];
            system.debug('SChannel ' +SChannel);
            ID SChannelId= [SELECT Id FROM ServiceChannel Where DeveloperName='Cases' Limit 1].Id;
            system.debug('SChannelId ' +SChannelId);
            
            
            
            
            
            Schema.SObjectType spType = Schema.getGlobalDescribe().get('ServicePresenceStatus');
            SObject sps = spType.newSObject();
            sps.put('Language', 'en_US');
            sps.put('MasterLabel', 'Available Cases Label');
            sps.put('DeveloperName', 'Available_Cases');
            //  Database.SaveResult sr = Database.insert(sps, true);
            //  insert sps;
               //UserServicePresence USP1 = new UserServicePresence();
                
            
                 //insert USP1;
            
            Schema.SObjectType uspType = Schema.getGlobalDescribe().get('UserServicePresence');
            SObject usp = uspType.newSObject();
            //   usp.put('IsAway', 'false');
            //  usp.put('Name', 'Test User Service Presence');
            //  usp.put('ServicePresenceStatusId', sps.id);
            //  usp.put('StatusStartDate', system.now());
            //    usp.put('UserId', user1.id);
            //      Database.insert(usp, true); 
            //   insert usp;
           
            String user1 = Userinfo.getUserId();
            AgentWork awork = new AgentWork();
            awork.ServiceChannelId = SChannelId;
            awork.UserId = user1;
            awork.WorkItemId = cas.Id;
            insert awork;
        //}
    }
    
  
}