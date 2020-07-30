/*
* Description: This method will not allow the user to add more than one voucher (IR) to a case (Case linked to IR)
* @author: TMA-EI jka
* @date: 08/10/2019
* @Test: AP04_Voucher_Test
* @Coverage: 81%
*/

public without sharing class AP04_Voucher {
    
    
    //Filtering the list before calling the CalculateVoucher function
    public static void vouchHelper(List<Voucher__c> ListNewVouchers , map<Id,Voucher__c> oldMapVoucher){
        
        Map<id, list<Voucher__c>> MapCaseByIRVoucher = new  Map<id, list<Voucher__c>>();
        Map<id, list<Voucher__c>> MapCaseByIRVoucherUpdate = new  Map<id, list<Voucher__c>>();
        
        List<Voucher__c> InsertListVouch = new List<Voucher__c>();
        List<Voucher__c> DeleteListVouch = new List<Voucher__c>();
        List<Voucher__c> UpdateListVouch = new List<Voucher__c>();
        List<Voucher__c> UpdateOldListVouch = new List<Voucher__c>();
        Map<id,Decimal> MapVouchCalculated = new Map<id,Decimal>();
        
        Id Voucher_RT_IR_Id = Schema.SObjectType.Voucher__c.getRecordTypeInfosByDeveloperName().get('IR').getRecordTypeId();
        Id Case_RT_Case_linked_to_IR_Id = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Case_linked_to_IR').getRecordTypeId();
        
        if(ListNewVouchers != null && ListNewVouchers.size()>0){
            
            for(Voucher__c vouch : ListNewVouchers){
                
                //Insert Voucher
                if(oldMapVoucher == null){
                    system.debug('@@@@@@@@@ in insert');
                    if(vouch.RecordTypeId==Voucher_RT_IR_Id && vouch.Demande_d_assistance__c!=null && vouch.tech_CaseRecTypeId__c == Case_RT_Case_linked_to_IR_Id ){
                        if(MapCaseByIRVoucher.ContainsKey(vouch.Demande_d_assistance__c)){
                            InsertListVouch  = MapCaseByIRVoucher.get(vouch.Demande_d_assistance__c);
                        }
                        InsertListVouch.add(vouch);
                        MapCaseByIRVoucher.put(vouch.Demande_d_assistance__c, InsertListVouch);
                    }
                }
                
                //Update Voucher  
                //v.Demande_d_assistance__c !=oldMapVoucher.get(v.Id).Demande_d_assistance__c get the old voucher and then access the case 
                else if(oldMapVoucher != null && vouch.Demande_d_assistance__c !=oldMapVoucher.get(vouch.Id).Demande_d_assistance__c  && (vouch.tech_CaseRecTypeId__c == Case_RT_Case_linked_to_IR_Id || oldMapVoucher.get(vouch.Id).tech_CaseRecTypeId__c ==Case_RT_Case_linked_to_IR_Id)){
                    system.debug('@@@@@@@@@ in update');
                    System.debug('###new jka in Ap04_voucher vouch.Demande_d_assistance__c new'+ vouch.Demande_d_assistance__c);
                    System.debug('###new jka in Ap04_voucher oldMapVoucher.get(vouch.Id).Demande_d_assistance__c new '+oldMapVoucher.get(vouch.Id).Demande_d_assistance__c);
                    System.debug('###new jka vouch.tech_CaseRecTypeId__c new'+vouch.tech_CaseRecTypeId__c );
                    System.debug('###new jka Case_RT_Case_linked_to_IR_Id '+Case_RT_Case_linked_to_IR_Id );
                    System.debug('###new jka oldMapVoucher.get(vouch.Id).tech_CaseRecTypeId__c new'+oldMapVoucher.get(vouch.Id).tech_CaseRecTypeId__c );
                    System.debug('###new jka Case_RT_Case_linked_to_IR_Id new'+Case_RT_Case_linked_to_IR_Id );
                    
                    //old Voucher
                    if(oldMapVoucher.get(vouch.Id).Demande_d_assistance__c != null && MapCaseByIRVoucherUpdate.ContainsKey(oldMapVoucher.get(vouch.Id).Demande_d_assistance__c)){
                        UpdateOldListVouch  = MapCaseByIRVoucherUpdate.get(oldMapVoucher.get(vouch.Id).Demande_d_assistance__c);
                    }
                    UpdateOldListVouch.add(oldMapVoucher.get(vouch.Id));
                    MapCaseByIRVoucherUpdate.put((oldMapVoucher.get(vouch.Id).Demande_d_assistance__c), UpdateOldListVouch);
                    
                    //new Voucher
                    if(vouch.Demande_d_assistance__c != null && MapCaseByIRVoucher.ContainsKey(vouch.Demande_d_assistance__c)){
                        UpdateListVouch  = MapCaseByIRVoucher.get(vouch.Demande_d_assistance__c);
                    }
                    UpdateListVouch.add(vouch);
                    MapCaseByIRVoucher.put(vouch.Demande_d_assistance__c, UpdateListVouch);
                    // System.debug('### jka uppdatee dmd '+vouch.Demande_d_assistance__c);
                    // System.debug('### jka updateee vouch.tech_CaseRecTypeId__c '+vouch.tech_CaseRecTypeId__c);
                }
                
            }
        }     
        
        //Delete Voucher
        else if(ListNewVouchers == null && oldMapVoucher != null && oldMapVoucher.size()>0){
            for(String vouchId : oldMapVoucher.keySet()){
                Voucher__c vouch = oldMapVoucher.get(vouchId);
                if(vouch.RecordTypeId==Voucher_RT_IR_Id && vouch.Demande_d_assistance__c!=null && vouch.tech_CaseRecTypeId__c == Case_RT_Case_linked_to_IR_Id ){
                    if(MapCaseByIRVoucher.ContainsKey(vouch.Demande_d_assistance__c)){
                        DeleteListVouch.add(oldMapVoucher.get(vouchId));
                    }
                } 
                DeleteListVouch.add(vouch);
                if(DeleteListVouch!=null && DeleteListVouch.size()>0){
                    MapCaseByIRVoucher.put(vouch.Demande_d_assistance__c, DeleteListVouch);
                }
            }
            
        }
        
        if((InsertListVouch != null && InsertListVouch.size()>0) || (DeleteListVouch != null && DeleteListVouch.size()>0) || (UpdateListVouch != null && UpdateListVouch.size()>0)){
            MapVouchCalculated = CalculateVoucher(InsertListVouch,DeleteListVouch,UpdateListVouch,oldMapVoucher);
        }
        
        //Update case
        system.debug('@@@@ MapVouchCalculated.KeySet()'+MapVouchCalculated.KeySet());
        List<Case> listCase = new List<Case>();
        for(Id caseId :MapVouchCalculated.KeySet()){
            Case case1 = new Case();
            case1.Id= caseId;
            case1.tech_NumberOfIR__c= MapVouchCalculated.get(caseId);
            listCase.add(case1);
        }
        system.debug('@@@@@ listcase'+listCase);
        if(listCase != null && listCase.size()>0){
            update listCase;
        }
        
    }
    
    Public Static Map<Id,Decimal> CalculateVoucher(List<Voucher__c> InsertVouch, List<Voucher__c> DeleteVouch,List<Voucher__c> UpdateVouch,map<Id,Voucher__c> oldMapVouch){
        
        System.debug('### jka in CalculateVoucher');
        system.debug('@@@ InsertVouch'+InsertVouch);
        system.debug('@@@ DeleteVouch'+DeleteVouch);
        system.debug('@@@ UpdateVouch'+UpdateVouch);
        system.debug('@@@ oldMapVouch'+oldMapVouch);
        Map<Id,Decimal> mapVouch = new Map<Id,Decimal>();
        
        if(InsertVouch!=null && InsertVouch.size()>0){
            for(Voucher__c vouch : InsertVouch){
                //vouch.tech_NumberOfIROncase__c default value is 0
                Decimal voucherNb = vouch.tech_NumberOfIROncase__c;
                if(mapVouch.containsKey(vouch.Demande_d_assistance__c)){
                    voucherNb=mapVouch.get(vouch.Demande_d_assistance__c);
                }
                voucherNb++;
                mapVouch.put(vouch.Demande_d_assistance__c,voucherNb);
            }
        }
        else if(DeleteVouch!=null && DeleteVouch.size()>0){
            for(Voucher__c vouch : DeleteVouch){
                Decimal voucherNb =vouch.tech_NumberOfIROncase__c;
                //system.debug('### jka voucherNb'+voucherNb);
                if(mapVouch.containsKey(vouch.Demande_d_assistance__c)){
                    voucherNb=mapVouch.get(vouch.Demande_d_assistance__c);
                }
                if(voucherNb>0){
                    voucherNb--;
                    // system.debug('### jka voucherNb--'+voucherNb);
                    mapVouch.put(vouch.Demande_d_assistance__c,voucherNb);
                    
                }
            }
        }
        
        else if(UpdateVouch!=null && UpdateVouch.size()>0 && oldMapVouch!=null){
            for(Voucher__c vouch : UpdateVouch){
                Decimal voucherNb = vouch.tech_NumberOfIROncase__c;
                // System.debug('### jka in update voucherNb before  '+voucherNb);
                if(vouch.Demande_d_assistance__c!= null&& !string.isBlank(vouch.Demande_d_assistance__c)){
                    if(mapVouch.containsKey(vouch.Demande_d_assistance__c)){
                        // System.debug('in mapvouch');
                        voucherNb= mapVouch.get(vouch.Demande_d_assistance__c);
                    }
                    voucherNb++;
                    
                    mapVouch.put(vouch.Demande_d_assistance__c,voucherNb);
                    // System.debug('### jka in update voucherNb after '+voucherNb);
                }
                
                if(oldMapVouch.get(vouch.Id).Demande_d_assistance__c !=null ){
                    voucherNb= oldMapVouch.get(vouch.Id).tech_NumberOfIROncase__c;
                    if(mapVouch.containsKey(vouch.Demande_d_assistance__c)){
                        voucherNb=oldMapVouch.get(vouch.Id).tech_NumberOfIROncase__c; 
                        
                    }
                    System.debug('###jka old map update voucherNb'+voucherNb);
                    if(voucherNb>0){
                        voucherNb--;
                        mapVouch.put(oldMapVouch.get(vouch.Id).Demande_d_assistance__c,voucherNb);
                        //System.debug('### jka old map update voucherNb>0 '+voucherNb);
                    }
                }
                
            }
        }
        return mapVouch;
        
    }
}