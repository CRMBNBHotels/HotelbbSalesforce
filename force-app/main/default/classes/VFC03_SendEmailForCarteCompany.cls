//Commentaire will be done 
public with sharing class VFC03_SendEmailForCarteCompany {
    
    public  		String      contactId           {get;set;}
    public  		Contract    currentContract     {get;set;}
    public       	String      errorMessage        {get;set;}

    public VFC03_SendEmailForCarteCompany() {
        String contactId = Apexpages.currentPage().getParameters().get('ContactId');
        if(ContactId != null && ContactId !=''){
            currentContract = [Select Id,Contact__r.Id,Contact__r.Name,Contact__r.Email From Contract  where Contact__c =: contactId limit 1][0];
        }  
    }

    public void Send (){
            Contact currentContact = new Contact();
            currentContact.Id =currentContract.Contact__r.Id;
            currentContact.Email = currentContract.Contact__r.Email;
           errorMessage = VFC03_SendEmailForCarteCompany.sendSingleMail(currentContact,'IndividualCarteCompany'); 
    }
    //it will be in Test Class
    public static String sendSingleMail(Contact currentContact, String DeveloperName){

        // grab the email template
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName =: DeveloperName];
        // process the merge fields
        String subject = emailTemplate.Subject;
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!Contract.ContactId__c}', currentContact.Id);
        //build the email message
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        email.setReplyTo(currentContact.email);
        email.setTargetObjectId(currentContact.Id);
        email.setSaveAsActivity(true);
        email.setSubject(subject);
        email.setHtmlBody(htmlBody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
        if (results[0].success) {
            System.debug('The email was sent successfully.');
            return  'The email was sent successfully.' ;
        } else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);
            return 'The email failed to send: '+ results[0].errors[0].message ;
        }
    }
}