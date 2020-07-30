/** 
 * Test class for the Account Handler Apex Class
 * @author  Omar Bensouda o.bensouda@obkconsulting.com
 * @version 0.1
 * @date 11/12/2019 
 */

@isTest
private class AccountHandler_Test {
	/**
    * Test constructeur AccountHandler (Event Insert) without byPassLogic
    * No need System assert because we have any logic to test
    * @author: Omar Bensouda Korachi
    */   
    
    
    public static testMethod void testAccountHandlerwithoutByPassLogic() { 
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        //User testUser = TestDataFactory.createSingleUser(false);
       // testUser.BypassApex__c = 'UtilsMethodeForAccount';
       // Insert testUser ;
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(2);
            insert temp;
            for(Integer i=0; i<temp.size();i++ ){
                temp.get(i).LastName = 'test'+i;
            }
            Update temp;
            Delete temp;
            UnDelete temp;
            Test.stopTest(); 
        } 
    }

}