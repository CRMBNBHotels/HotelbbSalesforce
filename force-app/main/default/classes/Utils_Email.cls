/* Description: Apexclass for the Utils Methods For Emails 
* @author: TMA-EIL JKA
* @date: 13-12-2019
* @Test: BatchReprise_BRLtoBooking_Test || BatchUpdateMBNightsRoomsStageCount_Test || Batch_UpdateMB_ConfNb_HotelName_Test
* @Coverage: 100%
*/
public without sharing class Utils_Email {
    
    /**************************************************************************************************************************************************************************************************/
    /*********************************************************************Send Email create for Error manegement in the Batches************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public static void sendEmailApex(String[] ToAddresses, String Subject, Map<String,String> mapobjId) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(ToAddresses);
        mail.setSubject(Subject);
        
        if(mapobjId != null && mapobjId.size()>0){
            
            String body = 'Total:' +'  '+ mapobjId.size() +'  '+ ' records not updated sucessfully';
            
            for (String failedId : mapobjId.keySet()){
                
                body+='\n'+failedId + ' reason : ' + mapobjId.get(failedId); 
            }
            
            mail.setPlainTextBody(body);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    /**************************************************************************************************************************************************************************************************/
    /***************************************************************************************Send Email From Template***********************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public static void sendEmail(List<EmailMessageWrapper> listEmailMessageWrapper, String emailTemplateName) {
        EmailTemplate emailTemplateObj=null;
        List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();
        //Get template id based on name
        emailTemplateObj= [SELECT Id,HtmlValue,Body,subject  FROM EmailTemplate WHERE Name = :emailTemplateName];//, Subject, HtmlValue,Body
        //For all Email wrapper
        for (EmailMessageWrapper emailMessageWrapper : listEmailMessageWrapper) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //Set from add
            if(emailMessageWrapper.FromAddress != null && emailMessageWrapper.FromAddress.length() > 0)
                mail.setReplyTo(emailMessageWrapper.FromAddress);
            //Set to add
            if(emailMessageWrapper.ToAddress != null && emailMessageWrapper.ToAddress.size() > 0)
                mail.setToAddresses( emailMessageWrapper.ToAddress );
            if(emailMessageWrapper.ToAddressId!=null)
                mail.setTargetObjectId(emailMessageWrapper.ToAddressId);
            //Set bcc add
            if(emailMessageWrapper.BccAddress != null && emailMessageWrapper.BccAddress.length() > 0)
                mail.setBccAddresses(new String[] {emailMessageWrapper.BccAddress });
            //Set from display name
            if(emailMessageWrapper.FromDisplayName != null && emailMessageWrapper.FromDisplayName.length() >0)
                mail.setSenderDisplayName(emailMessageWrapper.FromDisplayName);
            String subject = null;
            //Set subject
            if(emailMessageWrapper.Subject != null && emailMessageWrapper.Subject.length() > 0) {
                mail.setSubject(emailMessageWrapper.Subject);
                subject = emailMessageWrapper.Subject;
            }
            //Replace subject names
            if(emailMessageWrapper.ParameterSubjectMap!= null && emailMessageWrapper.ParameterSubjectMap.size()>0)
                for(String key: emailMessageWrapper.ParameterSubjectMap.keySet())
                subject = subject.replace(key, (emailMessageWrapper.ParameterSubjectMap.get(key) == null ? '' : emailMessageWrapper.ParameterSubjectMap.get(key)));
            mail.setSubject(subject);
            //Set Body
            String htmlBody = emailTemplateObj.HtmlValue;
            String plainBody = emailTemplateObj.Body;
            //Replace Body
            for (String key : emailMessageWrapper.ParameterBodyMap.keySet()) {
                if(htmlBody!=null && htmlBody.contains(key))
                    htmlBody = htmlBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
                if(plainBody!=null && plainBody.contains(key))
                    plainBody = plainBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
                
            }
            //Set template ID
            if(emailTemplateObj!=null){
                mail.setTemplateId(emailTemplateObj.id);
            }
            if(htmlBody!=null && htmlBody.length()>0){
                mail.setHtmlBody(htmlBody);
                
            }
            if(plainBody!=null && plainBody.length()>0){
                mail.setPlainTextBody(plainBody);
            }
            listSingleEmailMessages.add(mail);
        }
        
        if(!Test.isRunningTest() && listSingleEmailMessages!=null){
            Messaging.sendEmail(listSingleEmailMessages);
        }
    }
    
}