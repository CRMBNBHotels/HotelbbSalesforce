/*
* Update the customer type field on person account when the booking opportunity trip context change (on object Stay__c)
* @author: Jenny Jawhar
* @date: 01/12/2017
* @Test: AP01_Stay_Test
*/
public class AP01_Stay {
    /*
    public static void UpdateTypeAccount(List<Stay__c> triggerNew, Map<Id,Stay__c> oldMap, List<Stay__c> triggerOld){
        System.debug('##### AP01_Stay Start');
        Set<Id> ListAccountId = new Set<Id>();
        //get the list of accounts affected by the trigger on insert and update
        if(triggerNew != null){
            for(Stay__c stay: triggerNew){  
                Stay__c oldStay=oldMap==null ? stay : oldMap.get(stay.Id);   
                 if(oldMap==null && String.isNotBlank(stay.Guest_account__c)) ListAccountId.add(stay.Guest_account__c);                
                //If we update an opportunity by updating its account                       
                if(oldMap!=null && oldStay.Guest_account__c!=stay.Guest_account__c){
                  if(String.isNotBlank(stay.Guest_Account__c))listAccountId.add(stay.Guest_account__c); 
                  if(String.isNotBlank(oldStay.Guest_account__c)) ListAccountId.add(oldStay.Guest_account__c);                              
                }   
            }
        }
        //get the list of accounts affected by the trigger on delete                                  
        else{
            for(Stay__c stay:triggerOld){
                if(stay.Trip_Context__c!=null){
                   if(String.isNotBlank(stay.Guest_account__c)) ListAccountId.add(stay.Guest_account__c);
                }
            }
        }
        //foreach account get the list of opportunities
        if(ListAccountId.Size() > 0){
            Map<Account,AccountWrapper> mapAccountWrapper = new Map<Account,AccountWrapper>();
            list<Account> listSelectedAccount = [Select Id,RecordTypeId,
                                                 (select Id,Trip_Context__c 
                                                  From Stays__r
                                                  Where Trip_Context__c != null)
                                                 from Account
                                                 where Id IN: ListAccountId ];
            System.debug('##### AP01_Stay listSelectedAccount' + listSelectedAccount);
            for(Account acc:listSelectedAccount){
                List<Stay__c> ListStay = new List<Stay__c>();              
                ListStay = acc.Stays__r;   
                if(!mapAccountWrapper.containsKey(acc)){
                    mapAccountWrapper.put(acc,new AccountWrapper());
                }
                for(Stay__c stay:ListStay){
                    if((stay.Trip_Context__c).equalsIgnoreCase(Label.BusinessCustomerType)){
                        mapAccountWrapper.get(acc).BusinessCount++;
                    }
                    if((stay.Trip_Context__c).equalsIgnoreCase(Label.LeisureCustomerType)){
                        mapAccountWrapper.get(acc).LeisureCount++;
                    }                        
                }                
            }
            List<Account> ListAccToUpdate = new List<Account>();
            for(Account AccKey : mapAccountWrapper.keySet()){
                integer CountBusiness = mapAccountWrapper.get(AccKey).BusinessCount;
                integer CountLeisure = mapAccountWrapper.get(AccKey).LeisureCount;
                if(CountLeisure > CountBusiness){
                    AccKey.Customer_type__pc = Label.LeisureCustomerType;
                }
                if(CountBusiness > CountLeisure){
                    AccKey.Customer_type__pc = Label.BusinessCustomerType;
                }
                if(CountBusiness == CountLeisure && CountBusiness != 0){
                    AccKey.Customer_type__pc = Label.MixedCustomerType;
                }
                if(CountBusiness == 0 && CountLeisure == 0){
                    AccKey.Customer_type__pc = null;
                }
                ListAccToUpdate.add(AccKey);
            }
            Update ListAccToUpdate;
        }
    }
    
    public class AccountWrapper{      
        public integer BusinessCount{get;set;}
        public integer LeisureCount{get;set;}
        
        public AccountWrapper(){            
            BusinessCount = 0;
            LeisureCount = 0;
        }
    }*/
}