/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/02/2021
* @details : Test Class for BookingRLHandler
* Test constructeur BookingRLHandler (Event Insert) without byPassLogic
* No need System assert because we have any logic to test
*********************************************************************************************************************************************************************/
@isTest
public class BookingRLHandler_TEST {  
    public static testMethod void testAccountHandlerwithoutByPassLogic() { 
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        testUser.BypassValidationRule__c = true;
        insert testUser;
        System.runAs(testUser) {
            Test.startTest();
            Account personAccount =  Utils.CreatePersonAccount('Person', null);
					personAccount.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
					personAccount.Externalid__pc = 'paExtId';
					insert personAccount;
				
				Hotel__c testHotel = new Hotel__c(Commercial_Hotel_Name__c = 'test hotelother',
													  Hotel_ID__c = '23437',
													  Country_code__c = 'LB');
					insert testHotel;
					
				Buket_of_booking__c bucketBook = new Buket_of_booking__c();
					bucketBook.EXTERNALID__c = 'BUKBook1';
					insert bucketBook;
				
				Booking__c book = new Booking__c();
					book.Bucket_of_booking__c = bucketBook.Id;
					book.EXTERNALID__c = 'bookExtId';
					book.Personnal_Account__c = personAccount.Id;
					book.Hotel__c = testHotel.Id;
					book.Stage__c = 'Booked';
					book.Channel__c = '1';
					insert book;
				
					List<Id> listBooking=new List<Id>();
            	list<Booking_Room_Line_V2__c> listBRL = new list<Booking_Room_Line_V2__c>();
					Booking_Room_Line_V2__c BRL= new Booking_Room_Line_V2__c();
					BRL.Name='BRL36626 - R12';
					BRL.Booking__c=book.id;
					BRL.EXTERNALID__c='569841';
					BRL.Quantity__c=2;
					BRL.Price__c=100;
					BRL.CreatedDate=system.today();
					            
            		Booking_Room_Line_V2__c BRL2= new Booking_Room_Line_V2__c();
					BRL2.Name='BRL36626 - R12';
					BRL2.Booking__c=book.id;
					BRL2.EXTERNALID__c='562241';
					BRL2.Quantity__c=2;
					BRL2.Price__c=100;
					BRL2.CreatedDate=system.today();
					

		   		    listBRL.add(BRL);
            		listBRL.add(BRL2);
            
            		insert listBRL;
            		delete BRL2;
            		update BRL;
            		undelete BRL2;
            Test.stopTest();
        } 
    }
}