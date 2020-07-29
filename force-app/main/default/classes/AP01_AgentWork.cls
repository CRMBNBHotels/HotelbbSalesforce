/**
 * @author TMA-EI JK
 * @date 27/03/2019
 * @description flag the case when the owner is changed based on agent work to launch the WF
 */
public class AP01_AgentWork {
    /*Public static void FlagCase(List<Account> listAW){
        Set<String> setCaseId = new Set<String>();
        List<Case> listCaseToUpate = new  List<Case>();
        for(AgentWork aw:listAW){
            String workItem = aw.WorkItemId;
            if(workItem.substring(0,3)=='500' && (aw.Status == 'Assigned' )){
                setCaseId.add(workItem);
            }
        }
        
        if(setCaseId != null && setCaseId.size()>0){
            List<Case> listCase = [select id, TechChangeOwner__c 
                         from case
                         where id in :setCaseId];
            for(Case cas:listCase){
                cas.TechChangeOwner__c = !cas.TechChangeOwner__c;
                listCaseToUpate.add(cas);
            }
        }
        
        if(listCaseToUpate != null && listCaseToUpate.size()>0){
            update listCaseToUpate;
        }
    }*/
}