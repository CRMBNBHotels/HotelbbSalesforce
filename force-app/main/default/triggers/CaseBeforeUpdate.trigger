trigger CaseBeforeUpdate on Case (before update) {
    //TMABNB-JK-55
    AP01_SObject.UpdateFromSalesforce(trigger.new);
    //TMA Cynthia geagea - CRMSS-161
    AP03_Case.AssignCaseToUser(trigger.new);
}