/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Shiksha 
* @date: 02/04/2021
* @details : 
*
* -- Date         Name        Version  Remarks
* -- -----------  ----------  -------  ---------------------------------------
* -- 02-APR-2021  Shiksha      1.0     CRMSS-836 - GDPR - Visibility Booking
* -- 
* @TestClass : AP01_ObjectShare_Test
***************************************************************************************************************************************************************************/
Global class Batch_ObjectShareCatchUp implements Database.Batchable<sObject>, Database.stateful{
  global String query;
  global String objectName;
  global String shareObject; 

    global Batch_ObjectShareCatchUp(String aQuery, string aObjName, String aShareObject) {
        query = aQuery;
        objectName = aObjName;
        shareObject = aShareObject;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){       
        Database.QueryLocator qloc = Database.getQueryLocator(query); 
        return qloc;    
    }
    
    global void execute(Database.BatchableContext BC, list<SObject> SobjList){
        Map<Id, SObject> sObjMap = New Map<Id, SObject>();

        for (SObject obj: SobjList){
            sObjMap.put(obj.Id,obj);
        }

        if (shareObject == 'Booking__c'){
            AP01_ObjectShare.createBookingShare(sObjMap);
        }else if (shareObject =='Account'){
            if (objectName == 'Booking__c'){            
                AP01_ObjectShare.createAccountShare(sObjMap,'Booking__c');  
            }else{         
                AP01_ObjectShare.createAccountShare(sObjMap,'Case');  
            }
        }  
    }
        
    global void finish(Database.BatchableContext BC){
        
    }
}