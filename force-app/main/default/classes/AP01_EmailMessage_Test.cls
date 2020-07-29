@isTest
public class AP01_EmailMessage_Test {
    static testMethod void InsertEmailMessage()
    {
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);      
        insert PartnerAccount;
        
        Account PersonAccount = Utils.CreatePersonAccount('Person', PartnerAccount.Id);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        PersonAccount.PersonEmail = 'Person@hotmail.com';
        insert PersonAccount;
        
        Hotel__c hotel = Utils.CreateHotel('Hotel 1');
        hotel.Email__c = 'hotel1@gmail.com';
        hotel.Country__c = label.FR;
        insert hotel;
        
        
        Case cas1 = Utils.CreateCase();
        cas1.Origin = 'Web';
        cas1.AccountId = PersonAccount.Id;
        cas1.Hotel__c = hotel.Id;
        //cas1.Type = label.Information_request;
        cas1.Hotel_ID__c = hotel.Hotel_ID__c;
        cas1.SuppliedEmail = 'customer@gmail.com';
        cas1.First_Name__c = 'First2';
        cas1.Last_Name__c = 'Last2';
        cas1.Status = 'Waiting Customer';
        Insert cas1;        
        
        
        EmailMessage EmailM = new EmailMessage();
        EmailM.FromAddress = 'hotel1@gmail.com';
        EmailM.ToAddress = 'customer@gmail.com';
        EmailM.ParentId = cas1.Id;
        Insert EmailM;
        
        case cas2 = [select id,Status
                    from case
                    where id =: cas1.Id];
        
        cas2.Status = 'Waiting Hotel';
        update cas2;
        
        EmailMessage EmailM2 = new EmailMessage();
        EmailM2.FromAddress = 'hotel1@gmail.com';
        EmailM2.ToAddress = 'customer@gmail.com';
        EmailM2.ParentId = cas2.Id;
        Insert EmailM2;
    }
}