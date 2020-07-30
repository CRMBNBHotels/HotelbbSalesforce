/** 
 * Test class for the Utils Methode For Account Apex Class
 * @author  Omar Bensouda o.bensouda@obkconsulting.com
 * @version 0.1
 * @date 11/12/2019 
 */

@isTest
private class UtilsMethodeForAccount_Test {
	/**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountry() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(10);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = UtilsMethodeForAccount_Test.randomValueforCreationChannel();
            }
            insert temp;
            
            for(Account currentAccount : [Select id, E_club_country_code__c  From Account] ){
               system.assertEquals(currentAccount.E_club_country_code__c,'EA'); 
            }
            Test.stopTest(); 
        } 
    }
    /**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountryForHotelName() {    
        User testUser = TestDataFactory.createSingleUser(true);
        List<Hotel__c> listOfHotel = TestDataFactory.createHotels(1);
        insert listOfHotel;
        System.runAs(testUser) {
            Test.startTest();
            
            List<Account> temp = TestDataFactory.createGuestAccounts(1);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = 'Dashboard';
                temp.get(i).Email__pc ='tototata'+i+'@yopmail.fr';
                temp.get(i).PersonMobilePhone ='+39 234234234';
                temp.get(i).PersonMailingCountry='Germany';
                temp.get(i).Language__pc='ES';
                temp.get(i).Hotelid_club_subscription__c = 'hotel_'+(i+1);
            }
            insert temp;
            for(Account currentAccount : [Select id, E_club_country_code__c,Hotel_Name__c  From Account] ){
                system.assertEquals(currentAccount.E_club_country_code__c,'FR'); 
            }
            Test.stopTest(); 
        } 
    }
    /**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountryForMarketing() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(10);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = UtilsMethodeForAccount_Test.randomValueforCreationChannel();
                temp.get(i).Email__pc ='tototata'+i+'@yopmail.fr';
                temp.get(i).PersonMobilePhone ='+39 234234234';
                temp.get(i).PersonMailingCountry='Germany';
                temp.get(i).Language__pc='ES';
                temp.get(i).Booking_France__c = 80;
            }
            insert temp;
            
            for(Account currentAccount : [Select id, E_club_country_code__c  From Account] ){
               system.assertEquals(currentAccount.E_club_country_code__c,'FR'); 
            }
            Test.stopTest(); 
        } 
    }
     /**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountryForLangue() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(10);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = UtilsMethodeForAccount_Test.randomValueforCreationChannel();
                temp.get(i).Email__pc ='tototata'+i+'@yopmail.fr';
                temp.get(i).PersonMobilePhone ='+39 234234234';
                temp.get(i).PersonMailingCountry='Germany';
                temp.get(i).Language__pc='ES';
                
            }
            insert temp;
            
            for(Account currentAccount : [Select id, E_club_country_code__c  From Account] ){
               system.assertEquals(currentAccount.E_club_country_code__c,'ES'); 
            }
            Test.stopTest(); 
        } 
    }
    /**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountryForCountry() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(10);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = UtilsMethodeForAccount_Test.randomValueforCreationChannel();
                temp.get(i).Email__pc ='tototata'+i+'@yopmail.fr';
                temp.get(i).PersonMobilePhone ='+39 234234234';
                temp.get(i).PersonMailingCountry='Germany';
            }
            insert temp;
            
            for(Account currentAccount : [Select id, E_club_country_code__c  From Account] ){
               system.assertEquals(currentAccount.E_club_country_code__c,'DE'); 
            }
            Test.stopTest(); 
        } 
    }
   	/**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountryForPhone() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(10);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = UtilsMethodeForAccount_Test.randomValueforCreationChannel();
                temp.get(i).Email__pc ='tototata'+i+'@yopmail.fr';
                temp.get(i).PersonMobilePhone ='+39 234234234';
            }
            insert temp;
            
            for(Account currentAccount : [Select id, E_club_country_code__c  From Account] ){
               system.assertEquals(currentAccount.E_club_country_code__c,'IT'); 
            }
            Test.stopTest(); 
        } 
    }
    /**
    * Test BBH Club Subscription Country with E_club_subscription__pc == true
    *  E_club_Creation_channel__pc != null and Marketing country = Bu France
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testBBHClubSubscriptionCountryForEmail() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.debug('@@: '+[select id from Account_Setting__mdt]);
        System.runAs(testUser) {
            Test.startTest();
            List<Account> temp = TestDataFactory.createGuestAccounts(10);
            for(Integer i =0 ; i <temp.size();i++){
                temp.get(i).E_club_subscription__pc = true;
        		temp.get(i).E_club_Creation_channel__pc = UtilsMethodeForAccount_Test.randomValueforCreationChannel();
                temp.get(i).Email__pc ='tototata'+i+'@yopmail.fr';
            }
            insert temp;
            //random number 
            for(Account currentAccount : [Select id, E_club_country_code__c  From Account] ){
               system.assertEquals(currentAccount.E_club_country_code__c,'FR'); 
            }
            Test.stopTest(); 
        } 
    }
    /**
    * Test Extract Domain From Email Adresse
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testExtractDomainFromEmailAdresse() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            String temp = UtilsMethodeForAccount.extractDomainFromEmailAdresse('boba@yopmail.fr');
            system.assertEquals('fr',temp);
            Test.stopTest(); 
        } 
    }
    /**
    * Test Extract Domain From Email Adresse equal to null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testExtractDomainFromEmailAdresseEqualToNull() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            String temp = UtilsMethodeForAccount.extractDomainFromEmailAdresse('');
            system.assertEquals(null,temp);
            Test.stopTest(); 
        } 
    }
    /**
    * Test Extract Indicative From The Phone
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testExtractIndicativeFromThePhone() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            String temp = UtilsMethodeForAccount.extractIndicativeFromThePhone('+33 690980451');
            system.assertEquals('33',temp);
            Test.stopTest(); 
        } 
    }
   	/**
    * Test Extract Indicative From The Phone with param equal to null
    * @author: Omar Bensouda Korachi
    */   
    public static testMethod void testExtractIndicativeFromThePhoneEqualToNull() {    
        User testUser = TestDataFactory.createSingleUser(true);
        System.runAs(testUser) {
            Test.startTest();
            String temp = UtilsMethodeForAccount.extractIndicativeFromThePhone('');
            system.assertEquals(null,temp);
            Test.stopTest(); 
        } 
    }
    public static string randomValueforCreationChannel(){
        // Generate the set
        Set<String> setArray = new Set<String> {'Dashboard', 'App', 'WEB', ''};
        // Create a random index
        Double randomNumber = Math.random();
        Integer arraySize = setArray.size();
        Integer randomIndex = (randomNumber *(arraySize-1)).intValue();
        // Loop through the Set until you get to the element.
        String rStr;
        for (String str : setArray)
        {
            if (randomIndex == 0)
            {
            	rStr= str;    
                break;
            }
            randomIndex--;
        }
        return rStr;
    }
}