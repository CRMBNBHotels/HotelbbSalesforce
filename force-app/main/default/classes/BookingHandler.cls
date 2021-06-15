/**
* @author TMA-EIT CG
* @date 24/11/2020
* @description: Booking Object Handler, containing all trigger events
* @test class : AP01_Booking_Test, AP01_ObjectShare_Test
* @coverage: 81%
*/

public with sharing class BookingHandler {

        // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public BookingHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnAfterInsert(Booking__c[] newRecords, Map<ID, Booking__c> newMap){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Booking') ) 
           || !UtilsBypass.canISkipApexClass('AP01_Booking') || !UtilsBypass.canISkipApexMethod('updatePAMarketingFields')){
            AP01_Booking.updatePAMarketingFields(newRecords);
           }  
        //CRMSS-836
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_ObjectShare') ) 
           || !UtilsBypass.canISkipApexClass('AP01_ObjectShare') || !UtilsBypass.canISkipApexMethod('createBookingShare')){
            AP01_ObjectShare.createBookingShare(newMap);
            AP01_ObjectShare.createAccountShare(newMap,'Booking__c');
        } 
    }
    
    public void OnAfterUpdate(Booking__c[] newRecords, Map<ID, Booking__c> recordMapOld){  
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP01_Booking')) 
           || !UtilsBypass.canISkipApexClass('AP01_Booking') || !UtilsBypass.canISkipApexMethod('updatePAMarketingFields')){
               
               list<Booking__c> filteredRecords = new list<Booking__c>();
               
               for(Booking__c book : newRecords){
                   
                   if( (book.stage__c == 'Booked' || book.stage__c == 'Checked') && book.Hotel__c != recordMapOld.get(book.Id).Hotel__c ){
                       
                       filteredRecords.add(book);
                   }
               }
               
               if(filteredRecords != null && filteredRecords.size()>0){
                   
                   AP01_Booking.updatePAMarketingFields(filteredRecords); 
               }
           } 
    }
    
    public void OnBeforeUpdate(Booking__c[] newRecords, Map<ID, Booking__c> recordMapOld){  
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_Booking')) 
           || !UtilsBypass.canISkipApexClass('AP02_Booking') || !UtilsBypass.canISkipApexMethod('fillChannelName'))
        {
            AP02_Booking.fillChannelName(newRecords, recordMapOld);
        } 
    }
    
    public void OnBeforeInsert(Booking__c[] newRecords){
        if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('AP02_Booking') ) 
           || !UtilsBypass.canISkipApexClass('AP02_Booking') || !UtilsBypass.canISkipApexMethod('fillChannelName'))
        {
            AP02_Booking.fillChannelName(newRecords, null);
        }   
    }
    
    public boolean IsTriggerContext{get{ return m_isExecuting;}}
    public boolean IsVisualforcePageContext{get{ return !IsTriggerContext;}} 
    public boolean IsWebServiceContext{get{ return !IsTriggerContext;}}
    public boolean IsExecuteAnonymousContext{get{ return !IsTriggerContext;}}
}