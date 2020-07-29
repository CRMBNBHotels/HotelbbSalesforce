@isTest
public class AP03_voucher_test {
    @isTest
    public static void tech_data_check()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        // testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){
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
            voucher.Motif__c = 'Remerciements';
            //voucher.Prestation_offerte__c = '6004';
            voucher.Prestation_offerte__c = 'Un petit déjeuner';
            voucher.Email_du_client__c = 'test@email.com';
            voucher.Service__c = 'Hotel';
            voucher.Hotel__c = hotel.id;
            voucher.Statut__c = 'En attente';
            insert voucher;
            
            voucher.Statut__c = 'Consommé(e)';
            update voucher;
            //added
            delete voucher;
            undelete voucher;
        }
    }
}