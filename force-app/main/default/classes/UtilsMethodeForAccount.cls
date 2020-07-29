/** 
 * Apexclass for the Utils Methode For Account 
 * @author  Omar Bensouda o.bensouda@obkconsulting.com
 * @version 0.1
 * @date 11/12/2019 
 */

public without sharing class UtilsMethodeForAccount {
    /** 
    * Method for start flow with the common value from Account_Setting__mdt
    * @parm    List<Account> newRecords
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  09/01/2020 
    */
    public static void flowWithTheCommonValueFromAccountSetting(List<Account> newRecords) {
        List<Account_Setting__mdt> accountSettings = [SELECT Id, MasterLabel,Country__c,MarketingCountry__c, DomainEmail__c, Indicative__c, 
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
        System.debug('@@:flowWithTheCommonValueFromAccountSetting');
        bBHClubSubscriptionCountry (newRecords,LanguageByValue,CountryByValue,IndicativeByValue,DomainByValue,MarketingCountryByValue);
        countryProspectsFlow1AndFlow2(newRecords,LanguageByValue,CountryByValue,IndicativeByValue,DomainByValue);
    }
    /** 
    * Method BBH Club Subscription Country
    * @parm    List<Account> newRecords,Map<String,String> LanguageByValue, Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue, Map<String,String> MarketingCountryByValue
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  11/12/2019 
    */
    public static void bBHClubSubscriptionCountry(List<Account> newRecords,Map<String,String> LanguageByValue,
                                                        Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue, Map<String,String> MarketingCountryByValue) {
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
            if(String.isNotBlank(mapAccountByHotelName.get(currentAccount))
                    && mapNameOfHotelByCountry.get(mapAccountByHotelName.get(currentAccount)) != null 
                    && mapNameOfHotelByCountry.get(mapAccountByHotelName.get(currentAccount))!= ''){
                System.debug('@@: 10: '+mapAccountByHotelName.get(currentAccount));
                currentAccount.E_club_country_code__c = mapNameOfHotelByCountry.get(mapAccountByHotelName.get(currentAccount));
            }else{listOfNextTreatmentAccount.add(currentAccount);}
        }
        if(listOfNextTreatmentAccount.size()>0){
             bBHClubSubscriptionCountryHelper(listOfNextTreatmentAccount, LanguageByValue, CountryByValue, IndicativeByValue, DomainByValue, MarketingCountryByValue);
        }     
    }
    /** 
    * Method BBH Club Subscription Country helper
    * @parm    List<Account> listOfNextTreatmentAccount,Map<String,String> LanguageByValue, Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue, Map<String,String> MarketingCountryByValue
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
    /** 
    * Method for Country Prospects flow 1 and flow 2
    * @parm    List<Account> newRecords, Map<String,String> LanguageByValue, Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  09/01/2020 
    */
    public static void countryProspectsFlow1AndFlow2(List<Account> newRecords, Map<String,String> LanguageByValue,
                                                     Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue) {
       /*    System.debug('@@: 0');
        List<Account>       listnewAccount          = new List<Account>();
        for(Account currentAccount : newRecords){
            if( currentAccount.Booking_France__c == 0 &&  currentAccount.Booking_Spain__c == 0 &&  currentAccount.Booking_Others__c == 0 && currentAccount.Booking_Germany__c == 0 && currentAccount.Booking_Italy__c == 0 &&   currentAccount.Booking_Poland__c == 0  ){
                listnewAccount.add(currentAccount);
            }
        }
        System.debug('@@: 0 listnewAccount size: '+listnewAccount.size());
        if(listnewAccount.size()>0){
             countryProspectsFlow1AndFlow2Helper(listnewAccount,LanguageByValue,CountryByValue,IndicativeByValue,DomainByValue);
        }   */    
    }
    /** 
    * Method Helper for Country Prospects flow 1 and flow 2 to goal is to field Marketing Country
    * @parm    List<Account> listnewAccount,Map<String,String> LanguageByValue, Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  09/01/2020 
    */
    public static void countryProspectsFlow1AndFlow2Helper(List<Account> listnewAccount,Map<String,String> LanguageByValue,
                                                        Map<String,String> CountryByValue, Map<String,String> IndicativeByValue,Map<String,String> DomainByValue) {                       
        for(Account currentAccount : listnewAccount){
            if(String.isNotBlank(currentAccount.Language__pc) && String.isNotBlank(LanguageByValue.get(currentAccount.Language__pc)) ){ //Langue
                System.debug('@@: 1');
                currentAccount.Marketing_Country__c = LanguageByValue.get(currentAccount.Language__pc);
            }else{
                if(String.isNotBlank(currentAccount.PersonMailingCountry) && String.isNotBlank(CountryByValue.get(currentAccount.PersonMailingCountry)) ){ //Country
                    System.debug('@@: 2');
                    currentAccount.Marketing_Country__c = CountryByValue.get(currentAccount.PersonMailingCountry);
                }else{ 
                    if(String.isNotBlank(currentAccount.PersonMobilePhone) && extractIndicativeFromThePhone(currentAccount.PersonMobilePhone) != null && 
                            IndicativeByValue.get(extractIndicativeFromThePhone(currentAccount.PersonMobilePhone)) != null 
                            && IndicativeByValue.get(extractIndicativeFromThePhone(currentAccount.PersonMobilePhone))!= ''){ // Phone
                        System.debug('@@: 3: '+extractIndicativeFromThePhone(currentAccount.PersonMobilePhone));
                        currentAccount.Marketing_Country__c = IndicativeByValue.get(extractIndicativeFromThePhone(currentAccount.PersonMobilePhone));
                    }else{
                        if(String.isNotBlank(currentAccount.Email__pc) && extractDomainFromEmailAdresse(currentAccount.Email__pc) != null 
                            &&  DomainByValue.get(extractDomainFromEmailAdresse(currentAccount.Email__pc)) != null 
                            &&  DomainByValue.get(extractDomainFromEmailAdresse(currentAccount.Email__pc)) != ''){ // Email Domain
                            System.debug('@@: 4: '+extractDomainFromEmailAdresse(currentAccount.Email__pc));
                            currentAccount.Marketing_Country__c = DomainByValue.get(extractDomainFromEmailAdresse(currentAccount.Email__pc));
                        }else{
                            System.debug('@@: 5');
                            currentAccount.Marketing_Country__c = 'EA' ;
                        }
                    }   
                }
            } 
        }
    }
    /** 
    * Method for Country customers
    * @parm    List<Account> recordsAccounts
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  09/01/2020 
    */
    public static void CountryCustomers(List<Account> recordsAccounts) {  
      /*  List<Account>               listOfAccount          = new List<Account>();      
        Map<String,Map<Decimal,String>>  mapOfAccountIdByMapOfpercentageOfBookingbyCountry  = new Map<String,Map<Decimal,String>>();                                          
        for(Account currentAccount : recordsAccounts){
            if( currentAccount.Booking_France__c != 0 ||  currentAccount.Booking_Spain__c != 0 ||  currentAccount.Booking_Others__c != 0 || currentAccount.Booking_Germany__c != 0 || currentAccount.Booking_Italy__c != 0 ||   currentAccount.Booking_Poland__c != 0  ){
                listOfAccount.add(currentAccount);
                Map<Decimal,String> mapOfpercentageOfBookingbyCountry = new  Map<Decimal,String>();
                mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_France__c,'FR');
                if(mapOfpercentageOfBookingbyCountry.containsKey(currentAccount.Booking_Spain__c)){
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Spain__c,mapOfpercentageOfBookingbyCountry.get(currentAccount.Booking_Spain__c)+',ES');
                }else{
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Spain__c,'ES');
                }
                if(mapOfpercentageOfBookingbyCountry.containsKey(currentAccount.Booking_Germany__c)){
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Germany__c,mapOfpercentageOfBookingbyCountry.get(currentAccount.Booking_Spain__c)+',DE');
                }else{
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Germany__c,'DE');
                }
                if(mapOfpercentageOfBookingbyCountry.containsKey(currentAccount.Booking_Italy__c)){
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Italy__c,mapOfpercentageOfBookingbyCountry.get(currentAccount.Booking_Spain__c)+',IT');
                }else{
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Italy__c,'IT');
                }
                if(mapOfpercentageOfBookingbyCountry.containsKey(currentAccount.Booking_Poland__c)){
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Poland__c,mapOfpercentageOfBookingbyCountry.get(currentAccount.Booking_Spain__c)+',PO');
                }else{
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Poland__c,'PO');
                }
                if(mapOfpercentageOfBookingbyCountry.containsKey(currentAccount.Booking_Others__c)){
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Others__c,mapOfpercentageOfBookingbyCountry.get(currentAccount.Booking_Spain__c)+',EA');
                }else{
                    mapOfpercentageOfBookingbyCountry.put(currentAccount.Booking_Others__c,'EA');
                }
                mapOfAccountIdByMapOfpercentageOfBookingbyCountry.put(currentAccount.Id,mapOfpercentageOfBookingbyCountry);
            }
        }*/
    }
    /** 
    * Method Helper for Country customers
    * @parm    List<Account> newRecords 
    * @author  Omar Bensouda o.bensouda@obkconsulting.com
    * @version 0.1
    * @date of creation  09/01/2020 
    */
    public static void CountryCustomersHelper(List<Account> recordsAccounts, Map<String,Map<Decimal,String>>  mapOfAccountIdByMapOfpercentageOfBookingbyCountry) {
        Map<String,String> accountIDByMarketingCountries = new  Map<String,String> ();
        for(Account currentAccount : recordsAccounts){
            List<Decimal>           listPercentageOfBooking             = new List<Decimal>();
            Map<Decimal,String>     mapOfpercentageOfBookingbyCountry   = new Map<Decimal,String>();
            mapOfpercentageOfBookingbyCountry = mapOfAccountIdByMapOfpercentageOfBookingbyCountry.get(currentAccount.Id);
            listPercentageOfBooking.addAll(mapOfpercentageOfBookingbyCountry.keySet());
            listPercentageOfBooking.sort();       
            currentAccount.Marketing_Country__c = mapOfpercentageOfBookingbyCountry.get(listPercentageOfBooking.get(listPercentageOfBooking.size()-1));
            List<String> listofcountries =currentAccount.Marketing_Country__c.split(',');
            if(listofcountries.size()>1){
                accountIDByMarketingCountries.put(currentAccount.Id,currentAccount.Marketing_Country__c );
            }
        }
        if(accountIDByMarketingCountries.keySet().size()>0) {
            //For booking
            List<account> accountsByOldBooking= [select Id, 
                                    (Select Id, StageName, Hotel__r.country__c, CreatedDate From Opportunities__r where ( StageName ='Booked' OR StageName='Checked') 
                                            And RecordType.DeveloperName = 'Booking' ORDER BY CreatedDate ASC NULLS LAST Limit 1 ) 
                                from account where id in: accountIDByMarketingCountries.keySet() ];
            Map<String,String> accountIDByMarketingCountriesForOldBooking = new  Map<String,String> ();
            for(account temp : accountsByOldBooking){
                if(temp.Opportunities__r.get(0) != null ){
                    accountIDByMarketingCountriesForOldBooking.put(temp.Id,temp.Opportunities__r.get(0).Hotel__r.country__c);
                }  
            }
            for(Account currentAccount : recordsAccounts){
                if(String.isNotBlank(accountIDByMarketingCountriesForOldBooking.get(currentAccount.Id))){
                   currentAccount.Marketing_Country__c= accountIDByMarketingCountriesForOldBooking.get(currentAccount.Id);
                }
            }
        }          
    }
}