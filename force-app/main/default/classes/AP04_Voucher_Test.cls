/*
* Description: Test Class for AP04_Voucher 
* @author: TMA-EI JKA
* @date: 14/10/2019
*/

@isTest
public class AP04_Voucher_Test {
    
    @isTest
    public static void CalculateVoucher(){
        
        Id Voucher_RT_IR_Id = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
        Id Case_RT_Case_linked_to_IR_Id = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Case_linked_to_IR').getRecordTypeId();
        
        Account acc1=new Account();
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.LastName='test';
        insert acc1;
        
        Case case1 = new Case(Status = 'Open', RecordTypeId=Case_RT_Case_linked_to_IR_Id);
        insert case1;
        
        
        list<Voucher__c> listVouch=  new list<Voucher__c>();
        
        Voucher__c vouch1 = new Voucher__c(Guest_Account__c=acc1.Id, recordTypeId = Voucher_RT_IR_Id,Email_du_client__c='testVouch1@test.com');
        listVouch.add(vouch1);
        
        Voucher__c vouch2 = new Voucher__c( Guest_Account__c=acc1.Id, recordTypeId = Voucher_RT_IR_Id,Email_du_client__c='testVouch2@test.com');
        listVouch.add(vouch2);
        
        Voucher__c vouch3 = new Voucher__c(Guest_Account__c=acc1.Id, recordTypeId = Voucher_RT_IR_Id, Email_du_client__c='testVouch3@test.com');
        listVouch.add(vouch3);
        
        Voucher__c vouch4 = new Voucher__c(Guest_Account__c=acc1.Id, recordTypeId = Voucher_RT_IR_Id,Email_du_client__c='testVouch4@test.com');
        vouch4.Demande_d_assistance__c = case1.Id;
        listVouch.add(vouch4);
        
        test.startTest();
        
        Database.insert(listVouch, false);
        
        vouch2.Demande_d_assistance__c=case1.Id;
        Database.update(listVouch, false);
        
        Database.delete(vouch4, false);
        
        test.stopTest();
        
    }
}