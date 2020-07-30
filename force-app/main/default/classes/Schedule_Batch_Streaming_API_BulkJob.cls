Global without sharing class Schedule_Batch_Streaming_API_BulkJob implements Schedulable,  Database.AllowsCallouts{
    global void execute(SchedulableContext ctx) {
       CRL01_StreamingAPIForBulk.getUpdateBulkJob();
    }
}