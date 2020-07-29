/*
* Description: Test class for BatchReprise_VoucherOpco
* @author: TMA-EIL Cynthia Geagea
* @date: 16/03/2020
*/

@isTest
public class BatchReprise_VoucherOpco_Test {
    
    @isTest
    static void batchVouchOpcoTest(){
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User userTest = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = prof.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        
        userTest.BypassValidationRule__c = true;
        userTest.BypassWorkflow__c = true;
        userTest.BypassApex__c = 'AP05_Voucher';
        
        insert userTest;
        
        System.runAs(userTest){
            
            UtilsBypass.SKIP_APEXCLASS_MAP.put('AP05_Voucher','skipClass');
            UtilsBypass.SKIP_METHOD_MAP.put('fillVoucherOpco','skipMethod');
            
            Id Voucher_RT_EClub_Id = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('Eclub_voucher').getRecordTypeId();
            
            Account acc = new Account();
            acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            acc.LastName='testAcc';
            insert acc;
            
            list<hotel__c> listHotels = new list<hotel__c>();
            
            hotel__c hotFR = new hotel__c(Commercial_Hotel_Name__c = 'test hotel1', Hotel_ID__c='2343', country__c = 'FR');
            listHotels.add(hotFR);
            
            hotel__c hotIT = new hotel__c(Commercial_Hotel_Name__c = 'test hotel2', Hotel_ID__c='2345', country__c = 'IT');
            listHotels.add(hotIT);
            
            hotel__c hotES = new hotel__c(Commercial_Hotel_Name__c = 'test hotel3', Hotel_ID__c='2346', country__c = 'ES');
            listHotels.add(hotES);
            
            insert listHotels;
            
            list<Voucher__c> listVouch=  new list<Voucher__c>();
            
            for(integer i = 0; i<50; i++){
                
                Voucher__c vouch = new Voucher__c(Guest_Account__c = acc.Id, recordTypeId = Voucher_RT_EClub_Id, hotel__c = hotFR.Id, Email_du_client__c = 'testVouch1@test.com');
                listVouch.add(vouch);
            }
            
            for(integer i = 0; i<50; i++){
                
                Voucher__c vouch = new Voucher__c(Guest_Account__c = acc.Id, recordTypeId = Voucher_RT_EClub_Id, hotel__c = hotIT.Id, Email_du_client__c = 'testVouch1@test.com');
                listVouch.add(vouch);
            }
            
            for(integer i = 0; i<50; i++){
                
                Voucher__c vouch = new Voucher__c(Guest_Account__c = acc.Id, recordTypeId = Voucher_RT_EClub_Id, hotel__c = hotES.Id, Email_du_client__c = 'testVouch1@test.com');
                listVouch.add(vouch);
            }
            
            insert listVouch;
            
            for(voucher__c vouch : listVouch){
                
                if(vouch.opco__c != null){
                    
                    vouch.opco__c = null;
                }
            }
            
            update listVouch; 
            
            test.startTest();
            
            BatchReprise_VoucherOpco batchobj = new BatchReprise_VoucherOpco();
            database.executeBatch(batchobj);
            
            test.stopTest();
            
        }
    }
}