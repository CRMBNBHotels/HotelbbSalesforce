/** 
 * Apexclass for the Utils Methode For Account 
 * @author  Omar Bensouda o.bensouda@obkconsulting.com
 * @version 0.1
 * @date 11/12/2019 
 */

public without sharing class UtilsMethodeForAccount {
    /** 
    * Method BBH Club Subscription Country
    * @parm    List<Account> newRecords
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  11/12/2019 
    */
    public static void bBHClubSubscriptionCountry(List<Account> newRecords) {
        List<Account_Setting__mdt> accountSettings = [SELECT Id, Country__c,MarketingCountry__c, DomainEmail__c, Indicative__c, 
                                                            Language__c, Value__c FROM Account_Setting__mdt];
        Map<String,String> LanguageByValue          = new Map<String,String>();
        Map<String,String> CountryByValue           = new Map<String,String>();
        Map<String,String> IndicativeByValue        = new Map<String,String>();
        Map<String,String> DomainByValue            = new Map<String,String>();
        Map<String,String> MarketingCountryByValue  = new Map<String,String>();
        for(Account_Setting__mdt tempAccountSettings: accountSettings){
            LanguageByValue.put(tempAccountSettings.Language__c,tempAccountSettings.Value__c);
            CountryByValue.put(tempAccountSettings.Country__c,tempAccountSettings.Value__c);
            IndicativeByValue.put(tempAccountSettings.Indicative__c,tempAccountSettings.Value__c);
            DomainByValue.put(tempAccountSettings.DomainEmail__c,tempAccountSettings.Value__c);
            MarketingCountryByValue.put(tempAccountSettings.MarketingCountry__c,tempAccountSettings.Value__c);
        }
        
        Map<Account, String> mapAccountByHotelName              = new  Map<Account, String>() ;
        Set<String>         setOfHotelName                      = new Set<String>();
        List<Account>       listOfNextTreatmentAccount          = new List<Account>();
        for(Account currentAccount : newRecords){
            if(currentAccount.E_club_subscription__pc == true && currentAccount.E_club_Creation_channel__pc != null){
                if(String.isNotBlank(currentAccount.Hotel_Name__c) && currentAccount.E_club_Creation_channel__pc == 'Dashboard'){
                    System.debug('@@: 1');
                    mapAccountByHotelName.put(currentAccount,currentAccount.Hotel_Name__c);
                    setOfHotelName.add(currentAccount.Hotel_Name__c);
                }else{
                    System.debug('@@: 2');
                    listOfNextTreatmentAccount.add(currentAccount);
                }
            }
        }
        Map <String,String> mapNameOfHotelByCountry = new Map <String,String>();
        List <Hotel__c> listOfHotel = [Select Id,Commercial_Hotel_Name__c,Country__c From Hotel__c where Commercial_Hotel_Name__c in:setOfHotelName];
        for(Hotel__c currentHotel : listOfHotel){
            mapNameOfHotelByCountry.put(currentHotel.Commercial_Hotel_Name__c,currentHotel.Country__c);
        }
        for(Account currentAccount : mapAccountByHotelName.keySet()){
            if(!(String.isNotBlank(mapAccountByHotelName.get(currentAccount)) && mapNameOfHotelByCountry.get(mapAccountByHotelName.get(currentAccount)) != null  && mapNameOfHotelByCountry.get(mapAccountByHotelName.get(currentAccount))!= '')){ listOfNextTreatmentAccount.add(currentAccount);
            }else{
                System.debug('@@: 10: '+mapAccountByHotelName.get(currentAccount));
                currentAccount.E_club_country_code__c = mapNameOfHotelByCountry.get(mapAccountByHotelName.get(currentAccount));
            }
        }
        bBHClubSubscriptionCountryHelper(listOfNextTreatmentAccount, LanguageByValue, CountryByValue, IndicativeByValue, DomainByValue, MarketingCountryByValue);
    }
    /** 
    * Method BBH Club Subscription Country helper
    * @parm    List<Account> newRecords
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  11/12/2019 
    */
    public static void bBHClubSubscriptionCountryHelper(List<Account> listOfNextTreatmentAccount,Map<String,String> LanguageByValue,
                                                        Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue, Map<String,String> MarketingCountryByValue) {
        String defaultValue = 'BU Groupe';                           
        for(Account currentAccount : listOfNextTreatmentAccount){
            if(String.isNotBlank(currentAccount.MarketingCountry__c) && currentAccount.MarketingCountry__c != defaultValue 
                    && MarketingCountryByValue.get(currentAccount.MarketingCountry__c) != null 
                    && MarketingCountryByValue.get(currentAccount.MarketingCountry__c)!= '' ){// Marketing country
                System.debug('@@: 4');
                currentAccount.E_club_country_code__c = MarketingCountryByValue.get(currentAccount.MarketingCountry__c);
            }else{
                if(String.isNotBlank(currentAccount.Language__pc) && String.isNotBlank(LanguageByValue.get(currentAccount.Language__pc)) ){ //Langue
                    System.debug('@@: 5');
                    currentAccount.E_club_country_code__c = LanguageByValue.get(currentAccount.Language__pc);
                }else{
                    if(String.isNotBlank(currentAccount.PersonMailingCountry) && String.isNotBlank(CountryByValue.get(currentAccount.PersonMailingCountry)) ){ //Country
                        System.debug('@@: 6');
                        currentAccount.E_club_country_code__c = CountryByValue.get(currentAccount.PersonMailingCountry);
                    }else{ 
                        if(String.isNotBlank(currentAccount.PersonMobilePhone) && extractIndicativeFromThePhone(currentAccount.PersonMobilePhone) != null && 
                                IndicativeByValue.get(extractIndicativeFromThePhone(currentAccount.PersonMobilePhone)) != null 
                                && IndicativeByValue.get(extractIndicativeFromThePhone(currentAccount.PersonMobilePhone))!= ''){ // Phone
                            System.debug('@@: 7: '+extractIndicativeFromThePhone(currentAccount.PersonMobilePhone));
                            currentAccount.E_club_country_code__c = IndicativeByValue.get(extractIndicativeFromThePhone(currentAccount.PersonMobilePhone));
                        }else{
                            if(String.isNotBlank(currentAccount.Email__pc) && extractDomainFromEmailAdresse(currentAccount.Email__pc) != null 
                                &&  DomainByValue.get(extractDomainFromEmailAdresse(currentAccount.Email__pc)) != null 
                                &&  DomainByValue.get(extractDomainFromEmailAdresse(currentAccount.Email__pc)) != ''){ // Email Domain
                                System.debug('@@: 8: '+extractDomainFromEmailAdresse(currentAccount.Email__pc));
                                currentAccount.E_club_country_code__c = DomainByValue.get(extractDomainFromEmailAdresse(currentAccount.Email__pc));
                            }else{
                                System.debug('@@: 9');
                                currentAccount.E_club_country_code__c = 'EA' ;
                            }
                        }
                    }
                }
            }
        }
    }
    /** 
    * Method extract Domain From Email Adresse 
    * @parm    String Email
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  11/12/2019 
    */
    public static String extractDomainFromEmailAdresse(String email){
        if(String.isNotBlank(email)){
            String domainFromEmail = email.split('@').get(1).split('\\.').get(1);
            return domainFromEmail;
        }
        return null;
    }
    /** 
    * Method extract Indicative From the Phone
    * @parm    String Phone
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  11/12/2019 
    */
    public static String extractIndicativeFromThePhone(String phone){
        if(String.isNotBlank(phone)){
            //Phone good format example: +33 699985133 (documentation link: WS UpdatePersonAccount )
            Pattern MyPattern = Pattern.compile('\\+[0-9]{1,4} [1-9]{1}[0-9]{1,20}$');
            Matcher MyMatcher = MyPattern.matcher(phone);
            if(MyMatcher.matches()){
                String indicative = phone.split('\\+').get(1);
                indicative = indicative.split(' ').get(0);
                return indicative;
            }
        }
        return null;
    }
}