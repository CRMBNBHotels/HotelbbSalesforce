/*
* Description: 
* @author: Jenny Jawhar
* @date: 22/09/2017
* @Test: Utils_Test
*/
public class Utils {
    public static Account CreatePersonAccount(string Name, string companyId){
        Account acc = new Account(lastName = Name, recordTypeId = Label.PersonAccountRecordTypeId,
                                  Current_Compagny__pc = companyId, BillingCountry = 'France');//, recordTypeId = Label.PersonAccountRecordTypeId
        return acc;
    }
    public static Contact CreateContact(string Name,string AccountId,string language){
        Contact cont = new Contact(lastName=Name, AccountId = AccountId, language__c=language);
        return cont;
    }
    public static Account CreatePartnerAccount(string Name, string partnerCode){
        Account acc = new Account(Name = Name,  Partner_Code__c = partnerCode, BillingPostalCode = '12345', BillingCountry = 'France');//recordTypeId = label.PartnerRecordTypeID,
        return acc;
    }
    public static Opportunity CreateBookingOpportunity(string Name){
        Opportunity Opp = new Opportunity(Name = Name, CloseDate=date.Today(), recordTypeId = Label.BookingRecordTypeId);
        return Opp;
    }
    public static Opportunity CreateMasterBookingOpportunity(string Name, string accId){
        Opportunity opp = new Opportunity(Name = Name, CloseDate=date.Today(), StageName = label.ClosedWonStage,
                                          Person_Account__c = accId, recordTypeId = Label.MasterBookingRecordTypeId);
        return opp;
    }
    public static Booking_Room_Line__c CreateBookingRoomLine(string bookingId){
        Booking_Room_Line__c roomLine = new Booking_Room_Line__c(Booking_FK__c = bookingId);
        return roomLine;
    }
    public static Booking_Room_Line_Price__c CreateBookingRoomLinePrice(string bookingRoomLineId, decimal price){
        Booking_Room_Line_Price__c roomPrice = new Booking_Room_Line_Price__c(Booking_Room_Line_FK__c = bookingRoomLineId, Price_euros__c = price);
        return roomPrice;
    }
    public static Contract CreateContract(){
        Contract cont = new Contract();
        return cont;
    } 
    public static Hotel__c CreateHotel(string hotelId){
        Hotel__c hotel = new Hotel__c(Hotel_ID__c = hotelId);
        return hotel;
    } 
    public static Product2 CreateProduct(){
        Product2 prod = new Product2();
        return prod;
    }
    public static Case CreateCase(){
        Case cas = new Case();
        return cas;
    }
    public static Hotel_Room_Option__c CreateHotelRoomOptionAndCode(){
        Hotel_Room_Option__c hotelRoomOptionAndCode = new Hotel_Room_Option__c();
        return hotelRoomOptionAndCode;
    }
    public static Stay__c CreateStay(string AccountId, string BookingId){
        Stay__c stay = new Stay__c(Guest_Account__c = AccountId , Booking__c = BookingId);
        return stay;
    }
    public static Messaging.SingleEmailMessage CreateSingleEmailMessage(string[] toAddresses,string[] CcAddresses,Id targetId,
                                                                        Id whatId,string templateId,string ReplyEmail){
        Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();                    
        singleEmailMessage.setTargetObjectId(targetId);
        singleEmailMessage.setWhatId(whatId);       
        singleEmailMessage.setTemplateId(templateId);
        singleEmailMessage.setToAddresses(toAddresses);
        singleEmailMessage.setCcAddresses(CcAddresses);
        singleEmailMessage.SetReplyTo(ReplyEmail);  
        singleEmailMessage.setSenderDisplayName(ReplyEmail);
        return singleEmailMessage;
    }
    public static Integer getBatchSize(string aClassName){
        Integer batchSize = 200;
        List<CMT003_BatchSize__mdt> batchsizeList = [SELECT Id, BatchSize__c, ApexClass__c
                                                        FROM CMT003_BatchSize__mdt
                                                        WHERE ApexClass__c =:aClassName];   
        if (batchsizeList != null && batchsizeList.Size() > 0){
            batchSize = batchsizeList[0].BatchSize__c != null ? Integer.ValueOf(batchsizeList[0].BatchSize__c) : 200;
        }
        return batchSize;
    }
    
    public static Task CreateTask(string tskStatus, string tskWhoId, string tskWhatId,date tskWDueDate, string tskPriority, string tskSubject, string tskDescription){
        Task tsk = new Task();
        tsk.Status=tskStatus;
        tsk.WhoId=tskWhoId;
        tsk.WhatId=tskWhatId;
        tsk.ActivityDate=tskWDueDate;
        tsk.Priority=tskPriority;
        tsk.Subject=tskSubject;
        tsk.description=tskDescription;
        return tsk;
    }

}