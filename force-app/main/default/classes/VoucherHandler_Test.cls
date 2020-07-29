/** 
* Test class for the VoucherHandler Apex Class
* @author JKA 
* @version 0.1
* @date 24/01/2020 
*/
@isTest
public class VoucherHandler_Test {
 @isTest
    public static void testVoucherHandler()
    {
         //Insert PA
        Account PersonAccount =  Utils.CreatePersonAccount('Person', null);                      
        insert PersonAccount;
                
        //Create Hotel
        Hotel__c hotel = Utils.CreateHotel('789');
        insert hotel;        
        
        //Insert an IR invitation
        Voucher__c voucher = new Voucher__c();
        Voucher.Guest_Account__c = PersonAccount.id;
        voucher.Types__c = '2003';
        voucher.Objet__c = '3007';
        //voucher.Motif__c = 'Remerciements';
        voucher.Prestation_offerte__c = '6004';
        voucher.Email_du_client__c = 'test@email.com';
        voucher.Service__c = 'Hotel';
        voucher.Hotel__c = hotel.id;
        voucher.Statut__c = 'En attente';
        insert voucher;
        
        voucher.Statut__c = 'Consommé(e)';
        update voucher;
        delete voucher;
        undelete voucher;
    }

}