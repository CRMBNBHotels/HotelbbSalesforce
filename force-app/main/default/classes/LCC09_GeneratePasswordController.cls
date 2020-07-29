/* Description: This class is the controller for the lightning component that generate a password and send it to a list of congtact
* @author: TMA-EIL JK
* @date: 13-01-2020
* @Test: LCC09_GeneratePasswordController_Test
* @Coverage: 100%
*/
public without sharing class LCC09_GeneratePasswordController {
    
    /**************************************************************************************************************************************************************************************************/
    /***********************************************This method generate the password that is a list of 10 char****************************************************************************************/
    /**************************************************************************************************************************************************************************************************/
    @AuraEnabled
    public Static String GeneratePassword(){
        string pwd;
        Integer len = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        pwd = key.substring(0,len);
        return pwd;
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
    public Static void SendEmails(String listCont, String PWD){
        List<ContactWrapper> listContWrapper = (List<ContactWrapper>)JSON.deserialize(listCont, List<LCC09_GeneratePasswordController.ContactWrapper>.class);
        List<String> toaddress = new List<String>();
        String UserId = Userinfo.getUserId();
        map<String, string> mapParameterBody = new map<String, string>();
        //Replace the password
        mapParameterBody.put('{!v.PWD}',PWD);
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
            Utils_Email.sendEmail(new List<EmailMessageWrapper>{emailWrap},label.CarteLogeeRefreshPassword_ID);
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
}