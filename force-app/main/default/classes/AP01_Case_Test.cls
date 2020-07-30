/**
* 
* @version 1.00 17/10/2017
* @author Jenny Jawhar
* @CodeCoverage 96%
*/
@isTest
public class AP01_Case_Test 
{
    static testMethod void InsertWebCase()
    {
        String compRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        
        /*Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);    
        PartnerAccount.RecordTypeId = compRecordTypeId;
        insert PartnerAccount;
        
        Account PersonAccount = Utils.CreatePersonAccount('Person', PartnerAccount.Id);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        insert PersonAccount;

        list<Contact> listContactToInsert = new list<Contact>();  
        Contact cont = Utils.CreateContact('ContactTest',PartnerAccount.Id,'FR');
        cont.Email = 'customer@gmail.com';
        listContactToInsert.add(cont);
        Contact cont1 = Utils.CreateContact('ContactTest1', PartnerAccount.Id, 'FR');
        cont1.Email = 'Person@hotmail.com';
        listContactToInsert.add(cont1);
        insert listContactToInsert; */       
        
        Hotel__c hotel = Utils.CreateHotel('Hotel 1');
        hotel.Email__c = 'hotel1@gmail.com';
        hotel.Country__c = Label.AP01_Case_CA;//label.FR;
        insert hotel;
        
         Hotel__c hotel1 = Utils.CreateHotel('Hotel 1');
        hotel1.Email__c = 'hotel1@gmail.com';
        hotel1.Hotel_ID__c = '123456';
        hotel1.Country__c = Label.DE;//label.FR;
        insert hotel1;
        
         Hotel__c hotel2 = Utils.CreateHotel('Hotel 1');
        hotel2.Email__c = 'hotel1@gmail.com';
        hotel2.Country__c = Label.FR;//label.FR;
        hotel2.Hotel_ID__c = '1234567';
        insert hotel2;
        
         Hotel__c hotel3 = Utils.CreateHotel('Hotel 1');
        hotel3.Email__c = 'hotel1@gmail.com';
        hotel3.Country__c = Label.AP01_Case_ES;//label.FR;
        hotel3.Hotel_ID__c = '1234568';
        insert hotel3;
        
         Hotel__c hotel4 = Utils.CreateHotel('Hotel 1');
        hotel4.Email__c = 'hotel1@gmail.com';
        hotel4.Country__c = Label.IT;//label.FR;
        hotel4.Hotel_ID__c = '1234569';
        insert hotel4;
        
        list<Case> listCaseToInsert = new list<Case>();
        
        Case cas = Utils.CreateCase();
        cas.Origin = 'Web';
        cas.Type = label.Information_request;
        cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
        cas.Hotel_ID__c = hotel.Hotel_ID__c;
        cas.SuppliedEmail = 'customer1@gmail.com';
        cas.First_Name__c = 'First1';
        cas.Last_Name__c = 'Last1';
        cas.Concerned_country__c = 'IT';
        listCaseToInsert.add(cas);
        
        Case cas1 = Utils.CreateCase();
        cas1.Origin = 'Web';
        cas1.Type = label.Information_request;
        cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
        cas1.Hotel_ID__c = hotel1.Hotel_ID__c;
        cas1.SuppliedEmail = 'customer@gmail.com';
        cas1.Concerned_country__c = 'FR';
        cas1.First_Name__c = 'First2';
        cas1.Last_Name__c = 'Last2';
        listCaseToInsert.add(cas1);
        
        Case cas2 = Utils.CreateCase();
        cas2.Origin = 'Web';
        cas2.SuppliedEmail = 'Person@hotmail.com';//'Person2@hotmail.com';
        cas.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
        cas1.Hotel_ID__c = hotel2.Hotel_ID__c;
        cas2.First_Name__c = 'First3';
        cas2.Last_Name__c = 'Last3';
        cas2.Concerned_country__c = 'ES';
        listCaseToInsert.add(cas2); 
        
        Case cas3 = Utils.CreateCase();
        cas3.Origin = 'Web';
        cas3.SuppliedEmail = 'Personn@hotmail.com';//'Person2@hotmail.com';
        cas3.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
        cas3.Hotel_ID__c = hotel3.Hotel_ID__c;
        cas3.First_Name__c = 'First3';
        cas3.Last_Name__c = 'Last3';
        cas3.Concerned_country__c = 'ES';
        listCaseToInsert.add(cas3); 
        
        Case cas4 = Utils.CreateCase();
        cas4.Origin = 'Web';
        cas4.SuppliedEmail = 'Personnn@hotmail.com';//'Person2@hotmail.com';
        cas4.RecordTypeId = Label.Case_RT_CustomersRequestFeedback;
        cas4.Hotel_ID__c = hotel4.Hotel_ID__c;
        cas4.First_Name__c = 'First3';
        cas4.Last_Name__c = 'Last3';
        cas4.Concerned_country__c = 'ES';
        listCaseToInsert.add(cas4); 
        
        Case cas5 = Utils.CreateCase();
        cas5.Origin = 'Web';
        cas5.SuppliedEmail = 'Personnn2@hotmail.com';//'Person2@hotmail.com';
        cas5.RecordTypeId = Label.Case_RT_CustomersRequestFeedback_ES_PT;
        cas5.Hotel_ID__c = hotel4.Hotel_ID__c;
        cas5.First_Name__c = 'First3';
        cas5.Last_Name__c = 'Last3';
        cas5.Concerned_country__c = 'PT';
        cas5.type = 'Information request';
        cas5.Description = 'testing';
        listCaseToInsert.add(cas5); 
        
        insert listCaseToInsert;
        
        list<Contact> listCon = [Select Id
                                 From Contact
                                 Where Email =: cas1.SuppliedEmail];
        //system.assertEquals(2, listCon.size());
        Case updatedCase = [Select Hotel__c 
                            From Case
                            Where Id =: cas.Id];
        //system.assertEquals(hotel.Id,updatedCase.Hotel__c);
    }
}