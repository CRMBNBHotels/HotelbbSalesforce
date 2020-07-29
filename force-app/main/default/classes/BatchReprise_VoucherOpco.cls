/*
* Description: Batch Reprise to fill the field opco of vouchers CRMSS-520
* @author: TMA-EIL CG
* @date: 16/03/2020
* @Test: BatchReprise_VoucherOpco_Test
* @Coverage: 100%
*/

global without sharing class BatchReprise_VoucherOpco implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //select vouchers that are linked to a hotel with a country, but have the field opco__c null
        string query = 'select id, OPCO__c, hotel__c, hotel__r.country__c from voucher__c where OPCO__c = null and hotel__c != null and hotel__r.country__c != null';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<voucher__c> listVouchers){
        
        list<voucher__c> listToUpdate = new list<voucher__c>();
        
        if(listVouchers != null && listVouchers.size()>0){
            
            for(voucher__c vouch : listVouchers){
                
                //fill opco__c with the hotel's country
                vouch.OPCO__c = vouch.hotel__r.country__c;
                
                listToUpdate.add(vouch);
            }
            
            if(listToUpdate != null && listToUpdate.size()>0){
                
                //update the vouchers
                database.update(listToUpdate, false);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){}
        
}