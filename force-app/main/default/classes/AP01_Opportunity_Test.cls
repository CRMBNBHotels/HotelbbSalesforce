/**
* 
* @version 1.00 23/10/2017
* @author Jenny Jawhar
* @CodeCoverage 93%
*/
@isTest
public class AP01_Opportunity_Test 
{
    @testSetup
    public static void InsertData()
    {
        list<Hotel__c> listHotelsToInsert = new list<Hotel__c>();
        integer i;       
        for(i=0; i<5; i++)
        {
            Hotel__c hotel = Utils.CreateHotel('Hotel'+i);           
            hotel.Commercial_Hotel_Name__c ='Hotel'+i;
            hotel.GPS_code__Latitude__s = 44;
            hotel.GPS_code__Longitude__s = 0;
            listHotelsToInsert.add(hotel);
        }
        for(i=0; i<5; i++)
        {
            Hotel__c hotel = Utils.CreateHotel('Hotel1'+i);           
            hotel.Commercial_Hotel_Name__c ='Hotel1'+i;
            hotel.GPS_code__Latitude__s = 34;
            hotel.GPS_code__Longitude__s = -118;
            listHotelsToInsert.add(hotel);
        }
        insert listHotelsToInsert;
        
        Opportunity Booking = Utils.CreateBookingOpportunity('Booking');
        Booking.StageName = label.ClosedWonStage;
        insert Booking;
    }
    public static testMethod void getListHotels()
    {       
        list<Hotel__c> listHotel = [Select Id
                                    From Hotel__c];
        list<Hotel__c> listActualHotel = AP01_Opportunity.getHotels();       
        system.assertEquals(listHotel.size(), listActualHotel.size());    
    }
  
    public static testMethod void testCreateOLI()
    {
        Opportunity Booking = [Select Id 
                               From Opportunity
                               Where Name = 'Booking' 
                               Limit 1];
        
        string listPredictions = AP01_Opportunity.getAddressAutoComplete('los');
        system.assertEquals(label.BodyAutoCompleteAddress,listPredictions);
        string address = 'Los Angeles,USA';
        
        string bodylatlong = AP01_Opportunity.getlocationlatlong(address);       
        system.assertEquals(label.BodyLongLat,bodylatlong);       
        
        list<Hotel__c> listHotels = AP01_Opportunity.Filter('34.05,-118.24');
        system.assertEquals(5, listHotels.size());
        
        list<Hotel__c> listHotel = [Select Id, Distance__c
                                    From Hotel__c
                                    Where Id IN: listHotels Limit 2];
        AP01_Opportunity.createHotel(Booking.Id,listHotel, address);
        list<Opportunity_Hotel_Junction__c> listJunction = [Select Id
                                                           From Opportunity_Hotel_Junction__c];
        system.assertEquals(2, listJunction.Size());        
    }
}