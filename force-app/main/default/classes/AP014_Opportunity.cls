public without sharing class AP014_Opportunity {
    Public Static Void ReCalculateContract(list<opportunity> listOppNew, map<id,opportunity> mapOppOld){
        set<id> setOppId = new set<id>();
        for(Opportunity opp :listOppNew){
            if(opp.accountId != mapOppOld.get(opp.ID).accountId || opp.contact__c != mapOppOld.get(opp.ID).contact__c){
                setOppId.add(opp.id);
            }
        }
        List<Contract> listContractToUpdate = [select id,recordtypeId,opportunity__c from contract where opportunity__c in :setOppId];
        if(listContractToUpdate != null && listContractToUpdate.size()>0){
            system.debug('@@@@ ap014 Change ');
            AP02_Contract.fillContactAndAccount(listContractToUpdate,null,True);
        }
    }

}