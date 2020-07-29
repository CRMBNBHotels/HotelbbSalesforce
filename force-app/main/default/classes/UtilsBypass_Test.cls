/** 
 * Test class for the UtilsBypass Apex Class
 * @author  Omar Bensouda o.bensouda@obkconsulting.com
 * @version 0.1
 * @date 11/12/2019 
 */

@isTest
private class UtilsBypass_Test {

    /**
    * Test get Current User
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testgetCurrentUser() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            User currentUser = UtilsBypass.getCurrentUser();
            Boolean temp = false;
            if(currentUser.Name != '' && currentUser.Name != null){
              temp = true;  
            }
            System.assert(temp);
            Test.stopTest(); 
        } 
    }

    /**
    * Test set Current User
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testSetCurrentUserParameter(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.setCurrentUserParameter(testUser);
            System.assertEquals(testUser.ID,UtilsBypass.currentUser.ID); 
            Test.stopTest(); 
        }
    }

    /**
    * Test get User Bypass ApexClass
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testGetUserBypassApexClass(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            String temp = UtilsBypass.getUserBypassApexClass();
            System.assertEquals(null,temp);  
            Test.stopTest(); 
        } 
    }

    /**
    * Test get User Bypass Validation Rules
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testGetUserBypassVR(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            Boolean temp = UtilsBypass.getUserBypassVR();
            System.assertEquals(false,temp);  
            Test.stopTest(); 
        } 
    }

    /**
    * Test get User Bypass Workflow Rules
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testGetUserBypassWF(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            Boolean temp = UtilsBypass.getUserBypassWF();
            System.assertEquals(false,temp); 
            Test.stopTest(); 
        } 
    }

    /**
    * Test get User Bypass Process builder
    * @author: Omar Bensouda Korachi 
    */
    public static testMethod void testGetUserBypassPB(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            Boolean temp = UtilsBypass.getUserBypassPB();
            System.assertEquals(false,temp);
            Test.stopTest(); 
        } 
    }

    /**
    * Test can Bypass Trigger 
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testCanbyPassTrigger(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.SKIP_APEXTRIGGER_MAP.put('AcccountTrigger','TestClass');
            Boolean temp = UtilsBypass.canbyPassTrigger('AcccountTrigger');
            System.assertEquals(true,temp); 
            Test.stopTest(); 
        } 
    }
    
    /**
    * Test can not Bypass Trigger 
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testCanbyPassTrigger2(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.setexecuteOnceApexClass('AccountTrigger');
            Boolean temp = UtilsBypass.canbyPassTrigger('AccountTrigger');
            System.assertEquals(False,temp); 
            Test.stopTest(); 
        } 
    }
    
    /**
    * Test can not Bypass Trigger 
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testCanbyPassTrigger3(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.setnotBypassedTriggers('AccountTrigger');
            Boolean temp = UtilsBypass.canbyPassTrigger('AccountTrigger');
            System.assertEquals(false,temp); 
            Test.stopTest(); 
        } 
    }
	
    /**
    * Test set not Bypassed Triggers
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testSetnotBypassedTriggers(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.setnotBypassedTriggers('AP01_Test');
            System.assert(UtilsBypass.notBypassedTriggers.contains('AP01_Test')); 
            Test.stopTest(); 
        } 
    }

    /**
    * Test Set execute Once Apex Class
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testSetexecuteOnceApexClass(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.setexecuteOnceApexClass('AP01_Test');
            System.assert(UtilsBypass.executeOnceApexClass.contains('AP01_Test')); 
            System.assert(UtilsBypass.hasBeenExecutedApexClass.contains('AP01_Test')); 
            Test.stopTest(); 
        } 
    }
    
    /**
    * Test Set execute Once Trigger
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testSetexecuteOnceTrigger(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.setexecuteOnceTrigger('AccountTrigger');
            System.assert(UtilsBypass.executeOnceTrigger.contains('AccountTrigger')); 
            System.assert(UtilsBypass.hasBeenExecutedTrigger.contains('AccountTrigger'));  
            Test.stopTest(); 
        } 
    }

    /**
    * Test Add Skip Apex Method
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void testAddSkipApexMethod(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.addSkipApexMethod('getHotelName_Test','testClass');
            System.assertEquals('testClass', UtilsBypass.SKIP_METHOD_MAP.get('getHotelName_Test')); 
            Test.stopTest(); 
        } 
    }
    
    /**
    *   Test Add Skip Apex Class
    *   @author: Omar Bensouda Korachi
    */
    public static testMethod void testAddSkipApexClass(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.addSkipApexClass('AccountTrigger','testClass');
            System.assertEquals('testClass', UtilsBypass.SKIP_APEXCLASS_MAP.get('AccountTrigger')); 
            Test.stopTest(); 
        } 
    }
    
    /**
    *   Test GET: Use to bypass a Methode in the code 
    *   @author: Omar Bensouda Korachi
    */
    public static testMethod void TestcanISkipApexMethod(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.addSkipApexMethod('getBBHClub','testClass');
            System.assertEquals(True, UtilsBypass.canISkipApexMethod('getBBHClub')); 
            Test.stopTest(); 
        } 
    }
    
    /**
    * Test GET: Use to bypass a Class in the code 
    * @author: Omar Bensouda Korachi
    */
    public static testMethod void TestcanISkipApexClass(){
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            UtilsBypass.addSkipApexClass('UtilsClass','testClass');
            System.assertEquals(True, UtilsBypass.canISkipApexClass('UtilsClass'));
            Test.stopTest(); 
        } 
    }
}