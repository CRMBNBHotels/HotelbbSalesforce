/*
* Description: Test class for LCC21_DashboardOCQuotasManagement 
* @author: TMA-EI CG
* @date: 20/11/2020
*/

@isTest
public class LCC21_DashboardOCQuotasManagement_Test {

    @isTest
    public static void GetQuotasTest() {

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
            Id MVcreationId = Schema.SObjectType.Master_Voucher__c.getRecordTypeInfosByDeveloperName().get(Label.MasterVoucher_RT_OnCreation_DevName).getRecordTypeId();
            
            Account comp = Utils.CreatePartnerAccount('CompTest', '121212121212554');
            comp.recordtypeId = compRTId;
            insert comp;
            
            contact employee = Utils.CreateContact('contTest', comp.Id, 'FR');
            employee.recordTypeId = empContRTId;
            employee.Email = testUser.Email;
            insert employee;

            hotel__c hotelTest = new Hotel__c();
            hotelTest.Commercial_Hotel_Name__c = 'test hotel';
            hotelTest.Maximun_invitations__c = 20;
            insert hotelTest;

            Contact_role__c contRole = new Contact_role__c(Contact__c = employee.Id, Role__c = 'IR-OC', Hotel__c = hotelTest.Id);
            insert contRole;
            
            Master_Voucher__c masterVouch = new Master_Voucher__c();
            masterVouch.recordtypeid = MVcreationId;
            masterVouch.Nombre_de_copie_s__c = 2;
            masterVouch.Nom_Pr_nom_client__c = 'testPrenom';
            masterVouch.Offert_l_occasion_de__c = 'testOccasion';
            masterVouch.Prestation_Offerte__c = 'Une nuit en chambre 1-2 personnes';
            masterVouch.Nature_de_la_demande__c = 'Animation';
            masterVouch.P_riode_de_validit__c = 'Du lundi au dimanche';
            insert masterVouch;
          
            test.startTest();
            
            LCC21_DashboardOCQuotasManagement.GetQuotas(testUser.Email);
            
            list<QuotasObject> listQuotas = new list<QuotasObject>();
            
            QuotasObject quotasObj1 = new QuotasObject();
            quotasObj1.hotelId = hotelTest.Id;
            quotasObj1.hotelName = hotelTest.Commercial_Hotel_Name__c;
            quotasObj1.maxInvit = hotelTest.Maximun_invitations__c + 10;
            quotasObj1.currentYear = system.today().year();
            listQuotas.add(quotasObj1);
            
            string editedQuotas = SYSTEM.JSON.serialize(listQuotas);
            
            LCC21_DashboardOCQuotasManagement.updateQuotas(editedQuotas);
            
            test.stopTest();
            
        }
    }
}