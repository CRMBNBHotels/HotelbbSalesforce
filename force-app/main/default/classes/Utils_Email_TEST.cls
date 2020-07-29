/**
* This class contains the test method to Utils_Email
* @version 1.00 13 Jan 2020
* @author TMA
*/
@isTest
private class Utils_Email_TEST {
    
    static testMethod void sendEmail_Test() {
        ID vSysAdminPrfId = userInfo.getProfileId();
        Date vToday = System.today();
        Profile vProfile= [SELECT Id FROM Profile WHERE UserType='Standard' limit 1 ];   
        User u2 = new User(Username = 'testUser@BNB.test'
                           , LastName = 'LastNametestOwner5'
                           , FirstName = 'testUserAdmin'
                           , Email = 'testUserAdmin' + vToday.year() + '_' + vToday.month() + '_' + vToday.day() + '@BNB.com.test'
                           , alias = 'tAOW5'
                           , EmailEncodingKey = 'ISO-8859-1'
                           ,TimeZoneSidKey = 'America/New_York'
                           , ProfileId = vSysAdminPrfId
                           , LanguageLocaleKey = 'en_US'
                           , Localesidkey='en_US'
                           , Phone = '123456789'
                           , isActive = true);
        
        insert u2;
        
        system.runAs(u2){
            test.startTest();
            
            Map<String, String> mapBodyParams = new Map<String, String>();
            Map<String,String> mapSubjectParams=new map<String,String>();
            mapBodyParams.put('elementsDeFacturation','test');
            
            List<EmailMessageWrapper> emailMessageWrapperList= new List<EmailMessageWrapper>();
            EmailMessageWrapper emw = new EmailMessageWrapper('no-reply@BNB.com', 'Argus de la Presse', new List<String> {'test@ei-technologies.com'}, u2.id, 'test email util', mapSubjectParams, mapBodyParams);
            emailMessageWrapperList.add(emw);
            
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'name';
            validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();
            validEmailTemplate.htmlvalue = '123123';
            validEmailTemplate.Body = 'Test';
            insert validEmailTemplate;
            
            
            Utils_Email.sendEmail(emailMessageWrapperList, validEmailTemplate.name );
            Utils_Email.sendEmailApex(new List<String>{u2.Email}, 'This is a test subject', null);
            test.stopTest();
        }
    }
}