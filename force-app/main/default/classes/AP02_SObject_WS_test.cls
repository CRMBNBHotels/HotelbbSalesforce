@isTest
public class AP02_SObject_WS_test {
    private static testMethod void UpdateAccount()
    {
        Account PartnerAccount = Utils.CreatePartnerAccount('Partner',null);  
        insert PartnerAccount; 
        Account PersonAccount = Utils.CreatePersonAccount('Person',PartnerAccount.Id);
        PersonAccount.PersonMobilePhone='+33 444';
        PersonAccount.E_Club_Status__c = 'Valid';
        PersonAccount.E_club_Expiration_date__pc = date.today().adddays(-3);
        insert PersonAccount;
        PersonAccount.E_Club_Status__c = 'Valid';
        PersonAccount.FirstName = 'test name update';
        PersonAccount.lastname = 'test name update';
        //PersonAccount.Email__pc = 'Email@testUpdate.com';
        //PersonAccount.E_mail_address_2__pc = 'Email@testUpdate.com';
        PersonAccount.PersonMobilePhone = '+33 123';
        PersonAccount.Mobile_Phone_Number_2__pc = '+33 123';
        PersonAccount.PersonMailingCity = 'GUIPAVAS';
        PersonAccount.E_Club_Status__c = 'Valid';
        PersonAccount.E_club_Expiration_date__pc = date.today();
        PersonAccount.PersonMailingCountry = 'France';
        //PersonAccount.PersonMailingState = 'Nouvelle-Aquitaine';
        PersonAccount.PersonMailingPostalCode = '29490';
        PersonAccount.PersonMailingStreet = '75 rue Jansen';
        update PersonAccount;
        map<String ,sobject> mapobj = new map<String ,sobject>();
        mapobj.put(PersonAccount.id,PersonAccount);
        //NAT to raise code coverage
        Map<String,String> mapType = new Map<String,String>();
        mapType.put(PersonAccount.id,'Person Account');
        Map<String,Integer> mapNBPT = new Map<String,Integer>();
        mapNBPT.put(PersonAccount.id,1000);
        //NAT END
        Set<String> setfields = new set<String>();
        setfields.add('PersonMailingCity');
         setfields.add('PersonMobilePhone');
         setfields.add('E_Club_Status__c');
         setfields.add('E_club_Expiration_date__pc');
         setfields.add('FirstName');
        map<String,String> mapjson = AP02_SObject_WS.Serialize(mapobj,mapType,mapNBPT);
        map<String, ap02_sobject_ws.SerializeObject> mapserOb = ap02_sobject_ws.Deserialize(mapjson);
        map<Id,Map<String,String>> mapIdJson = ap02_sobject_ws.GetFieldAndValueMap(mapserOb);
        Sobject sobj = PersonAccount;
        Sobject acc = ap02_sobject_ws.SetFieldAndValue(sobj,setfields);
        
    }
}