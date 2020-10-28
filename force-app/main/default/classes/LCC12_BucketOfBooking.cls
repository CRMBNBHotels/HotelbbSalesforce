/*
* Description: Controller class for bucket of booking Component => 
* @author: TMA-EI JK
* @date: 11/06/2020
* @Test class: LCC12_BucketOfBooking_Test
* @Coverage: 100%
* @Lightning Components: LC12_BucketOfBooking
*/
public class LCC12_BucketOfBooking {
    
    @AuraEnabled
    public static ReturnedInfo GetBucketOfBookingInfo(String bookingId) {
        
        ReturnedInfo ret = new ReturnedInfo();
        
        if(bookingId != null){
            
            Booking__c book = [select Bucket_of_booking__c,Bucket_of_booking__r.Bucket_total_amount__c,Bucket_of_booking__r.Reservation_Number__c from booking__c where id=:bookingId];
            ret.currBook = book;
            
            ret.listBook = [select id,name,Stage__c, Arrival_date__c, Departure_date__c from booking__c where Bucket_of_booking__c = :book.Bucket_of_booking__c and id != :book.id ];
            
            //Added by TMA-EIL CG CRMSS-624 17/06/2020 Start
            ret.listVouch = [select id, Bucket_of_bookings__c, code__c, statut__c, Points__c, expireDate__c from voucher__c where Bucket_of_bookings__c =: book.Bucket_of_booking__c];
            //Added by TMA-EIL CG CRMSS-624 17/06/2020 End
            
            return ret;
        }
        
        return null;
    }
    public class ReturnedInfo{
        
        @AuraEnabled public booking__c currBook;
        @AuraEnabled public List<Booking__c> listBook;
        
        //Added by TMA-EIL CG CRMSS-624 17/06/2020 Start
        @AuraEnabled public List<voucher__c> listVouch;
        //Added by TMA-EIL CG CRMSS-624 17/06/2020 End
    }
}