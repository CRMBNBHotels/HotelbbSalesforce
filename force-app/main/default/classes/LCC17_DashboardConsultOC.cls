/*
* Description: Controller class for LC17_DashboardConsultOC 
* @author: TMA-EI CG
* @date: 22/10/2020
* @Test class: LCC17_DashboardConsultOC_Test
* @Coverage: 100%
* @Lightning Components: LC17_DashboardConsultOC
*/

public without sharing class LCC17_DashboardConsultOC {
    
    @AuraEnabled
    public static ReturnedInfo GetRelatedVouchers(string mvId) {
        
        ReturnedInfo ret = new ReturnedInfo();
        
        ret.listRelatedVouchers = [select Id, Name, Code_OC__c, Statut__c,Tech_Statut__c, Prestation_offerte__c 
                               from Voucher__c
                               where Master_Voucher_OC__c =: mvId];
        
        return ret;
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public List<Voucher__c> listRelatedVouchers;
    }
    
}