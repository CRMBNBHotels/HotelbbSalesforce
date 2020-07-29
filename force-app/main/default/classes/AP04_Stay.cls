/*
* Update favorite Hotel on person account based on the most booked hotel in Booking
* @author: Jenny Jawhar
* @date: 04/10/2017
* @Test: AP04_Stay_Test
*/
public class AP04_Stay 
{
    //public static void updateFavoriteHotel(List<Stay__c> triggerNew, Map<Id,Stay__c> oldMap, List<Stay__c> triggerOld)
    //{
      // System.debug('##### AP04_Stay Start');
       // list<Id> listAccountId = new List<Id>();        
      /*  if(triggerNew != null)
        {
            for(Stay__c stay: triggerNew)
            {
                Stay__c oldStay=oldMap==null ? stay : oldMap.get(stay.Id);
                listAccountId.add(stay.Guest_account__c);  
                // The below if is used to modify the favorite hotel of the old account
                if(oldMap!=null && oldStay.Guest_account__c!=stay.Guest_account__c )
                {
                    listAccountId.add(oldStay.Guest_account__c);                     
                }             
            }
        }
        else
        {
            for(Stay__c stay:triggerOld)
            {
                if(stay.Hotel_Id__c!=null)
                {
                    ListAccountId.add(stay.Guest_account__c);                    
                }
            }
        }
        if(listAccountId.Size() > 0)
        {
            List<Account> listAccToUpdate = new List<Account>();    
            list<Account> listSelectedAccount= [Select Id,
                                                (select Id,Hotel_ID__c 
                                                 From Stays__r
                                                 Where Hotel_Id__c!=null)
                                                From Account
                                                Where Id IN: ListAccountId]; 
            System.debug('##### AP04_Stay listSelectedAccount' + listSelectedAccount);
            for(Account acc: listSelectedAccount)
            {
                map<string,integer> mapCountHotel = new map<string,integer>();
                list<Stay__c> listStay=acc.Stays__r;
                //Get the list of Hotels for each account with their number of occurence
                for(Stay__c stay:listStay)
                {
                    if(!mapCountHotel.containsKey(stay.Hotel_Id__c))
                    {
                        mapCountHotel.put(stay.Hotel_Id__c,0);
                    }
                    mapCountHotel.put(stay.Hotel_Id__c,mapCountHotel.get(stay.Hotel_ID__c)+1);	
                }
                //Get the highest number of occurence
                integer maxValue=0;
                string maxHotel;               
                for(string HotelId:mapCountHotel.keySet())
                {
                    if(mapCountHotel.get(HotelId) > maxValue){
                        maxHotel = HotelId;
                        maxValue=mapCountHotel.get(HotelId); 
                    }
                }
                if(maxHotel != null)
                {
                    acc.Favorite_hotel__pc = maxHotel;
                }
                else
                {
                    acc.Favorite_hotel__pc = null;
                }
                listAccToUpdate.add(acc);             
            }   
            update listAccToUpdate;            
        }*/
    //}
}