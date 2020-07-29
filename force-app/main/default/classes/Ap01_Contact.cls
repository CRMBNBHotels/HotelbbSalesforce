public without sharing class Ap01_Contact {
    public static void MAJMobileCountryCode(List<Contact> listContact){ 
        system.debug('@@@ in ap01 MAJMobileCountryCode');
        
        //added by TMA EIL CRMSS-469 24-02-2020 Start
        //Map<String, MobileCountryCode__c> MobileCountryCode = MobileCountryCode__c.getAll();  
        Map<String, MobileCountryCodemdtp__mdt> MobileCountryCode = new Map<String, MobileCountryCodemdtp__mdt>([select Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, ISO_CODES__c from MobileCountryCodemdtp__mdt]);
        //added by TMA EIL CRMSS-469 24-02-2020 end
        
        system.debug('@@@ MobileCountryCode '+MobileCountryCode);
        for(Contact cont:listContact)
        {
            if(cont.MobilePhone.contains(' '))
            {
                String Mobile;
                if(cont.MobilePhone.contains('+')){
                    System.debug('@@@@ +');
                   Mobile =cont.MobilePhone.substring(1,cont.MobilePhone.indexOf(' '));
                    system.debug('@@@ Mobile'+Mobile);
                }else {
                     Mobile=cont.MobilePhone.substring(0,cont.MobilePhone.indexOf(' '));
                     System.debug('@@@@ 0');
                    system.debug('@@@ Mobile'+Mobile);
                }
                system.debug('@@@@  MobileCountryCode.containsKey(Mobile) tt? '+ MobileCountryCode.containsKey(Mobile));
                if(Mobile!= null && MobileCountryCode.containsKey(Mobile)) 
                {
                    System.debug('@@@@ lasttt');
                    
                    cont.et4ae5__Mobile_Country_Code__c=MobileCountryCode.get(Mobile).ISO_CODES__c;
                }
            }
        }
    }
}