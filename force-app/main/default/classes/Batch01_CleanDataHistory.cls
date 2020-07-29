/*
* @author: Georges Hobeika
* This batch is used to delete data from the environment. The new architecture is to keep bookings for maximum 4 months.
  A label is created to define the number of the months from which we need to delete data.
  The records that are deleted in this class are : Master Booking - Booking - Booking Room Line (Booking Room Line has a detail relation with Booking, will be deleted automatically)
  The scenario that a booking room line that is attached to a new booking (through update) is not taken into consideration. To do so a new batch should be created.
  The field Max_Departure__c to be used by the Test team instead of System CreationDate
* @date: 03/01/2019
* @Test: Batch01_CleanDataHistory_Test

*/
global without sharing class Batch01_CleanDataHistory implements Database.Batchable<sObject>{
    
    String masterBookingRT = Label.MasterBookingRTDevName;
    String bookingRT = Label.BookingRecordTypeName;
    Integer dataCleanFromMonth = Integer.valueOf(Label.DataCleanFromMonth);
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Set<String> setRecordTypes = new Set<String>{bookingRT,masterBookingRT };
        Date fromDate = Date.today().addMonths(-dataCleanFromMonth);
        String query = 'SELECT Id FROM Opportunity WHERE RecordType.DeveloperName IN :setRecordTypes ' +
                       'AND Max_Departure__c < :fromDate';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> listBookings) {
        List<Data_Clean_Logs__c> listLogsToInsert = new List<Data_Clean_Logs__c>();
        Database.DeleteResult[] drList = Database.delete(listBookings, false);
        
        String message;
        for(Database.DeleteResult dr : drList) {
            if(! dr.isSuccess() || Test.isRunningTest()) {
                message = null;
                for(Database.Error error : dr.getErrors()) {
                    message += error + ';';
                }
                listLogsToInsert.add(new Data_Clean_Logs__c(JobName__c = 'Batch01_CleanDataHistory', RecordId__c = dr.getId(), Message__c = message));                
            }
        }
        
        if(listLogsToInsert.size() > 0) {
            insert listLogsToInsert;
        } 
    }
    
    global void finish(Database.BatchableContext BC) {}
}