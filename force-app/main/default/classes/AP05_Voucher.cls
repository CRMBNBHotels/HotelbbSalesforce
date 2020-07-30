/**
* @author TMA-EIL CG
* @date 06/03/2020
* @description Fill the field opco of the object voucher on insert and update CRMSS-474
* @test class : AP05_voucher_test
* @coverage: 100%
*/

public without sharing class AP05_Voucher {
    
    //method to fill th field opco of a voucher on before insert or update
    public static void fillVoucherOpco(list<voucher__c> listNewVouch){
        
        map<string, string> mapVouchIdHotelId = new map<string, string>();//map each voucher with its hotel
        map<string, string> mapHotelIdCountry = new map<string, string>();//map each hotel retrieved with its country
        map<string, string> mapVouchIdHotelCountry = new map<string, string>();//map each voucher with its hotel's country
        
        if(listNewVouch != null && listNewVouch.size()>0){
            
            for(voucher__c vouch : listNewVouch){
                
                //map each voucher with its hotel
                mapVouchIdHotelId.put(vouch.id, vouch.hotel__c);
            }
            
            if(mapVouchIdHotelId != null && mapVouchIdHotelId.size()>0){
                
                //map each retrieved hotel with its country
                for(Hotel__c hot : [select id, Country__c from hotel__c where Id IN: mapVouchIdHotelId.values()]){
                    
                    mapHotelIdCountry.put(hot.Id, hot.Country__c);
                }
                
                if(mapHotelIdCountry != null && mapHotelIdCountry.size()>0){
                    
                    for(string vouchId : mapVouchIdHotelId.keyset()){
                        
                        if(mapHotelIdCountry.containsKey(mapVouchIdHotelId.get(vouchId))){
                            
                            //map each voucher with its hotel's country
                            mapVouchIdHotelCountry.put(vouchId,mapHotelIdCountry.get(mapVouchIdHotelId.get(vouchId)));
                        }
                    }
                    
                    if(mapVouchIdHotelCountry != null && mapVouchIdHotelCountry.size()>0){
                        
                        for(voucher__c vouch : listNewVouch){
                            
                            if(mapVouchIdHotelCountry.containsKey(vouch.Id)){
                                
                                //update the voucher's OPCO field with the corresponding hotel country
                                vouch.OPCO__c = mapVouchIdHotelCountry.get(vouch.Id);
                            }
                        }
                    }
                }
            }
        } 
    }
}