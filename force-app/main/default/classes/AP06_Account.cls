/*
* Description: Class to track history on certain field
* @author: TMA-EI JK
* @date: 30/07/2019
* @Test class: 
* @Coverage: 
*/
public without sharing class AP06_Account {
    
    public static void TrackHistory(List<Account> listAcc, Map<id,Account> mapAccOld) {
        
        List<BBH_CLUB_History__c> ListHistory = new List<BBH_CLUB_History__c>();
        
        for(Account acc:listAcc){
            
            if(acc.Date_of_e_club_purchase__pc != mapAccOld.get(acc.Id).Date_of_e_club_purchase__pc || acc.E_club_Creation_channel__pc != mapAccOld.get(acc.Id).E_club_Creation_channel__pc || acc.Hotelid_club_subscription__c != mapAccOld.get(acc.Id).Hotelid_club_subscription__c){
                
                BBH_CLUB_History__c history = new BBH_CLUB_History__c();
                history.account__c = acc.Id;
                
                if(acc.Date_of_e_club_purchase__pc != mapAccOld.get(acc.Id).Date_of_e_club_purchase__pc){
                    
                    history.Oldvalue__c = String.valueOf(mapAccOld.get(acc.Id).Date_of_e_club_purchase__pc);
                    history.Newvalue__c = String.valueOf(acc.Date_of_e_club_purchase__pc);
                    history.Field__c = Label.AP06_Account_DatePurchase;
                }
                
                if(acc.E_club_Creation_channel__pc != mapAccOld.get(acc.Id).E_club_Creation_channel__pc){
                   
                    //Added by TMA-EIL CG MS-2042 04/03/2020 Start
                    if(mapAccOld.get(acc.Id).E_club_Creation_channel__pc == Label.AP06_Account_Dashboard){
                        system.debug('### cg here 1');
                        history.Oldvalue__c = mapAccOld.get(acc.Id).E_club_Creation_channel__pc + ' - ' + acc.Hotel_Name__c;
                        system.debug('### cg history.Oldvalue__c'+history.Oldvalue__c);
                    }
                    else{
                        system.debug('### cg here 2');
                        history.Oldvalue__c = mapAccOld.get(acc.Id).E_club_Creation_channel__pc;
                    }
                    //Added by TMA-EIL CG MS-2042 04/03/2020 End
                    
                    history.Newvalue__c = acc.E_club_Creation_channel__pc;
                    history.Field__c = Label.AP06_Account_CreationChannel;
                }
                system.debug('### ' + acc.Hotel_Name__c + ' * ' + mapAccOld.get(acc.Id).Hotel_Name__c);
                //Added by TMA JKA - CRMSS-265 - 18/10/2019
                if(acc.Hotel_Name__c != mapAccOld.get(acc.Id).Hotel_Name__c){
                    
                    history.Oldvalue__c = mapAccOld.get(acc.Id).Hotel_Name__c;
                    history.Newvalue__c = acc.Hotel_Name__c;
                    history.Field__c = Label.AP06_Account_Hotel_Name_Subscription;
                }
                ListHistory.add(history);
            }
        }
        
        if(ListHistory != null && ListHistory.size() > 0){
           system.debug('### cg ListHistory'+ListHistory);
            insert ListHistory;
        }
    }
}