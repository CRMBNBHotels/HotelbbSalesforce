/*
* Description: Test Class for AP05_Voucher 
* @author: TMA-EI CG
* @date: 10/03/2019
*/

@isTest
public class AP05_Voucher_Test {
    
    @isTest
    public static void fillVoucherOpco(){
        
        Id Voucher_RT_IR_Id = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
        
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
        
        Voucher__c vouch1 = new Voucher__c(Guest_Account__c=acc.Id, recordTypeId = Voucher_RT_IR_Id, hotel__c = hotFR.Id, Email_du_client__c='testVouch1@test.com');
        listVouch.add(vouch1);
        
        Voucher__c vouch2 = new Voucher__c(Guest_Account__c=acc.Id, recordTypeId = Voucher_RT_IR_Id, hotel__c = hotIT.Id, Email_du_client__c='testVouch2@test.com');
        listVouch.add(vouch2);
        
        Voucher__c vouch3 = new Voucher__c(Guest_Account__c=acc.Id, recordTypeId = Voucher_RT_IR_Id, hotel__c = hotES.Id, Email_du_client__c='testVouch3@test.com');
        listVouch.add(vouch3);
        
        test.startTest();
        
        insert listVouch;
        
        vouch1.Hotel__c = hotIT.Id;
        update listVouch;
        
        test.stopTest();
    }
}