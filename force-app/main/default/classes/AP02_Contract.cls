/*
* Description: Class to fill the Contact and Account lookup fields of a contract related to an opportunity at insert, with the account and contact of this opportunity CRMSS - 342
* @author: TMA Cynthia Geagea
* @date: 06/11/2019
* @Test: AP02_Contract_Test
* @Coverage: 96%
*/

public without sharing class AP02_Contract {
    
    public static void fillContactAndAccount(list<Contract> listNewContracts, map<Id, contract> mapOldContracts, Boolean FromOpp){
        system.debug('@@@ ap02 fillContactAndAccount');
        set<String> setOppId = new set<String>();
        map<String,String> mapInsertContractIdOppId = new map<String,String>();
        map<String,String> mapUpdateContractIdOppId = new map<String,String>();
        map<String,Opportunity> mapContractIdOpp = new map<String,Opportunity>();
        
        String corporateOppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();system.debug('### cg corporateOppRTId'+corporateOppRTId);
        String corporateContRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();system.debug('### cg corporateContRTId'+corporateContRTId);
        String carteLogeeContRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Carte_Log_e').getRecordTypeId();
        
        if(listNewContracts != null && listNewContracts.size()>0 && mapOldContracts == null){
            
            for(Contract cont : listNewContracts){
                
                if((cont.recordtypeId == corporateContRTId ||cont.recordtypeId == carteLogeeContRTId) && cont.Opportunity__c != null){
                    
                    //setContractId.add(cont.Id);
                    setOppId.add(cont.Opportunity__c);
                }
            }
        }else if(mapOldContracts != null && mapOldContracts.size()>0 && listNewContracts != null && listNewContracts.size()>0){
            
            for(Contract cont : listNewContracts){
                
                if((cont.recordtypeId == corporateContRTId||cont.recordtypeId == carteLogeeContRTId) &&  (cont.Opportunity__c != mapOldContracts.get(cont.id).Opportunity__c)){
                    
                    //setContractId.add(cont.Id);
                    if(cont.Opportunity__c != null){
                        setOppId.add(cont.Opportunity__c);
                    }
                }
            }
        }
        
        Map<ID, Opportunity> mapOppToUpdate = new Map<ID, Opportunity>();
        system.debug('### setOppId ' + setOppId);
        if(setOppId != null && setOppId.size()>0){
            mapOppToUpdate = new Map<ID, Opportunity>([select id,AccountId,contact__c
                                                       from Opportunity
                                                       where id in :setOppId 
                                                       //and Recordtype.DeveloperName = 'Corporate'
                                                       ]);  
            system.debug('### mapOppToUpdate ' + mapOppToUpdate);
        }
        for(Contract cont : listNewContracts){
            if(cont.opportunity__c != null && mapOppToUpdate.containsKey(cont.opportunity__c)){
                cont.AccountId = mapOppToUpdate.get(cont.opportunity__c).AccountId;
                cont.contact__c = mapOppToUpdate.get(cont.opportunity__c).Contact__c;
            }else if(mapOldContracts!=null && mapOldContracts.get(cont.id).Opportunity__c!=null && cont.Opportunity__c != mapOldContracts.get(cont.id).Opportunity__c){
                system.debug('### cont ' + cont.Opportunity__c + ' ' + mapOldContracts.get(cont.id).Opportunity__c);
                cont.AccountId = null;
                cont.contact__c = null;
            }
             system.debug('### cont opportunity__c ' + cont.opportunity__c);
             
            system.debug('### cont Contact__c ' + cont.Contact__c);
        }
        system.debug('listNewContracts ' + listNewContracts);
         system.debug('FromOpp ' + FromOpp);
        if(FromOpp){
            if(listNewContracts != null && listNewContracts.size()>0){
                update listNewContracts;
            }
        }
    }
    
}