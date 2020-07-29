/* Ticket N : CRMSS - 354
* Description : This class is used to calculate the number of Master Booking Checked on a person account for marketing cloud
* Author : TMA EI - JK
* Test Class :
*/
public without sharing class AP15_Opportunity {
    //if a master booking is being inserted:
    //if the person account it's associated to's Total_Transactions__pc field is null, then we set it to one 
    //if not then it's value is incremented by 1
    Public static map<id,account> CalculateOnInsert(List<Opportunity> listOppInsert,map<id,account> mapAccountsToUpdate){
        for(Opportunity opp:listOppInsert)
        {
            if(opp.Person_Account__c != null && mapAccountsToUpdate.containsKey(opp.Person_Account__c)){
                
                Account parentAcc = mapAccountsToUpdate.get(opp.Person_Account__c);
                
                if(parentAcc.Total_Transactions__pc==null || parentAcc.Total_Transactions__pc<=0)
                {
                    parentAcc.Total_Transactions__pc=1;
                }
                else
                {
                    parentAcc.Total_Transactions__pc+=1;
                }
            }
        }
        return mapAccountsToUpdate;
    }
    
    //if a master booking is being updated:
    //if it was checked and was associated to a person account. then that person's account Total_Transactions__pc field is decreased by 1 and the new person account's Total_Transactions__pc field is 
    //incremented by 
    //if it was or is unchecked, then the person account it was/is related to Total_Transactions__pc remains unchanged
    Public static map<id,account> CalculateOnUpdate(List<Opportunity> listOppUpdate, Map<Id,Opportunity> MapOppOld,Map<id,Account> mapAccountsToUpdate){
        
        for(Opportunity opp:listOppUpdate)
        {
            Account parentAcc;
            Account parentAccOld;
            if(opp.Person_Account__c!=null && mapAccountsToUpdate.containsKey(opp.Person_Account__c)){
                
                parentAcc =mapAccountsToUpdate.get(opp.Person_Account__c);
                
                if(parentAcc.Total_Transactions__pc == null){
                    
                    parentAcc.Total_Transactions__pc = 0;
                }
            }
            if(MapOppOld.get(opp.id).Person_Account__c !=null && mapAccountsToUpdate.containsKey(MapOppOld.get(opp.id).Person_Account__c)){
                
                parentAccOld =mapAccountsToUpdate.get(MapOppOld.get(opp.id).Person_Account__c);
                
                if(parentAccOld.Total_Transactions__pc == null){
                    
                    parentAccOld.Total_Transactions__pc = 0;
                }
            }
            
            //if(opp.StageName!=MapOppOld.get(opp.id).stagename && opp.StageName == Label.StageNameBooking_Checked){
            if(opp.Bookings_Checked_Count__c != MapOppOld.get(opp.id).Bookings_Checked_Count__c && parentAcc != null){
                
                 if(opp.Bookings_Checked_Count__c > 0 && (MapOppOld.get(opp.id).Bookings_Checked_Count__c<=0||MapOppOld.get(opp.id).Bookings_Checked_Count__c==null)){
                    
                        parentAcc.Total_Transactions__pc++;
                    
                }
                else if (opp.Bookings_Checked_Count__c <= 0 && MapOppOld.get(opp.id).Bookings_Checked_Count__c>0) {
                        parentAcc.Total_Transactions__pc--;
                }
            }
            
           // if(opp.Person_Account__c!=MapOppOld.get(opp.id).Person_Account__c &&  opp.StageName==MapOppOld.get(opp.id).stagename ){
           if(opp.Person_Account__c != MapOppOld.get(opp.id).Person_Account__c && opp.Bookings_Checked_Count__c>0){
               
                if(parentAcc != null){
                    
                    parentAcc.Total_Transactions__pc++;
                }
                if(parentAccOld != null){
                    
                    parentAccOld.Total_Transactions__pc--;
                    
                    if(parentAccOld.Total_Transactions__pc<0)
                    {
                        parentAccOld.Total_Transactions__pc++;
                    }
                }
            }
            
            
        }
        return mapAccountsToUpdate;
    }
    
    //if a master booking is being deleted:
    //if the person account it's associated to's Total_Transactions__pc field is null, then we set it to zero 
    //if not then it's value is decreased by 1
    Public static map<id,account> CalculateOnDelete(List<Opportunity> listOppDelete,map<id,account> mapAccountsToUpdate){
        Set<id> setAccountIds=new Set<id>();
        
        for(Opportunity opp:listOppDelete)
        {
            if(opp.Person_Account__c!=null && mapAccountsToUpdate.containsKey(opp.Person_Account__c)){
                Account parentAcc=mapAccountsToUpdate.get(opp.Person_Account__c);
                if(parentAcc.Total_Transactions__pc==null)
                {
                    parentAcc.Total_Transactions__pc=0;
                }
                else
                {
                    parentAcc.Total_Transactions__pc-=1;
                }
                
                if(parentAcc.Total_Transactions__pc<0)
                {
                    parentAcc.Total_Transactions__pc=0;
                }
            }
        }
        return mapAccountsToUpdate;
        
    }
    
}