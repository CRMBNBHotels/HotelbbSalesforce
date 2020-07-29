/*
* Description: CRMSS - 458 Batch to create KPIReports_TopLoyaltyProgram__c recordsfrom bookings
* @author: TMA-EIL
* @date: 07/02/2020
* @Test: Batch_BBH_KPIs_Test
* @Coverage: 86 %
*/
Global without sharing class Batch_BBH_KPIs implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        string query;
        
        //query for all bookings that were last modified yesterday
        query = 'select id, Hotel_Name__c, Invoiced_amount__c, CreatedDate, HotelCountry__c, StageName, Booking_Person_account__c, Booking_Person_account__r.Date_of_e_club_purchase__pc, Booking_Person_account__r.E_club_Expiration_date__pc from opportunity '+System.Label.Batch_BBH_KPIs_WhereClause;        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<Opportunity> listBookings){
        
        list<KPIReports_TopLoyaltyProgram__c> listKPIReportsToUpsert = new list<KPIReports_TopLoyaltyProgram__c>();
        
        if(listBookings != null && listBookings.size()>0){
            
            set<string> setBookIds = new set<string>();  
            map<string, KPIReports_TopLoyaltyProgram__c> mapExistingKPIReports = new map<string, KPIReports_TopLoyaltyProgram__c>();
            
            for(Opportunity book : listBookings){
                
                //Store booking Ids to check whether KPIReports objects were already created for these bookings
                setBookIds.add(book.Id);
            }
            
            if(setBookIds != null && setBookIds.size()>0){
                
                for(KPIReports_TopLoyaltyProgram__c obj : [select id, Booking_Id__c from KPIReports_TopLoyaltyProgram__c where Booking_Id__c != null and Booking_Id__c IN:  setBookIds]){
                    
                    //store KPIReports objects that were already created for the bookings retrieved
                    mapExistingKPIReports.put(obj.Booking_Id__c, obj);
                }
            }
            
            for(Opportunity book : listBookings){
                    
                KPIReports_TopLoyaltyProgram__c kpiReportObj = new KPIReports_TopLoyaltyProgram__c();
                
                kpiReportObj.Booking_Id__c = book.Id;
                kpiReportObj.Booking_date__c = date.valueOf(book.CreatedDate);
                
                if(book.Hotel_Name__c != null && book.Hotel_Name__c != '' && string.isNotBlank(book.Hotel_Name__c)){
                    
                    kpiReportObj.Booking_Hotel__c = book.Hotel_Name__c;
                }
                
                if(book.Invoiced_amount__c != null){
                    
                    kpiReportObj.Booking_Amount__c = book.Invoiced_amount__c;
                }
                
                if(book.HotelCountry__c != null && book.HotelCountry__c != '' && string.isNotBlank(book.HotelCountry__c)){
                    
                        kpiReportObj.Booking_Country__c = book.HotelCountry__c;
                }
                
                if(book.CreatedDate >= book.Booking_Person_account__r.Date_of_e_club_purchase__pc || book.CreatedDate <= book.Booking_Person_account__r.E_club_Expiration_date__pc){
                    
                    kpiReportObj.Booking_EClub_Status__c = Label.BatchBBHKPIs_Members;
                }
                else{
                    
                    kpiReportObj.Booking_EClub_Status__c = Label.BatchBBHKPIs_NonMembers;
                }
                
                if(book.Booking_Person_account__c != null){
                    
                    kpiReportObj.Client_Id__c = string.valueOf(book.Booking_Person_account__c);
                }
                
                //if the map doesn't contain the booking id, that means that no KPIReports object was created for the booking yet, hence it must be created
                if(!mapExistingKPIReports.containsKey(book.Id)){
                    system.debug('### cg im inserting');
                    listKPIReportsToUpsert.add(kpiReportObj);
                }
                
                //if the map contains the booking id, that means that a KPIReports object was created for the booking already, hence it must be updated since the booking was modified
                else{
                    system.debug('### cg im updating');
                    kpiReportObj.Id = mapExistingKPIReports.get(book.Id).Id;
                    listKPIReportsToUpsert.add(kpiReportObj);
                }
            }
        }
        
        //Upsert new KPIReports Objects
        if(listKPIReportsToUpsert != null && listKPIReportsToUpsert.size()>0){
            
            database.upsert(listKPIReportsToUpsert, false);
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}