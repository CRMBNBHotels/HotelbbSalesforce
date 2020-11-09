/*
* Description: Class to get the list of vouchers related to Master voucher OC
* @author: TMA JK
* @date: 06/10/2020
* @Test: VFC01_GetRelatedVouchers_Test
* @Coverage: 80%
*/
public with sharing class VFC01_GetRelatedVouchers {
    
    Id recordId;
    
    public ApexPages.StandardController relatedVoucher {get; set;}
    public list<Voucher__c> RelatedVouchers {get; set;}
    
    
    public VFC01_GetRelatedVouchers(ApexPages.StandardController cntrl) {
        
        //recordId = cntrl.getId(); //Commented by TMA-EIT CG CRMSS-884 27/10/2020
        recordId = apexpages.currentpage().getparameters().get('id');//Added by TMA-EIT CG CRMSS-884 27/10/2020
        
        RelatedVouchers = [select id,Code_OC__c,Zone_de_validite_OC__c,toLabel(Prestation_offerte__c),Nom_Prenom_du_client__c,Offert_occasion_de__c,toLabel(Validite__c),expireDate__c,Hotel_Validite_France__r.Commercial_Hotel_Name__c 
                           from Voucher__c 
                           where Master_Voucher_OC__c=: recordId];
        
        system.debug('recordId ' + recordId);
        
    }
}