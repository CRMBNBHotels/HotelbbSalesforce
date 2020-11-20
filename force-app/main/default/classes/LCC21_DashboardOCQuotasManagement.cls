/*
* Description: Controller class for LC21_DashboardOCQuotasManagement 
* @author: TMA-EI CG
* @date: 22/10/2020
* @Test class: LCC21_DashboardOCQuotasManagement_Test
* @Coverage: 82%
* @Lightning Components: LC21_DashboardOCQuotasManagement
*/

public without sharing class LCC21_DashboardOCQuotasManagement {
    
    @AuraEnabled
    public static ReturnedInfo GetQuotas(string userEmail) {
        
        ReturnedInfo ret = new ReturnedInfo();
        list<QuotasObject> listQuotaObjectWrapps = new list<QuotasObject>();
        list<hotel__c> listHotels = new list<Hotel__c>();
        list<Hotel__c> listIROCHotels = new list<Hotel__c>();
        string region = '';
        
        list<Contact_Role__c> listRegion = new list<Contact_Role__c>([Select Id, Role__c, Contact__r.Email,Contact__r.Region_DR__c, hotel__r.Region_DR__c From Contact_Role__c Where Contact__r.Email =: userEmail]);
        system.debug('### cg listRegion: '+listRegion);
        //Get the connected user's role in order to filter returned data according to his region
        if(listRegion != null && listRegion.size()>0){
            
            for(Contact_Role__c contRole : listRegion){
                
                if(contRole.Role__c == 'SRC'){
                    system.debug('### cg role src ');
                    region = 'All';
                    break;
                }
                else if(contRole.Role__c == 'DR'){
                    system.debug('### cg role DR ');
                    region  = contRole.Contact__r.Region_DR__c;
                    break;
                }
                
            }
        }
        system.debug('### cg region: '+region);
        if(region == 'All' || region == ''){
            
            listHotels = [Select Id, Commercial_Hotel_Name__c, Maximun_invitations__c, Invitations_Restantes__c,Region_DR__c, 
                          (select id, role__c, Contact__r.Email, Contact__r.Name,Contact__r.Region_DR__c 
                           from Contacts_Role__r 
                           where role__c = 'IR-OC') 
                          from Hotel__c 
                          order by Commercial_Hotel_Name__c];
        }
        else{
            
            listHotels = [Select Id, Commercial_Hotel_Name__c, Maximun_invitations__c, Invitations_Restantes__c,Region_DR__c, 
                          (select id, role__c, Contact__r.Email, Contact__r.Name,Contact__r.Region_DR__c
                           from Contacts_Role__r 
                           where role__c = 'IR-OC') 
                          from Hotel__c 
                          where Region_DR__c =: region
                          order by Commercial_Hotel_Name__c];
        }
        system.debug('### cg listHotels: '+listHotels);
        system.debug('### cg listHotels size: '+listHotels.size());
        //Filter the returned hotels according to show only the ones with IR-OC related contact roles
        if(listHotels != null && listHotels.size()>0){
            
            for(Hotel__c hot : listHotels){
                
                if(hot.Contacts_Role__r.size()>0){
                    
                    listIROCHotels.add(hot);
                }
            }
            system.debug('### cg listIROCHotels: '+listIROCHotels);
        system.debug('### cg listIROCHotels size: '+listIROCHotels.size());
            if(listIROCHotels != null && listIROCHotels.size()>0){
                
                for(Hotel__c hot : listIROCHotels){
                    
                    //For(contact_role__c contRole : hot.Contacts_Role__r){ //Commented because Hotelier name must be removed from the LC21_DashboardOCQuotasManagement
                        
                        //Initialization of wrapper object, used instead of hotel object to return Contact Role and Hotel Objects info in one list
                        QuotasObject quotasObj = new QuotasObject();
                        quotasObj.hotelId = hot.Id;
                        quotasObj.hotelName = hot.Commercial_Hotel_Name__c;
                        quotasObj.maxInvit = hot.Maximun_invitations__c;
                        quotasObj.remainInvit = hot.Invitations_Restantes__c;
                        quotasObj.currentYear = system.today().year();
                    
                        //Commented because Hotelier name must be removed from the LC21_DashboardOCQuotasManagement
                        //quotasObj.currentYear = contRole.Tech_CurrentYear__c;
                        //quotasObj.hotelierName = contRole.Contact__r.Name;
                        
                        listQuotaObjectWrapps.add(quotasObj);
                    //}
                }
            }
        }
        
        if(listQuotaObjectWrapps != null && listQuotaObjectWrapps.size()>0){
            
            ret.listQuotasObject = listQuotaObjectWrapps;
            system.debug('### cg listQuotaObjectWrapps size: '+listQuotaObjectWrapps.size());
            system.debug('### cg listQuotaObjectWrapps : '+listQuotaObjectWrapps);
        }
        
        return ret;
        
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public List<QuotasObject> listQuotasObject;
    }
    
    @AuraEnabled
    public static boolean updateQuotas(string editedQuotas){
        
        system.debug('### cg editedQuotas: '+editedQuotas);
        
        list<QuotasObject> listEditedQuotas = new list<QuotasObject>();
        listEditedQuotas = (list<QuotasObject>)Json.deserialize(editedQuotas, list<QuotasObject>.class);
        system.debug('### cg listEditedQuotas: '+listEditedQuotas);
        
        list<Hotel__c> listHotelsToUpdate = new list<Hotel__c>();
        
        for(QuotasObject quotaObj : listEditedQuotas){
            
            Hotel__c hot = new hotel__c();
            hot.Id = quotaObj.hotelId;
            hot.Maximun_invitations__c = quotaObj.maxInvit;
            
            listHotelsToUpdate.add(hot);
        }
        system.debug('### cg listHotelsToUpdate: '+listHotelsToUpdate);
        if(listHotelsToUpdate != null && listHotelsToUpdate.size()>0){
            
            try{
                
                update listHotelsToUpdate;
                return true;
            } catch(Exception e){
                
                return false;
            }
        }
        else{
            
            return false;
        }
    }
}