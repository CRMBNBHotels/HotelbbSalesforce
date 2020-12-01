/*
* Description: Controller class for LC_Test
* @author: TMA-EI CG
* @date: 06/11/2020
* @Test class: LCC01_DashboardOCQuotas_Test
* @Coverage: 92%
* @Lightning Components: LC_Test
*/

public without sharing class LCC01_DashboardOCQuotas {
    
    @AuraEnabled
    public static ReturnedInfo GetRemainingQuotas(string userEmail, integer nbCopies) {
        
        system.debug('### cg apx userEmail'+userEmail);
        system.debug('### cg apx nbCopies'+nbCopies);
        
        ReturnedInfo ret = new ReturnedInfo();
        List<Master_Voucher__c> listMV = new List<Master_Voucher__c>();
        list<Contact_Role__c> listContRole = new list<Contact_Role__c>();
        
        string role = '';
        double remainingHotelVouchOC = 0;
        
        if(userEmail != null && userEmail !=''){
            
            //Specify the role of the connected user
            listContRole = [Select Id, Role__c, Contact__r.Email, hotel__r.Invitations_Restantes__c 
                            From Contact_Role__c 
                            Where Contact__r.Email =: userEmail];
            
            if(listContRole != null && listContRole.size()>0){
                
                for(Contact_Role__c contRole : listContRole){
                    
                    if(contRole.Role__c == 'IR-OC'){
                        
                        role = contRole.Role__c;
                        remainingHotelVouchOC = contRole.Hotel__r.Invitations_Restantes__c;
                        break;
                    }
                }
            }
            
            if(role != null && role != '' && role == 'IR-OC'){
                
                ret.nbAvailableVouch = remainingHotelVouchOC;
                ret.hotelierEmitter = true;
                
                if(nbCopies != null){
                    
                    ret.remainingVouchOC = remainingHotelVouchOC - nbCopies;
                }
                
                system.debug('### cg apx ret.remainingVouchOC'+ret.remainingVouchOC);
            }
            else if(role == null || role == '' || role != 'IR-OC'){
                
                //If the connected user isn not an IR-OC hotelier, then return 1 which is a positive value always
                ret.nbAvailableVouch = 1;
                ret.remainingVouchOC = 1;
            }
            
        }
        
        system.debug('### cg listContRole'+listContRole);
        
        return ret;
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public double remainingVouchOC;
        @AuraEnabled public double nbAvailableVouch;
        @AuraEnabled public boolean hotelierEmitter;
    }
    
    @AuraEnabled
    public static ReturnedDefaultInfo GetDefaultInfo(string clientExtId, string hotelEmitExtId){
        
        ReturnedDefaultInfo ret = new ReturnedDefaultInfo();
        
        Id PASFId;
        id HotelSFId;
        
        if(clientExtId != null && clientExtId != ''){
            
            list<Account> listPA = new list<Account>([Select Id, FirstName, LastName, Externalid__pc
                                                      From Account
                                                      Where Externalid__pc =: clientExtId
                                                      Limit 1]);
            
            if(listPA != null && listPA.size()>0){
                
                PASFId = listPA[0].Id;
            }
        }
        
        if(hotelEmitExtId != null && hotelEmitExtId != ''){
            
            list<Hotel__c> listHotel = new list<Hotel__c>([Select Id,Hotel_ID__c 
                                                           from Hotel__c 
                                                           Where Hotel_ID__c =: hotelEmitExtId
                                                           Limit 1]);
            
            if(listHotel != null && listHotel.size()>0){
                
                HotelSFId = listHotel[0].Id;
            }
        }
        
        ret.personAccountSFID = PASFId;
        ret.hotelEmitterSFID = HotelSFId;
        
        return ret;
    }		
    
    public class ReturnedDefaultInfo{
        
        @AuraEnabled public Id personAccountSFID;
        @AuraEnabled public Id hotelEmitterSFID;
    }
    
    
}