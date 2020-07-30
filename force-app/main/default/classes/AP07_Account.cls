/*
* Description: Class to get the hotel name based on hotel subscription
* @author: TMA-EI CKH
* @date: 06/08/2019
* @Test class: AP07_Account_Test 
* @Coverage: 100%
*/
public class AP07_Account 
{
    public static void getHotelName(List<Account> listAcc) 
    {
        Map<String,String> mapHotIdName = new Map<String,String>();
        Set<String> hotelIds = new Set<String>();
            
        for(Account acc : listAcc)
        {
            if(acc.Hotelid_club_subscription__c != null && acc.Hotelid_club_subscription__c  != ''){
            	hotelIds.add(acc.Hotelid_club_subscription__c);    
            }else{
                acc.Hotel_Name__c = null;
            }
        }
       
        if(hotelIds.size() > 0)
        {
            List<Hotel__c> lstHotels =  [SELECT id, Commercial_Hotel_Name__c, Hotel_ID__c
                                         FROM Hotel__c  
                                         WHERE Hotel_ID__c in :hotelIds and Commercial_Hotel_Name__c != null];
            
            for(Hotel__c hotel : lstHotels)
            {
                mapHotIdName.put(hotel.Hotel_ID__c, hotel.Commercial_Hotel_Name__c);
            }
            
             for(Account acc : listAcc)
             {
                 if(mapHotIdName.get(acc.Hotelid_club_subscription__c) != null )
                 {
                     acc.Hotel_Name__c = mapHotIdName.get(acc.Hotelid_club_subscription__c);
                 }
             }
        }
    }
}