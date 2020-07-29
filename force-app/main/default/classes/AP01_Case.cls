/*
* Description: Send Email to the hotel when a web to case is created and attach the case to the corresponding
*              hotel based on its externalid Hotel_ID__c
*              Create a Person account based on the Email after a web to case if it does not exist
* @author: Jenny Jawhar
* @date: 14/10/2017
* @Test: AP01_Case_Test
*/
public without sharing class AP01_Case {    
    
    //Send an Email to the concerned hotel when a web-to-case is created
    public static void SendEmailToHotel(list<case> triggerNew)
    {
        system.debug('@@@ ap01 case SendEmailToHotel');
        //Select the case in order to have the updated case with the contactId
        list<case> listCaseUpdated = [Select Id,Hotel_ID__c,Origin,ContactId, Type,ContactEmail,RecordTypeID,Concerned_country__c  //Modified TMAEI - JK - Ticket 76 Add RecordTypeID                             
                                      From Case
                                      Where Id IN: triggerNew];
        list<case> listCase = new list<case>();
        list<string> listHotelId = new list<string>();  
        
        for(Case cas: listCaseUpdated)
        {  
            if(!string.isBlank(cas.Hotel_ID__c) && cas.Origin==label.CaseWebOrigin && !string.isBlank(cas.ContactId) 
               && ((cas.Type==label.Booking_Confirmation|| cas.Type==label.Duplicate_Invoice 
                    || cas.Type==label.Lost_Property) && 
                   ((cas.Concerned_country__c == 'FR'|| cas.Concerned_country__c == 'France' || cas.Concerned_country__c == 'IT') && cas.RecordTypeId == Label.Case_RT_CustomersRequestFeedback)) || 
               ((cas.Concerned_country__c == 'FR' || cas.Concerned_country__c == 'France') && cas.Type==label.Information_request) ||
               (cas.Concerned_country__c == 'IT' && cas.RecordTypeId == Label.Case_RT_CustomersRequestFeedback && (cas.Type==label.Case_Type_CustomerClaim  || cas.Type==label.Case_Type_CustomerFeedback ))
               || ((cas.Concerned_country__c == 'ES'|| cas.Concerned_country__c == 'CA') && ( cas.Type==label.Case_Type_CustomerClaim || cas.Type==label.Case_Type_CustomerFeedback ) && cas.RecordTypeId == Label.Case_RT_CustomersRequestFeedback)
               ||(cas.Concerned_country__c == 'DE'))
            {
                listCase.add(cas);
                listHotelId.add(cas.Hotel_ID__c);
                
            }
        }system.debug('listHotelId'+listHotelId);
        if(listCase.size() > 0)
        {                 
            list<Case> listCaseToUpdate = new list<Case>();
            Case caseToUpdate;
            //Get the email of each Hotel_ID__c
            list<Hotel__c> listHotel = [Select Email__c,Hotel_ID__c,Country__c
                                        From Hotel__c
                                        Where Hotel_ID__c IN: listHotelId];
            map<string,HotelWrapper> mapHotelIdToHotelWrapper = new map<string, HotelWrapper>();
            string hotelId;
            HotelWrapper hotelWrapper;
            for(Hotel__c hotel:listHotel)
            {
                hotelId = hotel.Hotel_ID__c;
                hotelWrapper = new HotelWrapper();
                hotelWrapper.hotelEmail = hotel.Email__c;    
                hotelWrapper.hotelCountry = hotel.Country__c;
                //hotelWrapper.emailTemplateId = getHotelSpokenLanguage(hotel.Country__c);
                if(!mapHotelIdToHotelWrapper.containsKey(hotelId))
                {
                    mapHotelIdToHotelWrapper.put(hotelId,hotelWrapper);
                }               
            }
            
            for(Case cas:listCase)
            {   
                if(mapHotelIdToHotelWrapper.containsKey(cas.Hotel_ID__c))
                {
                    hotelWrapper = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c);
                    hotelWrapper.CaseId = cas.id;
                    hotelWrapper.emailTemplateId = getHotelSpokenLanguage(hotelWrapper.hotelCountry,cas.RecordTypeId);
                    //Attach Case to the hotel if hotel Id is in the map
                    caseToUpdate = new Case(Id = cas.Id);
                    //caseToUpdate.putSObject('Hotel__r',new Hotel__c(Hotel_Id__c=cas.Hotel_ID__c));   
                    if(cas.Concerned_country__c != 'DE'){
                        caseToUpdate.Status = label.WaitingHotel;
                    }else
                        if(cas.Concerned_country__c == 'DE'){
                            if(cas.type == Label.AP01_RealEstateOffer){
                                caseToUpdate.Status = Label.AP01_Case_waitingDev;
                                hotelWrapper.emailTemplateId=Label.AP01_Case_TemplateDev;
                            } else
                                if(cas.type == Label.AP01_Case_ApplyHotel){
                                    caseToUpdate.Status = Label.AP01_Case_waitingOps;
                                    hotelWrapper.emailTemplateId=label.AP01_Case_TemplateOps;
                                } else
                                    if(cas.type == Label.AP01_Case_InvoiceRequest || cas.type == Label.AP01_Case_JobApp || cas.type == Label.AP01_Case_CancellationRequest){
                                        caseToUpdate.Status = label.WaitingHotel;
                                        hotelWrapper.emailTemplateId=Label.AP01_Case_TemplateHotel;
                                    } else 
                                        if(cas.type == Label.AP01_Case_CustomerFeedback){
                                            hotelWrapper.emailTemplateId=Label.AP01_Case_TemplateCustomerFeedback;
                                        }
                        }
                    listCaseToUpdate.add(caseToUpdate);
                    //Send Email to the hotel email if the hotel has an email
                    
                    
                }
            }  
            update listCaseToUpdate;   
            for(Case cas:listCase)
            {
                System.debug('@@: '+cas.Hotel_ID__c);
                System.debug('@@: '+mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c));
                string emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                string templateId = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).emailTemplateId;
                if(hotelWrapper.hotelCountry == label.AP01_Case_CA  || hotelWrapper.hotelCountry == label.AP01_Case_ES){
                    emailHotel = label.AP01_Case_SpainEmail;
                }
                if(cas.Concerned_country__c == 'DE'){
                    emailhotel = '';
                    if(cas.type == Label.AP01_RealEstateOffer){
                        emailhotel = Label.AP01_Case_devEmail;
                    } else
                        if(cas.type == Label.AP01_Case_ApplyHotel){
                            emailhotel = Label.AP01_Case_OpsEmail;
                        } else
                            if(cas.type == Label.AP01_Case_InvoiceRequest || cas.type == Label.AP01_Case_JobApp || cas.type == Label.AP01_Case_CancellationRequest){
                                emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                            }else 
                                if(cas.type == Label.AP01_Case_CustomerFeedback){
                                            emailHotel = Label.AP01_Case_CustomerCareEmail;
                                        }
                }
                if(!string.isBlank(emailHotel))
                {   
                    string[] toAddresses = new String[]{emailHotel};    
                        //string[] CcAddresses = new string[]{label.SupportEmail}; 
                        Messaging.SingleEmailMessage singleEmailMessage = Utils.CreateSingleEmailMessage(toAddresses,null,
                                                                                                         cas.contactId,cas.Id,templateId,cas.ContactEmail);
                    singleEmailMessage.setTreatTargetObjectAsRecipient(false);
                    singleEmailMessage.setSaveAsActivity(false);
                    Messaging.sendEmail(new Messaging.Email[] { singleEmailMessage });
                }
            }
        }
    } 
    //get the template email id from the hotel spoken languages or country
    public static string getHotelSpokenLanguage(string hotelCountry, String caseRT)
    {
        string emailLanguage;
        string language;
        string emailTemplateId;       
        if(hotelCountry == label.DE || hotelCountry == label.FR || hotelCountry == label.AP01_Case_CA  || hotelCountry == label.AP01_Case_ES  || hotelCountry == label.IT )
        {
            emailLanguage = hotelCountry;
        }
        else
        {
            emailLanguage = label.EN;
        }                  
        
        if(emailLanguage == label.DE)
        {
            emailTemplateId = label.WebCaseGermanEmailTemplateId;
        }else
            if(emailLanguage == Label.FR)
        {
            emailTemplateId = label.WebCaseFrenchEmailTemplateId;
        }else
            if(emailLanguage == label.EN)
        {
            emailTemplateId = label.WebCaseEnglishEmailTemplateId;
        }
        if(emailLanguage == label.IT)
        {
            emailTemplateId = label.WebCaseItalyEmailTemplateID;
        }
        else 
            if (emailLanguage == label.AP01_Case_CA || emailLanguage == label.AP01_Case_ES){
                // if (caseRT.substring(0, 15) == label.Case_GroupRequestRT.substring(0, 15) || caseRT.substring(0, 15) == label.Case_ompanyRequestRT.substring(0, 15)){
                //    emailTemplateId = label.WebCaseSpanishEmailTemplateIdCompanyGroupReq;
                // } 
                //  else {
                emailTemplateId = label.WebCaseSpanishEmailTemplateId;
                //  }
            }
        return emailTemplateId;
    }
    //fill hotel based on hotelID TMAEI-JK CRMSS-140 Start
    Public static void FillHotelID(List<Case> listCase){
        system.debug('@@@ ap01 case in FillHotelID');
        List<String> listHotelID = new List<String>();
        for(case cas:listCase){
            if(!string.isBlank(cas.Hotel_ID__c) && cas.Origin==label.CaseWebOrigin){
                listHotelId.add(cas.Hotel_ID__c);            
            }
        }
        if(listHotelId != null && listHotelId.size() > 0){
            Map<String,String> mapHotelExtID = new Map<String,String>();
            list<Hotel__c> listHotel = [Select Email__c,Hotel_ID__c,Country__c
                                        From Hotel__c
                                        Where Hotel_ID__c IN: listHotelId];
            for(Hotel__c hotel : listHotel){
                mapHotelExtID.put(hotel.Hotel_ID__c , hotel.id);
            }
            
            for(Case cas:listCase)
            {
                if(mapHotelExtID.containskey(cas.Hotel_ID__c)){
                    cas.Hotel__c = mapHotelExtID.get(cas.Hotel_ID__c);
                }
                
            }
        }
    }
    //TMAEI-JK CRMSS-140 END
    public class HotelWrapper
    {
        public string hotelEmail{get;set;}
        public string hotelCountry{get;set;}
        public string emailTemplateId{get;set;}
        public string CaseId{get;set;}
        public HotelWrapper()
        {
            hotelEmail = null;
            emailTemplateId = null;
            CaseId = null;
            hotelCountry = null;
        }
        
    }
    //Create a person account when a web to case is created and the web account does not exist
    public static void CreatePersonAccount(list<Case> triggerNew)
    {
        system.debug('@@@ ap01 case  CreatePersonAccount');
        list<Case> listCase = new list<Case>();
        set<string> setEmail = new set<string>();
        string lowerCaseEmail;
        //Get all the web Case that don't have a contactId
        for(Case cas: triggerNew)
        {    
            if(cas.Origin==label.CaseWebOrigin && !string.isBlank(cas.SuppliedEmail) && (cas.ContactId==null || !cas.Contact.IsPersonAccount))
            {                
                listCase.add(cas);
                lowerCaseEmail = cas.SuppliedEmail;
                lowerCaseEmail = lowerCaseEmail.toLowerCase();
                setEmail.add(lowerCaseEmail);
            }
        }
        if(listCase.size() > 0)
        {
            list<Case> listCaseToUpdate = new list<case>();
            //If the email is duplicated (person account and contact), get the person account related to it 
            list<Account> listPersonAccount = [Select Id,PersonEmail,PersonContactId
                                               From Account
                                               Where IsPersonAccount = true
                                               And PersonEmail IN: setEmail];
            map<string,Id> mapEmailPersonContactId = new map<string,Id>();
            for(Account acc: listPersonAccount)
            {
                if(!mapEmailPersonContactId.containsKey(acc.PersonEmail))
                {
                    mapEmailPersonContactId.put(acc.PersonEmail,acc.PersonContactId);
                }
            }
            //Create a Person Account for the case with no contactId or with a contactId = contact(not personAccount)
            list<Account> listAccountToInsert = new list<Account>();          
            for(Case cas: listCase)
            {
                if(!mapEmailPersonContactId.containsKey((cas.SuppliedEmail).toLowerCase()))
                {
                    Account acc = new Account();
                    acc.FirstName = cas.First_Name__c;
                    acc.LastName = cas.Last_Name__c;
                    acc.PersonEmail = cas.SuppliedEmail;
                    acc.Email__pc = cas.SuppliedEmail;
                    acc.accountSource = 'Website';
                    acc.PersonMobilePhone = cas.SuppliedPhone;
                    acc.RecordTypeId = label.PersonAccountRecordTypeId;
                    listAccountToInsert.add(acc);  
                }
            }
            system.debug('listAccountToInsert ' + listAccountToInsert);
            insert listAccountToInsert;
            //Get the list of the inserted person account
            list<Account> listAccount = [Select Id,PersonEmail,PersonContactId
                                         From Account
                                         Where Id IN: listAccountToInsert];
            //Map the email to the corresponding personContactId            
            for(Account acc: listAccount)
            {
                if(!mapEmailPersonContactId.containsKey(acc.PersonEmail))
                {
                    mapEmailPersonContactId.put(acc.PersonEmail,acc.PersonContactId);
                }
            }
            //Get the list of case to update
            list<case> listCaseWithNoContact = [Select Id,SuppliedName,SuppliedEmail
                                                From Case
                                                Where Id IN: listCase];
            //update the cases
            for(case cas:listCaseWithNoContact)
            {
                cas.ContactId =  mapEmailPersonContactId.get((cas.SuppliedEmail).toLowerCase());
                cas.AccountId = cas.Contact.AccountId;
                listCaseToUpdate.add(cas);
            }
            update listCaseToUpdate; 
        }
    }
    
}