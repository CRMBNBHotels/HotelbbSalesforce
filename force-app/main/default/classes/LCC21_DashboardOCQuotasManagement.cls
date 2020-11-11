/*
* Description: Controller class for LC21_DashboardOCQuotasManagement 
* @author: TMA-EI CG
* @date: 22/10/2020
* @Test class: LCC21_DashboardOCQuotasManagement_Test
* @Coverage: 100%
* @Lightning Components: LC21_DashboardOCQuotasManagement
*/

public without sharing class LCC21_DashboardOCQuotasManagement {

    @AuraEnabled
    public static ReturnedInfo GetQuotas() {

        ret.listContRole = [select Id, Role__c, Maximun_invitations__c, Hotel__r.Commercial_Hotel_Name__c, Contact__c, Contact__r.Name, contact__r.Email, CreatedDate 
                               from Contact_Role__c
                               order by CreatedDate Desc];
        
        return ret;

    }

    public class ReturnedInfo{
        
        @AuraEnabled public List<Contact_Role__c> listContRole;
    }
}
