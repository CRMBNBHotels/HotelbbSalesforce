/**
* @author TMA-EI Julien
* @date 15/04/2019
* @description update fields on voucher object + WS. CRMSS-133
* @test class : AP03_voucher_test
* @coverage: 80 %
*/
public without sharing class AP03_voucher {
    //Method to check if  1-Statut__c on object voucher is modified 
    //                   2- Status_change_request__c isn't modified 
    //                   3- the modification wasn't made by a technical user
    // if those criteria are true we save the voucher old value in a technical field named Tech_Last_Data__c , and the field Status_change_request__c take a value "Processing"                  
    public static void Voucher_update(map<id,Voucher__c> MapVouchers, map<id,Voucher__c> MapOldVouchers)
    {
        system.debug('@@@ in ap03 Voucher_update ');
        
        
        Map<String,String> mapJsonn =  new Map<String,String>();
        Map<String,SObject> OldmapVoucher =  new Map<String,Voucher__c>(); 
        set<string> SetOfFields = new  set<string>();
        
        for(Id VoucherId : MapOldVouchers.Keyset()){
            
            if(MapVouchers.get(VoucherId).Statut__c != MapOldVouchers.get(VoucherId).Statut__c){
                
                SetOfFields.add('Statut__c');
                
                if(SetOfFields != null && SetOfFields.size()>0){
                    
                    Sobject vouch = AP02_SObject_WS.SetFieldAndValue(MapOldVouchers.get(VoucherId),SetOfFields);
                    OldmapVoucher.put(VoucherId,vouch);
                }
            } 
        }
        mapJsonn = AP02_SObject_WS.Serialize(OldmapVoucher,null,null); 
        
        for (id Idcurr : MapVouchers.keySet())
        {
            String ConnectedUserId = userinfo.getUserId();
            if(MapVouchers.get(Idcurr).Statut__c != MapOldVouchers.get(Idcurr).Statut__c 
               && MapVouchers.get(Idcurr).Status_change_request__c ==  MapOldVouchers.get(Idcurr).Status_change_request__c
               && ConnectedUserId.substring(0,15) != label.technical_user_2_id )
            { 
                MapVouchers.get(Idcurr).Status_change_request__c = 'Processing';
                
                MapVouchers.get(Idcurr).Tech_Last_Data__c= mapJsonn.get(Idcurr);
                
            }
        }
    }
    
    /*
* @ Author Cynthia Geagea TMA
* @ Date 07/05/2019
* @ Description  Method to call WS on update CRMSS-129
*/
    public static void CallWSUpdateVoucherInfo(Map<ID,Voucher__c> newMap, Map<ID,Voucher__c> oldMap) {
        
        Map<String,String> mapfieldModified = new Map<String,String>();
        
        //Check the fields modified + if the user is not the technical user + the field that shows the status of the synchronisation between BBUS and SF should not be modified to a value other than "Processing"
        for(Id Idcurr : newMap.Keyset() ){
            String ConnectedUserId = userinfo.getUserId();
            if( ConnectedUserId.substring(0,15) != label.technical_user_2_id){
                //If the info modified is related to personal info, set a list of fields modified and call a future method to perform the callout for BBUS
                if((newMap.get(Idcurr).Status_change_request__c =='Processing' || newMap.get(Idcurr).Status_change_request__c == oldMap.get(Idcurr).Status_change_request__c ) && 
                   newMap.get(Idcurr).Statut__c != oldMap.get(Idcurr).Statut__c){
                       
                       mapfieldModified.put('Statut__c',newMap.get(Idcurr).Statut__c);
                       
                       //Call the future method
                       
                       system.debug('###cyn CallWSUpdateVoucherInfo newMap.get(Idcurr).externalID__c'+newMap.get(Idcurr).externalID__c);
                       
                       //Added by TMA-CG CRMSS-203 20/06/2019 start
                       //If it's from a batch or future method call the regular method
                       if(System.isFuture() || System.isBatch()){
                           system.debug('@@@ CallWSUpdateVoucherInfo if');
                           regularCallWS(newMap.get(Idcurr).externalID__c,Idcurr,mapfieldModified.keyset());
                       } 
                       else {
                           //call the future method
                           if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()){
                               system.debug('@@@ CallWSUpdateVoucherInfo else');
                               futureCallWS(newMap.get(Idcurr).externalID__c,Idcurr,mapfieldModified.keyset());
                           }
                       }
                       //Added by TMA-CG CRMSS-203 20/06/2019 end
                       
                   }
            }
        }
        
    }
    
    /*
* @ Author Cynthia Geagea TMA
* @ Date 07/05/2019
* @ Description Future method to perform the callout to BBUS and check if it's a bad response or good response and perform the correspondant action CRMSS-129
*/
    
    //Future method to perform the callout to BBUS and check if it's a bad response or good response and perform the correspondant action
    //Added by TMA-CG CRMSS-203 20/06/2019 start
    @future(callout=true)
    Public Static Void futureCallWS(String ExtID, String Idcurr,Set<String> setfieldModif){
        regularCallWS(ExtID, Idcurr, setfieldModif);
    }
    //Added by TMA-CG CRMSS-203 20/06/2019 end
    
    Public Static Void regularCallWS(String ExtID, String Idcurr,Set<String> setfieldModif){
        system.debug('### regular Call');
        BB_VoucherObject voucherObject = new BB_VoucherObject(); 
        Voucher__c vouch = new Voucher__c();
        system.debug('@@@ ap03 Idcurr '+Idcurr);
        //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - Start

        String rtId = [select RecordtypeId from voucher__c where Id =: Idcurr].RecordtypeId; 
        system.debug('@@@ hereeeeee');
        //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - End
        system.debug('@@@ ap03 rtId'+rtId);
        try { 
            
            //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - Start
            if(rtId != null && string.isNotBlank(rtId)){
                
                BB_VoucherObject.RTID = rtId;
            }
            system.debug('### ExtID ap03 ' + ExtID);
            //Added by TMA-EIL CG - CRMSS 423 - 09/01/2020 - End
            if(ExtID != null && !string.isBlank(ExtID)){
                system.debug('###  Call BBUS ');
                HttpResponse response = BBUS_DataHistoryManager.callBBUSWebserviceResponse('voucher', null, null, ExtID,setfieldModif);
                system.debug('### cg response: '+response);
                system.debug('###cyn CallWS ExtID'+ExtID);
                system.debug('running test?'+test.isRunningTest());
                
                
                String strResponse = response.getBody(); 
                system.debug('###cyn strResponse'+strResponse);
                Log__c log = new Log__c();
                log.WSName__c = 'Voucher Synchronisation Return';
                log.JsonMessage__c = strResponse;
                log.FromSalesforce__c = true;
                insert log;
                //if it's a bad response then perform a rollback + set the status of the sync to error
                
                if(response.getStatusCode() != 200){
                    system.debug('@@@ !200 ap03');
                    vouch =  voucherObject.actionBadResponse(strResponse, Idcurr,setfieldModif);
                }else{
                    system.debug('@@@ 200 ap03');
                    //if it's a good response then set the status of the sync to Successful with the date
                    vouch.id = Idcurr;
                    vouch.Status_change_request__c = 'Successful ' + String.valueOf(DateTime.now().format());
                }
                update vouch;
            }
            else{
                 vouch.id = Idcurr;
                 vouch =  voucherObject.actionBadResponse(null, Idcurr,setfieldModif);
                 vouch.Status_change_request__c = 'Error null External Id ' + String.valueOf(DateTime.now().format());
           		 update vouch;
            }
        }catch(Exception e) {
            system.debug('### cyn catch exception ' + e);
            system.debug('### cyn vouch.Statut__c'+vouch.Statut__c);
            //if we could not perform the callout, set the status to error with the date
            vouch.id = Idcurr;
            
            //Added by TMA-CG CRMSS-203 20/06/2019 start
            vouch =  voucherObject.actionBadResponse(null, Idcurr,setfieldModif);
            //Added by TMA-CG CRMSS-203 20/06/2019 end
            
            vouch.Status_change_request__c = 'Error ' + String.valueOf(DateTime.now().format());
            update vouch;
            system.debug('### cyn vouch.Statut__c'+vouch.Statut__c);
        }
    }
}