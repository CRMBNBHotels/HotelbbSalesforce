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
    public static ReturnedInfo GetQuotas(string userEmail) {
        
        ReturnedInfo ret = new ReturnedInfo();
        
        list<Contact_Role__c> listRegion = new list<Contact_Role__c>([Select Id, Role__c, Contact__r.Email, hotel__r.Region_DR__c From Contact_Role__c Where Contact__r.Email =: userEmail Limit 1]);
        
        if(listRegion != null && listRegion.size()>0){
            
            if(listRegion[0].Role__c == 'SRC'){
                
                ret.listContRole = [select Id, Role__c, Maximun_invitations__c, Contact__c, Contact__r.Email, Tech_ContactName__c, Tech_HotelName__c, Tech_CurrentYear__c, CreatedDate, hotel__r.Region_DR__c
                                    from Contact_Role__c
                                    order by CreatedDate Desc];
            }
            else if(listRegion[0].Role__c == 'DR'){
                
                ret.listContRole = [select Id, Role__c, Maximun_invitations__c, Contact__c, Contact__r.Email, Tech_ContactName__c, Tech_HotelName__c, Tech_CurrentYear__c, CreatedDate, hotel__r.Region_DR__c
                                    from Contact_Role__c
                                    where hotel__r.Region_DR__c = 'FR'
                                    order by CreatedDate Desc];
            }
            
        }
        
        return ret;
        
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public List<Contact_Role__c> listContRole;
    }
    
    @AuraEnabled
    public static boolean updateQuotas(List<Contact_Role__c> listEditedQuotas){
        try{
            update listEditedQuotas;
            return true;
        } catch(Exception e){
            return false;
        }
    }
}