trigger AfterUpdateCase on Case (after update) 
{
    AP02_Case.UpdateContactNameWithPersonAccount(trigger.New,trigger.oldMap);
    
    //TMA - Cynthia Geagea 11/06/2019 - CRMSS-161
    AP03_Case.SendEmailToCaseOwner(trigger.New, trigger.oldMap);
}