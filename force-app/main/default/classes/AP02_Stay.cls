/*
* Update the total nights field on person account and business account based on the opportunity max departure and min arrival (Person account on stay object)
* @author: Jenny Jawhar
* @date: 01/12/2017
* @Test: AP02_Stay_Test - AP04_Stay_Test
*/
public class AP02_Stay 
{
    /*
    public static void UpdateTotalNightsTotalRevenueFavoriteHotel(List<Stay__c> triggerNew,Map<Id,Stay__c> oldMap,List<Stay__c> triggerOld)
    {
         if(UserInfo.getUserId().contains(Label.InterfaceID)){  return;  }
        System.debug('##### AP02_Stay Start' );
        Set<string> ListAccountId = new Set<string>();
        Set<string> ListCurrentCompanyId = new Set<string>();       
        if(triggerNew != null)
        {
            for(Stay__c stay: triggerNew)
            {
                Stay__c oldStay=oldMap==null ? stay : oldMap.get(stay.Id);
                if(oldMap==null && String.isNotBlank(stay.Guest_account__c)) ListAccountId.add(stay.Guest_account__c);
                if(oldMap==null && String.isNotBlank(stay.BusinessAccountId__c)) ListCurrentCompanyId.add(stay.BusinessAccountId__c);                                        
                
                if(oldMap!=null && oldStay.Guest_Account__c!=stay.Guest_Account__c)
                {
                 if(String.isNotBlank(stay.Guest_Account__c))listAccountId.add(stay.Guest_account__c); 
                 if(String.isNotBlank(oldStay.Guest_Account__c))   ListAccountId.add(oldStay.Guest_Account__c);                     
                }
                if(oldMap!=null &&  oldStay.BusinessAccountId__c != stay.BusinessAccountId__c)
                {
                    if(String.isNotBlank(stay.BusinessAccountId__c)) ListCurrentCompanyId.add(stay.BusinessAccountId__c);
                    if(String.isNotBlank(oldStay.BusinessAccountId__c)) ListCurrentCompanyId.add(oldStay.BusinessAccountId__c);
                }
            }
        }
        else
        {
            for(Stay__c stay:triggerOld)
            {
                if((stay.Max_Departure__c!=null && stay.Min_Arrival__c!=null) || stay.Price__c!= null)
                {
                    if(String.isNotBlank(stay.Guest_Account__c))ListAccountId.add(stay.Guest_Account__c);
                    if(String.isNotBlank(stay.BusinessAccountId__c))  ListCurrentCompanyId.add(stay.BusinessAccountId__c);
                }
                if(stay.Hotel_Id__c!=null)
                {
                   if(String.isNotBlank(stay.Guest_account__c)) ListAccountId.add(stay.Guest_account__c);                    
                }
            }
        }
    
        if(ListAccountId.Size() > 0)
        {           
             
            list<Stay__c> listSelectedStay = [select Id,Min_Arrival__c,Max_Departure__c,Guest_account__c,StageName__c,Price__c
                                              ,Hotel_Id__c
                                                 from Stay__c
                                                 where ((OnTheCurrentYear__c =: true and ((StageName__c=:Label.StatusChecked  
                                                 And Max_Departure__c != null And Min_Arrival__c != null) or Price__c != 0))
                                                 or Hotel_Id__c!=null )
                                              	 and Guest_account__c in :ListAccountId];
       
            if(listSelectedStay != null && listSelectedStay.size()>0 ){
               update Night_Revenue_Account(listSelectedStay,true);  
                //Start AP04_Stay updateFavoriteHotel
                ////count for each account the total hotel per hotel_id
                map<string,Map<String,Integer>> mapAccount_hotel = new map<string,Map<String,Integer>>();
                for(Stay__c stay:listSelectedStay)
                {
                    if(String.isNotBlank(stay.Hotel_Id__c) && String.isNotBlank(stay.Guest_account__c) ){
                        
                        if(!mapAccount_hotel.containsKey(stay.Guest_account__c))
                        {
                            Map<String,Integer> temp = new Map<String,Integer>();
                            temp.put(stay.Hotel_Id__c,0);
                            mapAccount_hotel.put(stay.Guest_account__c,temp);
                        }
                        Map<String,Integer> temp = mapAccount_hotel.get(stay.Guest_account__c);
                        if(temp==null ){
                            temp = new Map<String,Integer>();
                            temp.put(stay.Hotel_Id__c,0);
                        }
                        else if(!temp.containskey(stay.Hotel_Id__c)){
                            temp.put(stay.Hotel_Id__c,0);
                        }
                        temp.put(stay.Hotel_Id__c,temp.get(stay.Hotel_Id__c) + 1);
                        mapAccount_hotel.put(stay.Guest_account__c,temp);
                    } 	
                }
                system.debug('listSelectedStay.size()' + listSelectedStay.size());
                system.debug('#### mapAccount_hotel' + mapAccount_hotel);
                integer maxValue=0;
                string maxHotel;
                List<Account> listAccToUpdate = new List<Account>();
                for(String Account_id : mapAccount_hotel.Keyset() )
                {
                    maxValue=0;
                    maxHotel=null;
                    Map<String,Integer> Hotel_count=mapAccount_hotel.get(Account_id);
                    if(Hotel_count!= null)
                    for(String hotel_id : Hotel_count.Keyset()){
                        if(Hotel_count.get(hotel_id) > maxValue){
                            maxHotel = hotel_id;
                            maxValue=Hotel_count.get(hotel_id); 
                        }
                    }
                    Account acc = new Account();
                    acc.id=Account_id;
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
                //END AP04_Stay updateFavoriteHotel
            }
           
        }
        if(ListCurrentCompanyId.Size()>0)
        {
            
            List<Stay__c> listStays = [Select Id, BusinessAccountId__c,Min_Arrival__c,Max_Departure__c,StageName__c,Price__c
                                       from Stay__c
                                       where BusinessAccountId__c IN: ListCurrentCompanyId                  
                                       And OnTheCurrentYear__c =: true and ((StageName__c=:Label.StatusChecked  
                                       And Max_Departure__c != null And Min_Arrival__c != null) or Price__c != 0)
                                       And Trip_Context__c =: Label.BusinessCustomerType];
            
             if(listStays != null && listStays.size()>0 ){
               update Night_Revenue_Account(listStays,false);  
            }
        }        
    }
    //AP03_Stay and AP02_Stay
    public static List<Account> Night_Revenue_Account(list<Stay__c> listStay,Boolean isGuest)
    {   
        List<Account> listAccToUpdate = new List<Account>();
        Map<id,Account> MapAccount  = new  Map<id,Account>();                                       
        
        for(Stay__c stay: listStay)
        {
            system.debug('## stay' + stay);
            String AccountOrQuest =null;
            if(isGuest){
                AccountOrQuest = stay.Guest_account__c;   
            } else{
              AccountOrQuest =   stay.BusinessAccountId__c ; 
            }
            
            if(String.isNotBlank(AccountOrQuest))
            {
                Boolean loadinMap=false;
                if(!MapAccount.containskey(AccountOrQuest)){
                    Account temp = new Account();
                    if(stay.StageName__c==Label.StatusChecked && stay.Max_Departure__c != null && stay.Min_Arrival__c != null)
                    {
                        if(!isGuest) {
                          temp.Total_Nights__c=0;  
                        }else{
                          temp.Total_nights__pc=0;  
                        }
                         loadinMap=true;
                    }
                    if(stay.Price__c!= null)
                    {
                        if(!isGuest) {
                          temp.Total_Revenue__c=0;  
                        }else{
                          temp.Total_Revenue__pc=0;  
                        } 
                        loadinMap=true;
                    }
                    if(loadinMap){
                        temp.id =AccountOrQuest;
                        MapAccount.put(AccountOrQuest,temp);
                    }
                    
                }
                
                if(MapAccount.containsKey(AccountOrQuest)){
                Account temp =MapAccount.get(AccountOrQuest);
                
                if(stay.StageName__c==Label.StatusChecked && stay.Max_Departure__c != null && stay.Min_Arrival__c != null)
                {
                    Integer numberDays = stay.Min_Arrival__c.daysBetween(stay.Max_Departure__c);
                    if(!isGuest ) { 
                        if(MapAccount.get(AccountOrQuest).Total_Nights__c == null){
                            MapAccount.get(AccountOrQuest).Total_Nights__c = 0;
                        }
                        temp.Total_Nights__c = (Integer)MapAccount.get(AccountOrQuest).Total_Nights__c  + numberDays; 
                    }else { 
                        if(MapAccount.get(AccountOrQuest).Total_nights__pc == null){
                            MapAccount.get(AccountOrQuest).Total_nights__pc = 0;
                        }
                        temp.Total_nights__pc = (Integer)MapAccount.get(AccountOrQuest).Total_nights__pc  + numberDays; 
                    } 
                }
                
                if(stay.Price__c!=null)
                {
                    if(!isGuest) { 
                        if(MapAccount.get(AccountOrQuest).Total_Revenue__c == null){
                            MapAccount.get(AccountOrQuest).Total_Revenue__c = 0;
                        }
                        temp.Total_Revenue__c = (Integer)MapAccount.get(AccountOrQuest).Total_Revenue__c  + stay.Price__c; 
                    }else{ 
                         if(MapAccount.get(AccountOrQuest).Total_Revenue__pc == null){
                            MapAccount.get(AccountOrQuest).Total_Revenue__pc = 0;
                        }
                        temp.Total_Revenue__pc = (Integer)MapAccount.get(AccountOrQuest).Total_Revenue__pc  + stay.Price__c; 
                    }  
                } 
                MapAccount.put(AccountOrQuest, temp) ;    
                }
            }
        }
        return MapAccount.values();
    }*/
}