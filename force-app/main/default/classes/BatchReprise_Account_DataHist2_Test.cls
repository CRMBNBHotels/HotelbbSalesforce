/*
* Description: Test class for BatchReprise_Account
* @author: TMA Cynthia Geagea
* @date: 18/09/2019
*/

@isTest
public class BatchReprise_Account_DataHist2_Test {
    
    @isTest
    static void batchRepriseAccDataHistTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        u.BypassValidationRule__c = true;
        insert u;
        
        System.runAs(u){
            
            Id GuestAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.PersonAccountDeveloperName).getRecordTypeId();
            Id CompanyAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            Id bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
            
            Account account = new Account(Name = 'TestAccount', RecordTypeId = CompanyAccountRTId, BillingCountry = 'Algeria', BillingPostalCode='1');
            insert account;
            
            Opportunity book = new Opportunity(Name = 'Booking', CloseDate = date.today(), StageName = 'Cancelled', RecordTypeId = bookingRTId, Booking_Person_account__c = account.Id);
            insert book;
            
            List<Account> listAcc = new List<Account>();
            
            For(Integer i = 0; i<100; i++){
                
                String lstName = 'TestPersonEmailNull'+i;
                Account acc = Utils.CreatePersonAccount(lstName, account.Id);
                listAcc.add(acc);
            }
            
            insert listAcc;
            
            for(account acc : listAcc){
                
                acc.Data_History__c = '{&quot;totalRevenue&quot;:462.00,&quot;totalNights&quot;:8,&quot;mapBookingRevenue&quot;:{&quot;0061v00000Y00mcAAB&quot;:{&quot;year&quot;:2019,&quot;bookingRevenue&quot;:231.00,&quot;bookingId&quot;:&quot;0061v00000Y00mcAAB&quot;},&quot;0061v00000Y00maAAB&quot;:{&quot;year&quot;:2019,&quot;bookingRevenue&quot;:0,&quot;bookingId&quot;:&quot;0061v00000Y00maAAB&quot;},&quot;0061v00000Y00mYAAR&quot;:{&quot;year&quot;:2019,&quot;bookingRevenue&quot;:231.00,&quot;bookingId&quot;:&quot;0061v00000Y00mYAAR&quot;}},&quot;mapBookingNight&quot;:{&quot;0061v00000Y00mcAAB&quot;:{&quot;year&quot;:2019,&quot;nbrNights&quot;:4,&quot;bookingId&quot;:&quot;0061v00000Y00mcAAB&quot;},&quot;0061v00000Y00maAAB&quot;:{&quot;year&quot;:2019,&quot;nbrNights&quot;:0,&quot;bookingId&quot;:&quot;0061v00000Y00maAAB&quot;},&quot;0061v00000Y00mYAAR&quot;:{&quot;year&quot;:2019,&quot;nbrNights&quot;:4,&quot;bookingId&quot;:&quot;0061v00000Y00mYAAR&quot;}},&quot;customerType&quot;:{&quot;leisure&quot;:0,&quot;business&quot;:0},&quot;countryPercentage&quot;:{&quot;spain&quot;:2,&quot;poland&quot;:0,&quot;others&quot;:0,&quot;italy&quot;:0,&quot;germany&quot;:0,&quot;france&quot;:0}}';
            }
            
            update listAcc;
            
            Test.startTest();
            BatchReprise_Account_DataHist2 batchObj = new BatchReprise_Account_DataHist2();
            DataBase.executeBatch(batchObj);
            Test.stopTest();
        }
        
    }
    
}