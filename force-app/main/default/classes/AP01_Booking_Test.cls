/*
* Description: Test Class for AP01_Booking 
* @author: TMA-EIT CG
* @date: 24/11/2020
*/

@isTest
public with sharing class AP01_Booking_Test {

    @isTest
    public static void updatePAMarketingFieldsTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,division = Label.AP01_MasterVoucher_DivisionCorporate, FirstName = 'user',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        // testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){

            Id PARTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

            list<Booking__c> listBookings = new list<Booking__c>();
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
            
            insert listHotels;

            for(integer i = 0; i<8; i++){

                string name = 'Person'+i;
                string extId = 'paExtId'+i;
                Account personAccount =  Utils.CreatePersonAccount(name, null);
                personAccount.recordtypeId = PARTId;
                personAccount.Externalid__pc = extId;
                listPAAccounts.add(personAccount);
            }
            
            insert listPAAccounts;

            Buket_of_booking__c bucketBook = new Buket_of_booking__c();
            bucketBook.EXTERNALID__c = 'BUKBook1';
            insert bucketBook;

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

            Test.startTest();
            
            insert listBookings;
            
            listBookings[2].Hotel__c = listHotels[3].Id;
            Update listBookings;
            Test.StopTest();

        }
    }
}