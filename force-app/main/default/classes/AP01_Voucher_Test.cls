/**
* 
* @version 1.00 14/03/2019
* @author TMA-EI JK
* @CodeCoverage 
*/
@isTest
public class AP01_Voucher_Test {
    public static testMethod void FillInvitationInformationOnCreation_Test()
    {
        //Insert PA
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);                      
        insert PersonAccount;
        
        //Insert Custom settings Data
        InvitationValorisation__c IV = new InvitationValorisation__c();
        IV.name = 'Un petit déjeuner';
        IV.Prestation_offerte__c = 'Un petit déjeuner';
        IV.Valorisation__c = 123;
        insert IV;
        
        //Create Hotel
        Hotel__c hotel = Utils.CreateHotel('789');
        insert hotel;        
        
        //Insert an IR invitation
        Voucher__c voucher = new Voucher__c();
        voucher.RecordTypeId = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get(Label.Voucher_IR_RT_OnCreation_Name).getRecordTypeId();
        Voucher.Guest_Account__c = PersonAccount.id;
        
        voucher.Types__c = '2003';
        voucher.Objet__c = '3007';
        voucher.Motif__c = '4014';

        voucher.Prestation_offerte__c = 'Un petit déjeuner';
        voucher.Email_du_client__c = 'test@email.com';
        voucher.Service__c = 'Hotel';
        voucher.Hotel__c = hotel.id;
        insert voucher;
        
        /*voucher.Statut__c = 'Generated';
update voucher;

voucher.Statut__c = 'Cancelled';
update voucher;

voucher.Statut__c = 'Expired';
update voucher;

voucher.Statut__c = 'Used';
update voucher;*/
        
    }
}