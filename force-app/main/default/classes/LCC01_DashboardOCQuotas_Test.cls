/*
* Description: Test class for LCC01_DashboardOCQuotas 
* @author: TMA-EI CG
* @date: 10/11/2020
*/

@isTest
public class LCC01_DashboardOCQuotas_Test {

    @isTest
    public static void GetRemainingQuotasTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'systadm', Email='systadm@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,division = Label.AP01_MasterVoucher_DivisionCorporate, FirstName = 'user',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='systadm@testorg.com');
        // testUser.BypassValidationRule__c = true;
        insert testUser;
        
        system.runAs(testUser){

            Id empContRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
            Id compRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
            Id paRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            
            Account comp = Utils.CreatePartnerAccount('CompTest', '121212121212554');
            comp.recordtypeId = compRTId;
            insert comp;
            
            Account compteClient = Utils.CreatePersonAccount('compte client test', comp.Id);
            compteClient.Externalid__pc = '12468';
            insert compteClient;

            contact cont = Utils.CreateContact('contTest', comp.Id, 'FR');
            cont.recordTypeId = empContRTId;
            cont.Email = 'contTest@asce.com';
            insert cont;

            hotel__c hotelTest = new Hotel__c();
            hotelTest.Commercial_Hotel_Name__c = 'test hotel';
            insert hotelTest;

            Contact_role__c contRole = new Contact_role__c(Contact__c = cont.Id, Role__c = 'IR-OC', Hotel__c = hotelTest.Id);
            insert contRole;

            LCC01_DashboardOCQuotas.GetRemainingQuotas(cont.Email,12);
            LCC01_DashboardOCQuotas.GetPersonAccount('12468');

        }

    }
}