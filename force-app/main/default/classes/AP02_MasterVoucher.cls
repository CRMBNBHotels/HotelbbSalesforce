/*
* Description: Class to create Voucher OC and fill the code when the master voucher is created on after insert
* @author: TMA JK
* @date: 02/10/2020
* @Test: AP02_MasterVoucher_Test
* @Coverage: 89%
*/
public without sharing class AP02_MasterVoucher {
    
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
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////Update the number of existing vouchers on an Hotel when a new MV OC is created /////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /* 
     * @Description: method to update Hotels remaining Vouchers OC CRMSS-869-951
     * @author: TMA-EIT CG 
     * @date: 19/11/2020
     */ 
    
    public static void fillHotelRemainInvit(list<Master_Voucher__c> listMasterVoucher){
        
        set<Id> setEmitId = new set<Id>();
        list<string> listEmitEmails = new list<string>();
        map<string, list<double>> mapEmitEmailListExistVouchNb = new map<string, list<double>>();
        map<string, double> mapEmitEmailTotalVouchNb = new map<string, double>();
        list<hotel__c> listHotelsToUpdate = new list<Hotel__c>();
        
        for(Master_voucher__c mvouch : listMasterVoucher){
            system.debug('### mvouch.Pr_nom_Nom_de_l_m_tteur__c: '+mvouch.Pr_nom_Nom_de_l_m_tteur__c);
            if(mvouch.Pr_nom_Nom_de_l_m_tteur__c != null){
                
                setEmitId.add(mvouch.Pr_nom_Nom_de_l_m_tteur__c);
            }
        }
        
        if(setEmitId != null && setEmitId.size()>0){
            
            For(user usObj : [select Id, Email from user where Id In:setEmitId]){
                
                listEmitEmails.add(usObj.Email);
            }
            
        }
        system.debug('### listEmitEmails: '+listEmitEmails);
        
        if(listEmitEmails != null && listEmitEmails.size()>0){
            
            list<Master_Voucher__c> listExistingMV = new list<Master_Voucher__c>([Select Id, Pr_nom_Nom_de_l_m_tteur__c, Tech_EmetteurEmail__c , Nombre_de_copie_s__c 
                                                                                  from Master_Voucher__c
                                                                                 where Tech_EmetteurEmail__c  IN: listEmitEmails]);
            system.debug('### listExistingMV: '+listExistingMV);
            system.debug('### listExistingMV size: '+listExistingMV.size());
            if(listExistingMV != null && listExistingMV.size()>0){
                
                for(Master_Voucher__c mvouch : listExistingMV){
                    
                    if(!mapEmitEmailListExistVouchNb.containsKey(mvouch.Tech_EmetteurEmail__c)){
                        
                        list<double> listToPut = new list<double>();
                        listToPut.add(mvouch.Nombre_de_copie_s__c);
                        mapEmitEmailListExistVouchNb.put(mvouch.Tech_EmetteurEmail__c, listToPut);
                    }
                    else{
                        
                        list<double> listToPut = mapEmitEmailListExistVouchNb.get(mvouch.Tech_EmetteurEmail__c);
                        listToPut.add(mvouch.Nombre_de_copie_s__c);
                        mapEmitEmailListExistVouchNb.put(mvouch.Tech_EmetteurEmail__c, listToPut);
                    }
                }
                system.debug('### mapEmitEmailListExistVouchNb: '+mapEmitEmailListExistVouchNb);
                if(mapEmitEmailListExistVouchNb != null && mapEmitEmailListExistVouchNb.size()>0){
                    
                    for(string emailEmit : mapEmitEmailListExistVouchNb.keySet()){
                        
                        double nbExistVouch = 0;
                        
                        if(mapEmitEmailListExistVouchNb.get(emailEmit) != null && mapEmitEmailListExistVouchNb.get(emailEmit).size()>0){
                            
                            for(double nbCopies : mapEmitEmailListExistVouchNb.get(emailEmit)){
                                
                                nbExistVouch = nbExistVouch + nbCopies;
                            }
                        }
                        
                        mapEmitEmailTotalVouchNb.put(emailEmit,nbExistVouch);
                    }
                    system.debug('### mapEmitEmailTotalVouchNb: '+mapEmitEmailTotalVouchNb);
                    if(mapEmitEmailTotalVouchNb != null && mapEmitEmailTotalVouchNb.size()>0){
                        
                        list<Contact_role__c> listMVContactRoles = new list<Contact_role__c>([Select id, Contact__c, contact__r.Email, hotel__c, hotel__r.Invitations_existantes__c
                                                                                  from Contact_role__c
                                                                                  Where contact__r.Email IN: mapEmitEmailTotalVouchNb.keySet()]);
                        
                        system.debug('### listMVContactRoles: '+listMVContactRoles);
                        if(listMVContactRoles != null && listMVContactRoles.size()>0){
                            
                            for(Contact_role__c contRole : listMVContactRoles){
                                
                                Hotel__c hot = new Hotel__c();
                                hot.Id = contRole.hotel__c;
                                hot.Invitations_existantes__c = mapEmitEmailTotalVouchNb.get(contRole.contact__r.Email);
                                system.debug('### mapEmitEmailTotalVouchNb.get(contRole.contact__r.Email): '+mapEmitEmailTotalVouchNb.get(contRole.contact__r.Email));
                                
                                listHotelsToUpdate.add(hot);
                            }
                            system.debug('### listHotelsToUpdate: '+listHotelsToUpdate);
                            if(listHotelsToUpdate != null && listHotelsToUpdate.size()>0){
                                
                                update listHotelsToUpdate;
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
}