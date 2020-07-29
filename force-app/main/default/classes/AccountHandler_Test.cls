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
        User testUser = TestDataFactory.createSingleUser(false);
       // testUser.BypassApex__c = 'UtilsMethodeForAccount';
        Insert testUser ;
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