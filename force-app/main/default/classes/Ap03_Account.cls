public without sharing class Ap03_Account {
    public static void MAJMobileCountryCode(List<Account> listAccount){ 
        //added by TMA EIL CRMSS-469 24-02-2020 Start
        //Map<String, MobileCountryCode__c> MobileCountryCode = MobileCountryCode__c.getAll();  
        Map<String, MobileCountryCodemdtp__mdt> MobileCountryCode = new Map<String, MobileCountryCodemdtp__mdt>([select Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, ISO_CODES__c from MobileCountryCodemdtp__mdt]);
        //added by TMA EIL CRMSS-469 24-02-2020 end
        
        for(Account acc:listAccount)
        {
            if(acc.PersonMobilePhone.contains(' '))
            {
                String Mobile;
                if(acc.PersonMobilePhone.contains('+')){
                    Mobile = acc.PersonMobilePhone.substring(1,acc.PersonMobilePhone.indexOf(' '));
                }else {
                    Mobile = acc.PersonMobilePhone.substring(0,acc.PersonMobilePhone.indexOf(' '));
                }
                if(Mobile!= null && MobileCountryCode.containsKey(Mobile)) 
                {
                    acc.et4ae5__Mobile_Country_Code__pc=MobileCountryCode.get(Mobile).ISO_CODES__c;
                    system.debug('MBC' +acc.et4ae5__Mobile_Country_Code__pc);
                }
            }
        }
    }
}