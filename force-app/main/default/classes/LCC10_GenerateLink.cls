/* Description: This class is the controller for the lightning component that generates a link and sends it to a list of contacts
* @author: TMA-EIL CG
* @date: 06-02-2020
* @Test: LCC10_GenerateLink_Test
* @Coverage: 89 %
*/

public without sharing class LCC10_GenerateLink{
    
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************This method generates a link***********************************************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    
    @AuraEnabled
    public static string GenerateLink2(string ContractId){
        system.debug('### cg GenerateLink2');
        string link;
        
        string ExtId = [select Externalid__c from contract where id =: ContractId][0].Externalid__c;
        
        if(ExtID != null && ExtID != ''){
            
            link = CallWSLink(ExtID, ContractId,null);
        }
        
        return link;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************This method calls BBUS to retrieve a payment link ***********************************************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    
    //@future(callout=true)
    public Static string callWSLink(string ExtID, String Idcurr,Set<String> setfieldModif){
        system.debug('### cg callWSlink');
        string link; 
        
        BB_ContractObject contractObject = new BB_ContractObject();
        contract cont = new contract();
        
        try{
            
            if(ExtID != null && !string.isBlank(ExtID)){
                
                HttpResponse response = BBUS_DataHistoryManager.callBBUSWebserviceResponse('contract', null, null, ExtID,setfieldModif);
                String strResponse = response.getBody();
                system.debug('### cg strResponse'+strResponse);
                Log__c log = new Log__c();
                log.WSName__c = 'Contract Link Generation Return';
                log.JsonMessage__c = strResponse;
                log.FromSalesforce__c = true;
                insert log;
                
                if(strResponse != null && strResponse != ''){
                    
                    strResponse = cleanResponse(strResponse);
                    
                    if(response.getStatusCode() != 200){
                        
                        //if it's a bad response then return an error message to the component
                        
                    }else{
                        
                        //if it's a good response then return the link to the component
                        BBPaymentLinkRS responseWrapper = (BBPaymentLinkRS)JSON.deserialize(strResponse, BBPaymentLinkRS.class);
                        
                        if(responseWrapper.PaymentLinkRS.url != null && responseWrapper.PaymentLinkRS.url != ''){
                            
                            link = responseWrapper.PaymentLinkRS.url;
                        }
                    }
                }
                
            }
            
        }catch(Exception exc){
            system.debug(exc.getMessage());
        }
        return link;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************This method get the list of contact related to the account on the contract*************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    @AuraEnabled
    public Static List<ContactWrapper> GetListContacts(String ContractId){
        
        List<ContactWrapper> listContWrapper = new List<ContactWrapper>();
        
        If(!String.isBlank(ContractId)){
            
            //Get the account id of the contract
            Contract CurContract = [Select id, AccountId From Contract Where id = :ContractId limit 1];
            
            if(CurContract != null && CurContract.AccountId != null){
                
                //Get all related contact to the account
                List<Contact> listCont = [Select id, name, email
                                          From Contact
                                          Where accountId = :CurContract.AccountId and email != null ];
                
                for(Contact conta : listCont){
                    
                    ContactWrapper ContWrap = new ContactWrapper();
                    ContWrap.cont = conta;
                    ContWrap.IsSelected = false;
                    
                    listContWrapper.add(ContWrap);
                }
            }
        }
        return listContWrapper;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************This method send emails to the selected contacts***************************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    @AuraEnabled
    public Static void SendEmails(String listCont, String link){
        
        List<ContactWrapper> listContWrapper = (List<ContactWrapper>)JSON.deserialize(listCont, List<LCC10_GenerateLink.ContactWrapper>.class);
        List<String> toaddress = new List<String>();
        String UserId = Userinfo.getUserId();
        map<String, string> mapParameterBody = new map<String, string>();
        
        mapParameterBody.put('{!v.link}',link);
        //Get user email and name, they will be the from email address dans display name
        User CurrUser = [select id, email,name from user where id = :UserId limit 1];
        //Get only selected contacts emails
        for(ContactWrapper contWrap : listContWrapper){
            
            if(contWrap.IsSelected){
                
                toaddress.add(contWrap.cont.email);
            }
        }
        if(toaddress != null && toaddress.size()>0){
            
            EmailMessageWrapper emailWrap = new EmailMessageWrapper(CurrUser.Email, CurrUser.Name, toaddress, null, null, null, null, null, mapParameterBody);
            //Send the Emails
            Utils_Email.sendEmail(new List<EmailMessageWrapper>{emailWrap},label.CarteLogeePaymentLink_ID);
        }
    }
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************Wrapper class that helps to check what are the contacts selected***********************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    Public Class ContactWrapper{
        @AuraEnabled
        public Boolean IsSelected;
        @AuraEnabled
        public Contact Cont;
    }
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************Wrapper classes to store the WS response***********************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    public class BBPaymentLinkRS{
        public PaymentLinkRS paymentLinkRS {get;set;}
    }
    public class PaymentLinkRS{
        public Amount amount {get; set;}
        public string expiresAt {get; set;}
        public string url {get; set;}
    }
    public class Amount{
        public string bbcurrency {get; set;}
        public integer value {get; set;}
    }

    /**************************************************************************************************************************************************************************************************/
    /***********************************************Method to clean the WS response from unwanted characters in order to deserialize it***********************************************************************************/
    /**************************************************************************************************************************************************************************************************/    
    //@TestVisible
    public static String cleanResponse(String strResponse) {
        
        strResponse = strResponse.replace('bb:', '');
        strResponse = strResponse.replace('@', '');
        strResponse = strResponse.replace('*','');
        strResponse = strResponse.replace('End', 'EndTime');
        
        return strResponse;
    }
}