/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Sh
* @date: 02/04/2021
* @details : Test Class for AP01_ObjectShare
*
*********************************************************************************************************************************************************************/
@isTest (SeeAllData=false)
public class AP01_ObjectShare_Test {
    Public static list<Booking__c> listBookings;
    Public static list<Case>       caseList;
    
    private static testMethod void test_createSharewrtBooking(){
        User usr = createUser();
        Insert usr;
        System.Assert(usr.Id != null);

        System.runas(usr){
            createRecords();
            Test.startTest();
                Insert listBookings;
            Test.StopTest();
        }
    }

    private static testMethod void test_createSharewrtCase(){
        User usr = createUser();
        Insert usr;
        System.Assert(usr.Id != null);

        UtilsBypass.SKIP_METHOD_MAP.put('CreatePersonAccount', 'objectShareTest');
        UtilsBypass.SKIP_APEXCLASS_MAP.put('AP01_Case', 'objectShareTest');

        System.runas(usr){
            createRecords();
            Test.startTest();
                Insert caseList;
            Test.StopTest();
        }
    }
    
    private static testMethod void test_Batch_ObjectShareCatchUp_Booking(){
        User usr = createUser();
        Insert usr;
        System.Assert(usr.Id != null);

        System.runas(usr){
            createRecords();
            Insert listBookings;

            Test.startTest();
                String query ='SELECT id,Hotel__r.Country_code__c, Bucket_of_booking__c '+
                                'FROM Booking__c '+                             
                                'LIMIT 200';

                Batch_ObjectShareCatchUp batchLaunch = new Batch_ObjectShareCatchUp(query,'Booking__c','Booking__c');
                database.executebatch(batchLaunch,200);  
            Test.StopTest();
        }
    }

    private static testMethod void test_Batch_ObjectShareCatchUp_Account(){
        User usr = createUser();
        Insert usr;
        System.Assert(usr.Id != null);

        System.runas(usr){
            createRecords();
            Insert listBookings;

            Test.startTest();
                String query ='SELECT id,Hotel__r.Country_code__c, Bucket_of_booking__c,Personnal_Account__c '+
                                'FROM Booking__c '+                             
                                'LIMIT 200';

                Batch_ObjectShareCatchUp batchLaunch = new Batch_ObjectShareCatchUp(query,'Booking__c','Account');
                database.executebatch(batchLaunch,200);  
            Test.StopTest();
        }
    }

    private static testMethod void test_Batch_ObjectShareCatchUp_caseAccount(){
        User usr = createUser();
        Insert usr;
        System.Assert(usr.Id != null);

        UtilsBypass.SKIP_METHOD_MAP.put('CreatePersonAccount', 'objectShareTest');
        UtilsBypass.SKIP_APEXCLASS_MAP.put('AP01_Case', 'objectShareTest');
        
        System.runas(usr){
            createRecords();
            Insert caseList;

            Test.startTest();
                String query ='SELECT CaseNumber, Concerned_country__c, Hotel__r.Country_code__c, AccountId '+
                                'FROM Case '+                             
                                'LIMIT 200';

                Batch_ObjectShareCatchUp batchLaunch = new Batch_ObjectShareCatchUp(query,'Case','Account');
                database.executebatch(batchLaunch,200);  
            Test.StopTest();
        }
    }

    private static void createRecords(){
    
        //Create User Role
        UserRole r = new UserRole(DeveloperName = 'testFrance', Name = 'testFrance');
        Insert r;
        
        Id PARTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        listBookings = new list<Booking__c>();
        list<account> listPAAccounts = new list<Account>();
        list<Hotel__c> listHotels = new list<Hotel__c>();
        
        Hotel__c testHotelFR = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelfr',Hotel_ID__c='2343', Country_code__c = 'FR');
        listHotels.add(testHotelFR);
        Hotel__c testHotelFR2 = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelfr2',Hotel_ID__c='2344', Country_code__c = 'FR');
        listHotels.add(testHotelFR2);
        Hotel__c testHotelDE = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelde',Hotel_ID__c='23431', Country_code__c = 'DE');
        listHotels.add(testHotelDE);
        Hotel__c testHotelAT = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelat',Hotel_ID__c='23432', Country_code__c = 'AT');
        listHotels.add(testHotelAT);
        Hotel__c testHotelPL = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelpl',Hotel_ID__c='23433', Country_code__c = 'PL');
        listHotels.add(testHotelPL);
        Hotel__c testHotelIT = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelit',Hotel_ID__c='23435', Country_code__c = 'IT');
        listHotels.add(testHotelIT);
        Hotel__c testHotelES = new Hotel__c(Commercial_Hotel_Name__c = 'test hoteles',Hotel_ID__c='23436', Country_code__c = 'ES');
        listHotels.add(testHotelES);
        Hotel__c testHotelOther = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelother',Hotel_ID__c='23437', Country_code__c = 'LB');
        listHotels.add(testHotelOther);
        
        Insert listHotels;
        
        for(integer i = 0; i<8; i++){
            
            string name = 'Person'+i;
            string extId = 'paExtId'+i;
            Account personAccount =  Utils.CreatePersonAccount(name, null);
            personAccount.recordtypeId = PARTId;
            personAccount.Externalid__pc = extId;
            listPAAccounts.add(personAccount);
        }
        
        Insert listPAAccounts;
        
        Buket_of_booking__c bucketBook = new Buket_of_booking__c();
        bucketBook.EXTERNALID__c = 'BUKBook1';
        Insert bucketBook;
        
        for(integer i = 0; i<8; i++){
            
            string extId = 'bookExtId'+i;
            Booking__c book = new Booking__c();
            book.Bucket_of_booking__c = bucketBook.Id;
            book.EXTERNALID__c = extId;
            book.Personnal_Account__c = listPAAccounts[i].Id;
            book.Hotel__c = listHotels[i].Id;
            book.stage__c = 'Booked';
            listBookings.add(book);
        } 
        
        
        caseList = New List<Case>();
        for(integer i = 0; i<8; i++){    
            Case cas = Utils.CreateCase();            
            cas.AccountId = listPAAccounts[i].Id;
            cas.Type = label.Information_request;
            cas.Salesforce_Case_Type__c = 'General request';
            cas.Status = 'Open';           
            cas.Hotel_ID__c = listHotels[i].Id;
            cas.SuppliedEmail = 'customerTest@asce.com';
            cas.First_Name__c = 'First' + i;
            cas.Last_Name__c = 'Last' + i;
            cas.Concerned_country__c = 'FR';
            //cas.setOptions(dmo);
            caseList.add(cas);
        }
        
    }
    
    private static User createUser(){          
        Id standardUserProfileID = [SELECT ID, Name FROM Profile WHERE Name='System Administrator'].ID;

        User usr = New User(  FirstName              = 'Admin Test' , 
                              LastName               = 'Admin' ,  
                              alias                  = 'AjdoeT' , 
                              email                  = 'Adminjdoe@bbtest.com', 
                              username               = 'AdminjohnD@testuser.com', 
                              CommunityNickname      = 'AdminDoe032' , 
                              Division               = Label.AP01_MasterVoucher_DivisionCorporate,
                              EmailEncodingKey       = 'UTF-8',
                              // DefaultCurrencyIsoCode = 'EUR', 
                              LocaleSidKey           = 'en_US', 
                              LanguageLocaleKey      = 'en_US',
                              TimeZoneSidKey         = 'Europe/Paris', 
                              ProfileID              = standardUserProfileID,
                              Phone                  = '+33 23 45 67 89',
                              BypassValidationRule__c = true,
                              BypassProcessBuilder__c = false,
                              BypassWorkflow__c       = false                             

        ); 
        return usr;     
          
  }


}