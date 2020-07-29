trigger ContractBeforeUpdate on Contract (before update) {
    
    //TMABNB-JK-55
    AP01_SObject.UpdateFromSalesforce(trigger.new);
    
    //Added by TMA Cynthia Geagea - CRMSS 342 - 07/11/2019 - Start
    AP02_Contract.fillContactAndAccount(trigger.new, trigger.oldmap,false);
    //Added by TMA Cynthia Geagea - CRMSS 342 - 07/11/2019 - End
}