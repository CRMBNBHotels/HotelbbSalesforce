/*
* Description: Controller class for LC_Test
* @author: TMA-EI CG
* @date: 06/11/2020
* @Test class: LCC01_DashboardOCQuotas_Test
* @Coverage: 87%
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
        Double nbExistingVouchOc = 0;
        string role = '';
        string clientName = '';
        
        if(userEmail != null && userEmail !=''){
            
            listContRole = [Select Id, Role__c, Contact__r.Email From Contact_Role__c Where Contact__r.Email =: userEmail Limit 1];
            
            if(listContRole != null && listContRole.size()>0){
                
                role = listContRole[0].Role__c;
            }
            
            listMV = [Select Id , Nombre_de_copie_s__c, Pr_nom_Nom_de_l_m_tteur__r.Email From Master_Voucher__c where Pr_nom_Nom_de_l_m_tteur__r.Email =: userEmail];
            system.debug('### cg listMV'+listMV);
            
            if(listMV != null && listMV.size()>0){
                
                for(Master_Voucher__c mvOC : listMV){
                    
                    nbExistingVouchOc = nbExistingVouchOc + mvOC.Nombre_de_copie_s__c;
                }
            }
            
            if(role != null && role != '' && role == 'IR-OC'){
                
                ret.nbAvailableVouch = 10 - nbExistingVouchOc;
                ret.remainingVouchOC = 10 - nbExistingVouchOc - nbCopies;
                system.debug('### cg apx ret.remainingVouchOC'+ret.remainingVouchOC);
                system.debug('### cg apx nbExistingVouchOc'+nbExistingVouchOc);
            }
            else{
                
                ret.nbAvailableVouch = 200 - nbExistingVouchOc;
                ret.remainingVouchOC = 200 - nbExistingVouchOc - nbCopies;system.debug('### cg apx ret.remainingVouchOC'+ret.remainingVouchOC);
            }
            
        }
        
        system.debug('### cg listContRole'+listContRole);
        system.debug('### cg listContRole[0].Role__c'+listContRole[0].Role__c);
        
        return ret;
    }
    
    public class ReturnedInfo{
        
        @AuraEnabled public double remainingVouchOC;
        @AuraEnabled public double nbAvailableVouch;
    }
    
    @AuraEnabled
    public static Id GetPersonAccount(string clientExtId){
        
        string clientName = '';
        Id PASFId;
        
        if(clientExtId != null && clientExtId != ''){
            
            list<Account> listPA = new list<Account>([Select Id, FirstName, LastName, Externalid__pc
                                                      From Account
                                                      Where Externalid__pc =: clientExtId
                                                      Limit 1]);
            
            if(listPA != null && listPA.size()>0){
                
                clientName = listPA[0].FirstName + ' ' + listPA[0].LastName;
                PASFId = listPA[0].Id;
                
            }
        }
        
        return PASFId;
    }		

    
}