/* Description : This class is used to filter / update records and call other classes
* @Author: TMA EIL CG
* @Date: 13/12/2019
* @Test Class : OpportunityHandlerTest
* @Coverage: 79 %
*/
public without sharing class OpportunityHandler {
    
    //Added by TMA-EIL CG CRMSS-398 - 12/12/2019 - Start
    //This methods filters bookings 
    public static Map<String,String> filterBookingsBatch_UpdateMB_ConfNb_HotelName(List<Opportunity> listOpp){
        
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        
        Map<String,String> mapMBIdErrors = new Map<String,String>();//Masterbookings that were not updated in AP12_Opportunity will be saved in this map and returned to the batch Batch_UpdateMB_ConfNb_HotelName
        map<string, list<Opportunity>> mapMBlistBookings = new map<string, list<opportunity>>();//filtered bookings along with their masterbokings will be saved in this map
        
        //Loop over retrieved bookings from the batch Batch_UpdateMB_ConfNb_HotelName to filter them 
        for(Opportunity opp :listOpp){
            
            if(opp.RecordTypeId == bookingRTId && opp.Master_Booking_FK__c != null && ((opp.Confirmation_Number__c != null && opp.Confirmation_Number__c != '' && string.isNotBlank(opp.Confirmation_Number__c)) 
                                                                                       || (opp.Hotel_Name__c != null && opp.Hotel_Name__c != '' && string.isNotBlank(opp.Hotel_Name__c)))){
                                                                                           
                                                                                           if(!mapMBlistBookings.containsKey(opp.Master_Booking_FK__c)){
                                                                                               
                                                                                               list<opportunity> listToPut = new list<opportunity>();
                                                                                               listToPut.add(opp);
                                                                                               mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                                                                           }
                                                                                           else{
                                                                                               
                                                                                               list<opportunity> listToPut = mapMBlistBookings.get(opp.Master_Booking_FK__c);
                                                                                               listToPut.add(opp);
                                                                                               mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                                                                           }
                                                                                       }
        }
        
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            
            mapMBIdErrors = AP12_Opportunity.updateMasterBooking(mapMBlistBookings);
        }
        
        return mapMBIdErrors;
        
    }
    //Added by TMA-EIL CG CRMSS-398 - 12/12/2019 - End
    
    //Added by TMA-EIL CG CRMSS-399 - 19/12/2019 - Start
    public static Map<String, String> filterBookingsBatch_UpdateMB_Nights_Rooms_StageCount(List<Opportunity> listOpp){
        
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        
        Map<String,String> mapMBIdErrors = new Map<String,String>();//Masterbookings that were not updated in AP11_Opportunity will be saved in this map and returned to the batch Batch_UpdateMB_Nights_Rooms_StageCount
        map<string, list<Opportunity>> mapMBlistBookings = new map<string, list<opportunity>>();//filtered bookings along with their masterbokings will be saved in this map
        Map<String,Boolean> mapMBFlag = new Map<String,Boolean>();
        
        //Loop over retrieved bookings from the batch Batch_UpdateMB_Nights_Rooms_StageCount to filter them 
        if(listOpp != null && listOpp.size()>0){
            
            for(Opportunity opp :listOpp){
                
                if(opp.RecordTypeId == bookingRTId && opp.Master_Booking_FK__c != null && ( (opp.Number_of_nights__c != null && opp.Number_of_nights__c != 0) 
                                                                                           || (opp.Chambre__c != null && opp.Chambre__c != 0) || (opp.StageName != null && opp.StageName != '' && string.isNotBlank(opp.StageName)) )){
                                                                                               
                                                                                               if(!mapMBlistBookings.containsKey(opp.Master_Booking_FK__c)){
                                                                                                   
                                                                                                   list<opportunity> listToPut = new list<opportunity>();
                                                                                                   listToPut.add(opp);
                                                                                                   mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                                                                                   mapMBFlag.put(opp.Master_Booking_FK__c,opp.Master_Booking_FK__r.TechIsNotFirst_01__c);
                                                                                               }
                                                                                               else{
                                                                                                   
                                                                                                   list<opportunity> listToPut = mapMBlistBookings.get(opp.Master_Booking_FK__c);
                                                                                                   listToPut.add(opp);
                                                                                                   mapMBlistBookings.put(opp.Master_Booking_FK__c, listToPut);
                                                                                               }
                                                                                           }
                
                
            }
        }
        
        if(mapMBlistBookings != null && mapMBlistBookings.size()>0){
            system.debug('Opportunity handler ##### mapMBlistBookings ' + mapMBlistBookings);
            AP11_Opportunity.mapMBFlag = mapMBFlag;
            mapMBIdErrors = AP11_Opportunity.updateMasterBooking(mapMBlistBookings);
        }
        
        return mapMBIdErrors;	
    }
    //Added by TMA-EIL CG CRMSS-399 - 19/12/2019 - End              
    
    //Added by TMA-EIL JKA CRMSS-401 - 18/12/2019 - Start
    //This methods filters bookings and call  AP09_Opportunity
    public static Map<String,String> filterBookings_Batch_HotelCountChecked(List<Opportunity> listBookings){
        
        map<String,Boolean> mapPAFirst = new map<String,Boolean>();
        Map<String,String> mapBIdErrors = new Map<String,String>();
        map<string,list<Opportunity>> mapPAlistBooking = new map<string,list<opportunity>>();
        Set<String> setPAID = new Set<String>();
        
        if(listBookings != null && listBookings.size()>0){
            
            for(Opportunity book : listBookings){
                
                if(book.Booking_Person_account__c!=null){
                    setPAID.add(book.Booking_Person_account__c);
                }
                if(book.OldParentAccount__c!=null){
                    setPAID.add(book.OldParentAccount__c);
                }
                //mapPAFirst.put(book.Booking_Person_account__c,book.Booking_Person_account__r.TechIsNotFirst__c);
                if(book.OldParentAccount__c!=null){
                    mapPAFirst.put(book.OldParentAccount__c,book.OldParentAccount__r.TechIsNotFirst__c);
                }
                else{
                    mapPAFirst.put(book.Booking_Person_account__c,book.Booking_Person_account__r.TechIsNotFirst__c);
                }
                
                if(book.Booking_Person_account__c != null && book.StageName == Label.StageNameBooking_Checked && book.Hotel_Name__c != null && book.Hotel_Name__c != '' && !book.IsDeleted){
                     
                    if(!mapPAlistBooking.containskey(book.Booking_Person_account__c)){
                        list<Opportunity> listToPut = new list<opportunity>();
                        listToPut.add(book);
                        mapPAlistBooking.put(book.Booking_Person_account__c, listToPut);
                        
                    }
                    else{
                        
                        list<Opportunity> listToPut = mapPAlistBooking.get(book.Booking_Person_account__c);
                        listToPut.add(book);
                        mapPAlistBooking.put(book.Booking_Person_account__c, listToPut);
                    }
                }
            }
            
            if(setPAID!=null&& setPAID.size()>0){
                
                AP09_Opportunity.mapPAFirst = mapPAFirst;
                mapBIdErrors=AP09_Opportunity.CheckedHotelsCount(mapPAlistBooking,setPAID);
            }
        }
        
        return mapBIdErrors;
    }
    
    //Added by TMA-EIL JKA CRMSS-401 - 18/12/2019 - End
    
    //Added by TMA-EIL JKA CRMSS-285 - 02/02/2020 - Start
    public static Map<String,String> filterBookings_Batch_PartnershipFieldsUpdate(List<Opportunity> listBookings){
        
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        
        map<String,Boolean> mapAccFlag = new map<String,Boolean>();
        Map<String,String> mapAccIdErrors = new Map<String,String>();
        map<string,list<Opportunity>> mapAcclistBooking = new map<string,list<opportunity>>();
        
        if(listBookings != null && listBookings.size()>0){
            
            for(Opportunity book : listBookings){

                if(book.RecordTypeId == bookingRTId && book.PartnerCode__c != null && book.OnTheCurrentYear__c && book.StageName == Label.StageNameBooking_Checked 
                   && (book.Invoiced_amount__c != null || book.Number_of_nights__c != null || book.Master_Booking_FK__c != null) ){
                       
                       if(!mapAcclistBooking.containsKey(book.PartnerCode__c)){
                           
                           list<opportunity> listToPut = new list<opportunity>();
                           listToPut.add(book);
                           mapAcclistBooking.put(book.PartnerCode__c, listToPut);
                           mapAccFlag.put(book.PartnerCode__c,book.PartnerCode__r.TechIsNotFirst_03__c);
                       }
                       else{
                           
                           list<opportunity> listToPut = mapAcclistBooking.get(book.PartnerCode__c);
                           listToPut.add(book);
                           mapAcclistBooking.put(book.PartnerCode__c, listToPut);
                       }
                   }
            }
        }
        
        if(mapAcclistBooking !=null && mapAcclistBooking.size()>0){
            
            AP03_Opportunity.mapAccFlag = mapAccFlag;
            mapAccIdErrors = AP03_Opportunity.updatePartnershipFields(mapAcclistBooking);
        }
        
        return mapAccIdErrors;
    }
    
    //Added by TMA-EIL JKA CRMSS-285 - 02/02/2020 - End
}