/*--------------------------------------------------------------------------------------------------------------------------
Author: Bachir Asmar
Company: EI-Technologies
Description:  Batch pour Supprimer les BookingRoomLines Obsolete (Obsolete__c = True) et qui sont modifiés depuis 2 jours ou plus avant le lancement du batch (LastModifiedDate < YESTERDAY)
Test Class: Batch_DeleteBookingRoomLineObsolete_Test 

History
-- Date         Name  Version  Remarks 
-- -----------  ----  -------  -----------------------------
-- 11/04/2019   BAS   1.0      Initial version 
---------------------------------------------------------------------------------------------------------------------------*/

global  class Batch_DeleteBookingRoomLineObsolete implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {        
        Date fromDate = Date.today().addDays(-2);
        string query = 'Select id,LastModifiedDate from Booking_Room_Line__c where Obsolete__c = True and LastModifiedDate < :fromDate';
        if (test.isRunningTest()) 
        {
           query = 'Select id,LastModifiedDate from Booking_Room_Line__c where Obsolete__c = True';
        }
        
        system.debug('#### Query ' + query);
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, list<sObject> scope)
    {
        List<Booking_Room_Line__c> BRLs = (List<Booking_Room_Line__c>)scope;
        
        if(BRLs.size() > 0){
            Delete BRLs;
        }
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}