/*
* Description: Controller class for LC18_DashboardConsultVoucherOC 
* @author: TMA-EI CG
* @date: 01/12/2020
* @Test class: LCC18_DashboardConsultVoucherOC_Test
* @Coverage: 100%
* @Lightning Components: LC18_DashboardConsultVoucherOC
*/

public without sharing class LCC18_DashboardConsultVoucherOC {
    
    @AuraEnabled
    public static ReturnedInfo GetVoucherOC(string codeVouch) {
        
        ReturnedInfo ret = new ReturnedInfo();
        
        list<Voucher__c> listReturnedVoucher = new list<Voucher__c>([SELECT Id, Code_OC__c, Master_Voucher_OC__c  
                                                                     FROM Voucher__c
                                                                     WHERE Code_OC__c =: codeVouch
                                                                     LIMIT 1]);
        
        if(listReturnedVoucher != null && listReturnedVoucher.size()>0){
            
            ret.voucherOCSFID = listReturnedVoucher[0].Id;
            ret.parentMVOCSFID = listReturnedVoucher[0].Master_Voucher_OC__c;
        }
        
        return ret;
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public Id voucherOCSFID;
        @AuraEnabled public Id parentMVOCSFID;
    }
    
}