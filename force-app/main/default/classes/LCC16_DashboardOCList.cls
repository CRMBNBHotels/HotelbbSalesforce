/*
* Description: Controller class for LC16_DashboardOClist 
* @author: TMA-EI CG
* @date: 22/10/2020
* @Test class: LCC16_DashboardOCList_Test
* @Coverage: 100%
* @Lightning Components: LC16_DashboardOClist
*/

public with sharing class LCC16_DashboardOCList {
    
    @AuraEnabled
    public static ReturnedInfo GetMasterVouchers() {
        
        ReturnedInfo ret = new ReturnedInfo();
        
        ret.listMasterVouch = [select Id, Name, Prestation_Offerte__c, Dur_e_de_validit__c, Nombre_de_copie_s__c, Tech_CreatedDate__c, CreatedDate, Nom_Pr_nom_client__c,Pr_nom_Nom_de_l_m_tteur__c,
                               Pr_nom_Nom_de_l_m_tteur__r.Name 
                               from Master_Voucher__c
                               order by CreatedDate Desc];
        
        return ret;
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public List<Master_voucher__c> listMasterVouch;
    }
}