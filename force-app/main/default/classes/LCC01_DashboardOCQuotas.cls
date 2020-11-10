/*
* Description: Controller class for LC_Test
* @author: TMA-EI CG
* @date: 06/11/2020
* @Test class: LCC01_DashboardOCQuotas_Test
* @Coverage: 100%
* @Lightning Components: LC_Test
*/

public without sharing class LCC01_DashboardOCQuotas {

    @AuraEnabled
    public static ReturnedInfo GetRemainingQuotas(string userEmail, integer nbCopies) {
        
        system.debug('### cg apx userEmail'+userEmail);
        system.debug('### cg apx nbCopies'+nbCopies);

        ReturnedInfo ret = new ReturnedInfo();
        List<Master_Voucher__c> listMV = new List<Master_Voucher__c>();
        Double nbExistingVouchOc = 0;

        list<Contact_Role__c> listContRole = new list<Contact_Role__c>([Select Id, Role__c, Contact__r.Email From Contact_Role__c Where Contact__r.Email =: userEmail Limit 1]);
        system.debug('### cg listContRole'+listContRole);
        system.debug('### cg listContRole[0].Role__c'+listContRole[0].Role__c);

        if(listContRole != null && listContRole.size()>0 && listContRole[0].Role__c == 'IR-OC'){

            listMV = [Select Id , Nombre_de_copie_s__c, Pr_nom_Nom_de_l_m_tteur__r.Email From Master_Voucher__c where Pr_nom_Nom_de_l_m_tteur__r.Email =: userEmail];
            system.debug('### cg listMV'+listMV);

            if(listMV != null && listMV.size()>0){

                for(Master_Voucher__c mvOC : listMV){

                    nbExistingVouchOc = nbExistingVouchOc + mvOC.Nombre_de_copie_s__c;
                }
            }
        }system.debug('### cg apx nbExistingVouchOc'+nbExistingVouchOc);
        
        ret.nbAvailableVouch = 10 - nbExistingVouchOc;
        ret.remainingVouchOC = 10 - nbExistingVouchOc - nbCopies;system.debug('### cg apx ret.remainingVouchOC'+ret.remainingVouchOC);
        
        return ret;
    }

    public class ReturnedInfo{
        
        @AuraEnabled public double remainingVouchOC;
        @AuraEnabled public double nbAvailableVouch;
    }
}