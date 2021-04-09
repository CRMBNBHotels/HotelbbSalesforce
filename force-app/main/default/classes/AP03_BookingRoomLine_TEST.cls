/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/02/2021
* @details : Test Class for AP03_BookingRoomLine
*
*********************************************************************************************************************************************************************/
@isTest (SeeAllData=false)
public class AP03_BookingRoomLine_TEST {   
    private static testMethod void DeleteBookingRL_Test(){
        
			User usr = createUser();
			insert usr;
			System.Assert(usr.Id != null);

			System.runas(usr){
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
				
				List<Id> listBookingId=new List<Id>();
					Booking_Room_Line_V2__c BRL= new Booking_Room_Line_V2__c();
					BRL.Name='BRL36626 - R12';
					BRL.Booking__c=book.id;
					BRL.EXTERNALID__c='569841';
					BRL.Quantity__c=2;
					BRL.Price__c=100;
					BRL.CreatedDate=system.today();
					insert BRL;
		   
			    listBookingId.add(BRL.Booking__c);
					
				test.startTest(); 
					AP03_BookingRoomLine.DeleteBookingRoomLines(listBookingId);
			    test.stopTest();
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