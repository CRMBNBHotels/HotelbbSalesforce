/*
* Description: Test class for BatchSuppression_Logs
* @author: Cynthia Geagea
* @date: 21/06/2019
*/

@isTest
public class BatchSuppression_Logs_Test {
    
    @isTest
    static void batchDeleteLogsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        u.BypassValidationRule__c = true;
        insert u;
        
        System.runAs(u){
            
            List<Attachment> listAttach = new List<Attachment>();
            List<Log__c> listLogs = new List<Log__c>();
            
            for(Integer i=0 ;i <100;i++){
                
                Log__c logObj = new Log__c();
                listLogs.add(logObj);
            }
            
            insert listLogs;
            
            for (Integer i=0 ;i <100;i++){
                
                Attachment attachObj = new Attachment(ParentId = listLogs[i].Id,
                                                     Name = 'attach'+i,
                                                     Body = Blob.valueOf('/services/data/v46.0/sobjects/Attachment/00P4E00000355oZUAQ/Body'));
                listAttach.add(attachObj);
            }
            
            insert listAttach;
            
            Test.startTest();
            BatchSuppression_Logs batchObj = new BatchSuppression_Logs();
            DataBase.executeBatch(batchObj);
            Test.stopTest();
        }
    }
    
}