/*
* Description: Class to create Voucher OC and fill the code when the master voucher is created on after insert
* @author: TMA JK
* @date: 02/10/2020
* @Test: AP02_MasterVoucher_Test
* @Coverage: 92%
*/
public class AP02_MasterVoucher {
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////Create Voucher OC from Master Voucher //////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public static void CreateVoucherOCOnInsert(list<Master_Voucher__c> listMasterVoucher){
        
        //Map each Prestation Offertte value selected on the master voucher OC, with the corresponding Nb de nuit and Nb de Pdj on the voucher OC CRMSS-909
        List<Prestation_NbNuit_NbPdj_OC__mdt> listPrestationNbNuitNbPdj = [select Id, Prestation_Offerte__c, Nb_de_nuit__c, Nb_de_Pdj__c from Prestation_NbNuit_NbPdj_OC__mdt];//retrieve all custom metadata mappings
        map<string,double> mapPrestationNbNuit = new map<string,double>();
        map<string,double> mapPrestationNbPdj = new map<string,double>();
        
        //Fill the maps with the corresponding values
        if(listPrestationNbNuitNbPdj != null && listPrestationNbNuitNbPdj.size()>0){
            
            for(Prestation_NbNuit_NbPdj_OC__mdt presta : listPrestationNbNuitNbPdj){
                
                mapPrestationNbNuit.put(presta.Prestation_Offerte__c, presta.Nb_de_nuit__c);
                mapPrestationNbPdj.put(presta.Prestation_Offerte__c, presta.Nb_de_Pdj__c);
            }
        }
        
        List<Voucher__c> listVoucherToBeCreated = new List<Voucher__c>();
        List<Voucher__c> listFailedVoucherToBeCreated = new List<Voucher__c>();
        
        String VoucherOCRT = Schema.SObjectType.Voucher__c.getRecordTypeInfosByName().get('OC').getRecordTypeId();
        
        //Creation of the vouchers according to the number of copies selected on the master voucher OC, and filling them with corresponding data
        for(Master_Voucher__c MasterVoucher : listMasterVoucher){
            
            if(MasterVoucher.Nombre_de_copie_s__c != null ){
                
                for(integer i = 0; i < MasterVoucher.Nombre_de_copie_s__c; i++){
                    
                    Voucher__c VoucherToBeCreated = new Voucher__c();
                    VoucherToBeCreated.RecordTypeId = VoucherOCRT;
                    VoucherToBeCreated.Type_d_invitation__c = Label.AP02_MasterVoucher_OperationCommerciale;
                    VoucherToBeCreated.Master_Voucher_OC__c = MasterVoucher.id;
                    VoucherToBeCreated.Nom_de_l_m_tteur__c = MasterVoucher.Pr_nom_Nom_de_l_m_tteur__c;
                    VoucherToBeCreated.Hotel_emetteur__c = MasterVoucher.Hotel_Service_Emmetteur__c;
                    VoucherToBeCreated.Hotel_Validite_France__c = MasterVoucher.Valable_dans_cet_h_tel__c;
                    VoucherToBeCreated.Dur_e_de_validit__c = MasterVoucher.Dur_e_de_validit__c;
                    VoucherToBeCreated.Validite__c = MasterVoucher.P_riode_de_validit__c;
                    VoucherToBeCreated.expireDate__c = MasterVoucher.Date_d_expiration__c;
                    VoucherToBeCreated.Email_du_client__c = MasterVoucher.Email_client__c;
                    VoucherToBeCreated.Person_Account__c = MasterVoucher.Personal_account__c;
                    VoucherToBeCreated.Nature_de_la_demande__c = MasterVoucher.Nature_de_la_demande__c;
                    VoucherToBeCreated.Statut__c = Label.AP02_MasterVoucher_Status_Generated;
                    VoucherToBeCreated.Valorisation__c = MasterVoucher.Valorisation__c;
                    VoucherToBeCreated.Code_OC__c = generateVoucherOcCode();//Added by TMA-EIT CG CRMSS-870
                    VoucherToBeCreated.Commentaires__c = MasterVoucher.Commentaires__c;//Added by TMA-EIT CG CRMSS-916
                    
                    //CRMSS-909 
                    if(MasterVoucher.Prestation_Offerte__c != null && MasterVoucher.Prestation_Offerte__c != ''){
                        
                        VoucherToBeCreated.Prestation_offerte__c = MasterVoucher.Prestation_Offerte__c;
                        
                        if(mapPrestationNbNuit != null && mapPrestationNbNuit.size()>0 && mapPrestationNbNuit.containsKey(MasterVoucher.Prestation_Offerte__c)){
                            
                            VoucherToBeCreated.Nb_de_nuit_OC__c = mapPrestationNbNuit.get(MasterVoucher.Prestation_Offerte__c);
                        }
                        
                        if(mapPrestationNbPdj != null && mapPrestationNbPdj.size()>0 && mapPrestationNbPdj.containsKey(MasterVoucher.Prestation_Offerte__c)){
                            
                            VoucherToBeCreated.Nb_de_Pdj_OC__c = mapPrestationNbPdj.get(MasterVoucher.Prestation_Offerte__c);
                        }
                        
                    }
                    
                    listVoucherToBeCreated.add(VoucherToBeCreated);
                }
            }
        }
        
        //Added by TMA-EIT CG CRMSS-870
        if(listVoucherToBeCreated != null && listVoucherToBeCreated.size() > 0 ){
            
            Database.UpsertResult[] insertResults = database.upsert(listVoucherToBeCreated, false); //insert the vouchers partially
            
            //do while will execute at least once
            do{system.debug('### cg im in do');
                //clear the list of failed vouchers to fill it properly
                if(listFailedVoucherToBeCreated != null && listFailedVoucherToBeCreated.size()>0){
                    
                    listFailedVoucherToBeCreated.clear();
                }
                system.debug('### cg listFailedVoucherToBeCreated size afetr clear: '+listFailedVoucherToBeCreated.size());
                //loop over the dynamic insert result to retrieve failures and insert them again
                for(integer i = 0; i < insertResults.size(); i++){
                    
                    //catching all failed vouchers on insert
                    if(!insertResults[i].isSuccess()){
                        system.debug('### cg insertResults[i] error: '+insertResults[i].getErrors());
                        listFailedVoucherToBeCreated.add(listVoucherToBeCreated[i]);
                    }
                }
                system.debug('### cg listFailedVoucherToBeCreated filled again: '+listFailedVoucherToBeCreated);
                if(listFailedVoucherToBeCreated.size()>0){
                    
                    for(voucher__c vouch : listFailedVoucherToBeCreated){
                        
                        vouch.Code_OC__c = generateVoucherOcCode();//call the generation function to regenerate unique and random codes for failed vouchers
                    }
                    
                    insertResults = database.upsert(listFailedVoucherToBeCreated, false);//retry inserting the failed vouchers
                }
                
            }while(listFailedVoucherToBeCreated.size()>0);
            
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////Generate unique and random Voucher OC Codes //////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /* 
     * @Description: method to generate unique and random Voucher OC codes CRMSS-870
     * @author: TMA-EIT CG 
     * @date: 02/10/2020
     */
    
    public static string generateVoucherOcCode(){
        
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        string resultingCode = '';
        
        while(resultingCode.length() < 10){
            
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            resultingCode += chars.substring(idx, idx+1);
        }
        
        resultingCode = 'OC'+resultingCode;
        return resultingCode;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////Update Email and Account of vouchers when they are updated on the Master voucher OC //////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /* 
     * @Description: method to update Vouchers based on Master Vouchers info CRMSS-825
     * @author: TMA-EIT CG 
     * @date: 02/10/2020
     */
    
    public static void UpdateVoucherOCOnMVUpdate(list<Master_Voucher__c> listMasterVoucher, map<Id,Master_Voucher__c> mapOldMasterVoucher){
        
        List<Voucher__c> listVoucherToUpdate = new List<Voucher__c>(); 
        set<String> setUpdatedMVIds = new set<String>();
        
        for(Master_Voucher__c masterVoucher : listMasterVoucher){
            
            if(masterVoucher.Account_Company__c != mapOldMasterVoucher.get(masterVoucher.Id).Account_Company__c || masterVoucher.Email_client__c != mapOldMasterVoucher.get(masterVoucher.Id).Email_client__c ){
                
                setUpdatedMVIds.add(masterVoucher.Id);
            }
        }
        
        if(setUpdatedMVIds != null && setUpdatedMVIds.size()>0){
            
            listVoucherToUpdate = [select Id ,Email_du_client__c, Account_Company__c, Master_Voucher_OC__r.Email_client__c, Master_Voucher_OC__r.Account_Company__c from voucher__c where Master_Voucher_OC__c in: setUpdatedMVIds];
            
            if(listVoucherToUpdate != null && listVoucherToUpdate.size()>0){
                
                for(Voucher__c vouch : listVoucherToUpdate){
                    
                    vouch.Email_du_client__c = vouch.Master_Voucher_OC__r.Email_client__c;
                    vouch.Account_Company__c = vouch.Master_Voucher_OC__r.Account_Company__c;
                }
                
                update listVoucherToUpdate;
            }
        }
    }
}