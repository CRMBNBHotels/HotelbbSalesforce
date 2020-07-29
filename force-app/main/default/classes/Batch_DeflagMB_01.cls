/*
* Description: CRMSS - 399 Batch to unflag updated masterbookings in the batch Batch_UpdateMB_Nights_Rooms_StageCount
* @author: TMA-EIL CG
* @date: 23/12/2019
* @Test: BatchUpdateMBNightsRoomsStageCount_Test
* @Coverage: 100%
*/

global without sharing class Batch_DeflagMB_01 implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //query all opportunities that are flagged, aka updated via the batch Batch_UpdateMB_Nights_Rooms_StageCount
        String query ='select id from opportunity where TechIsNotFirst_01__c = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<opportunity> listOpp){
        
        List<opportunity> listMBtoUpdate = new List<opportunity>();
        
        //deflag the returned masterbookings
        for(opportunity mbOpp  : listOpp){
            
            mbOpp.TechIsNotFirst_01__c = false;
            listMBtoUpdate.add(mbOpp);
        }
        
        Database.SaveResult[] srListMB;
        
        if(listMBtoUpdate != null && listMBtoUpdate.size()>0){
            
            srListMB = Database.update(listMBtoUpdate, false);
        }
    }
    
    global void finish(Database.BatchableContext BC){}
    
}