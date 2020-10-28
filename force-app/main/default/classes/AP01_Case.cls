/*
* Description: Send Email to the hotel when a web to case is created and attach the case to the corresponding
*              hotel based on its externalid Hotel_ID__c
*              Create a Person account based on the Email after a web to case if it does not exist
* @author: Jenny Jawhar
* @date: 14/10/2017
* @Test: AP01_Case_Test
* @Coverage: 78%
*/
public without sharing class AP01_Case {    
    
    //Send an Email to the concerned hotel when a web-to-case is created
    public static void SendEmailToHotel(list<case> triggerNew)
        
    {
        List<String> listHotelSFID = new List<String>();
        system.debug('@@@ ap01 case SendEmailToHotel');
        //Select the case in order to have the updated case with the contactId
        
        system.debug('On new case ' + triggerNew);
        list<case> listCaseUpdated = [Select Id,Hotel_ID__c,Hotel__c,Origin,ContactId, Type,ContactEmail,RecordTypeID,Concerned_country__c,Salesforce_Case_Type__c  //Modified TMAEI - JK - Ticket 76 Add RecordTypeID                             
                                      From Case
                                      Where Id IN: triggerNew];
        
        OrgWideEmailAddress orgEmailAddress = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName like '%noreply%' limit 1];
        
        list<case> listCase = new list<case>();
        list<string> listHotelId = new list<string>();  
        
         //String bookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Booking').getRecordTypeId();
        //string ptRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Request_Claim_Feedback_Spain_Portugal').getRecordTypeId();
        
        for(Case cas: listCaseUpdated){ 
            
            // && cas.Origin==label.CaseWebOrigin Crmss-643 // !string.isBlank(cas.Hotel_ID__c) &&
            if(!string.isBlank(cas.ContactId) 
               &&
               // TMA JK - 698 start
              	/* ((cas.Type==label.Booking_Confirmation|| cas.Type==label.Duplicate_Invoice || cas.Type==label.Lost_Property)
                   &&(( cas.Concerned_country__c == 'IT') && cas.RecordTypeId == Label.Case_RT_CustomersRequestFeedback))
               || 
             	  (cas.Concerned_country__c == 'IT' && cas.RecordTypeId == Label.Case_RT_CustomersRequestFeedback 
              	  && (cas.Type==label.Case_Type_CustomerClaim  || cas.Type==label.Case_Type_CustomerFeedback ))       
               */
               ( (cas.Type==label.Booking_Confirmation || cas.Type==label.Case_Type_CustomerFeedback || cas.Type== label.Case_type_HotelJobApplication 
                  || cas.Type== label.Case_type_FeedbackOnYourStay || cas.Type== label.Case_type_ProblemWithBooking  || cas.Type== label.Case_type_CommercialTopic
                  || cas.Type== label.Case_type_ForgottenObject)
                 &&(cas.Concerned_country__c == 'IT') )
               // TMA JK - 698 end
               || 
             	  ((cas.Concerned_country__c == 'ES'|| cas.Concerned_country__c == 'CA') 
               	 && ( cas.Type==label.Case_SFType_GeneralRequest || cas.Type==label.Case_SFType_FeedbackStay || cas.Type==label.Case_SFType_BookingConfirmation || cas.Type==label.Case_SFType_ProbBooking ||                   cas.Type==label.Case_SFType_ProbInvoice || cas.Type==label.Case_type_ForgottenObject || cas.Type==label.Case_SFType_Companies || cas.Type==label.Case_SFType_Groups ||  cas.Type==label.Case_SFType_BBHClub))
               //Added by TMA-EIL CG CRMSS-764 13/07/2020 Start
               || 
             	  (cas.Concerned_country__c == Label.AP01_Case_PT 
                   && (cas.Salesforce_Case_Type__c == Label.Case_SFType_GeneralRequest || cas.Salesforce_Case_Type__c == Label.Case_SFType_FeedbackStay 
                       || cas.Salesforce_Case_Type__c == Label.Case_SFType_BookingConfirmation || cas.Salesforce_Case_Type__c == Label.Case_SFType_ProbBooking 
                       || cas.Salesforce_Case_Type__c == Label.Case_SFType_ProbInvoice || cas.Salesforce_Case_Type__c == Label.Case_SFType_ForgottenObject
                       || cas.Salesforce_Case_Type__c == Label.Case_SFType_Companies || cas.Salesforce_Case_Type__c == Label.Case_SFType_Groups 
                       || cas.Salesforce_Case_Type__c == Label.Case_SFType_BBHClub) )
               //Added by TMA-EIL CG CRMSS-764 13/07/2020 End
               ||
               		(cas.Concerned_country__c == Label.DE || cas.Concerned_country__c == Label.AT || cas.Concerned_country__c == Label.PL) //Modified by TMA-EIL CG CRMSS-847 01/09/2020
               ||//Modified by TMA-EIL CG CRMSS-852
             	  (cas.concerned_country__c == 'FR' && (cas.Salesforce_Case_Type__c  == 'General request' || cas.Salesforce_Case_Type__c=='Booking confirmation' 
                                                         || cas.Salesforce_Case_Type__c  == 'Duplicate invoice' ||   cas.Salesforce_Case_Type__c  == 'Forgotten object'
                                                      	 || cas.Salesforce_Case_Type__c  == 'Promotional booking modification')))
            {
                listCase.add(cas);
                
                if(!string.isBlank(cas.Hotel_ID__c)){
                    
                    listHotelId.add(cas.Hotel_ID__c);
                }
                //get the hotel SF id if case created manually Added by JK CRMMS-683 
                if(!string.isBlank(cas.Hotel__c) ){
                    
                    listHotelSFID.add(cas.Hotel__c);
                }
                
                
            }
        }
        
        if(listCase.size() > 0){    
            
            list<Case> listCaseToUpdate = new list<Case>();
            Case caseToUpdate;
            //Get the email of each Hotel_ID__c
            list<Hotel__c> listHotel = [Select Email__c,Hotel_ID__c,Country__c
                                        From Hotel__c
                                        Where Hotel_ID__c IN: listHotelId or id in :listHotelSFID];
            
            map<string,HotelWrapper> mapHotelIdToHotelWrapper = new map<string, HotelWrapper>();
            map<string,String> mapIDToHotelId = new map<string, String>();
            string hotelId;
            HotelWrapper hotelWrapper;
            
            for(Hotel__c hotel:listHotel){
                
                hotelId = hotel.Hotel_ID__c;
                hotelWrapper = new HotelWrapper();
                hotelWrapper.hotelEmail = hotel.Email__c;    
                hotelWrapper.hotelCountry = hotel.Country__c;
                //hotelWrapper.emailTemplateId = getHotelSpokenLanguage(hotel.Country__c);
                system.debug('mapHotelIdToHotelWrapper.containsKey(hotelId) ' + mapHotelIdToHotelWrapper.containsKey(hotelId));
                if(!mapHotelIdToHotelWrapper.containsKey(hotelId)){
                    
                    mapHotelIdToHotelWrapper.put(hotelId,hotelWrapper);
                }       
                //get the hotel external id from hotel ID Added by JK CRMMS-683
                mapIDToHotelId.put(hotel.id,hotelId);
            }
            //list that we should send email to
            for(Case cas:listCase){  
                
                system.debug('mapHotelIdToHotelWrapper ' + mapHotelIdToHotelWrapper);
                
                caseToUpdate = new Case(Id = cas.Id);
                
                //If case created manually, update the hotel id of the case based on the linked hotel to get the email using the method above
                if(cas.Hotel_ID__c == null && cas.Hotel__c != null){
                    
                    caseToUpdate.Hotel_ID__c = mapIDToHotelId.get(cas.Hotel__c);
                    cas.Hotel_ID__c = mapIDToHotelId.get(cas.Hotel__c);
                }
                
                if(mapHotelIdToHotelWrapper.containsKey(cas.Hotel_ID__c)){
                   
                    hotelWrapper = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c);
                    hotelWrapper.CaseId = cas.id;
                    hotelWrapper.emailTemplateId = getHotelSpokenLanguage(hotelWrapper.hotelCountry,cas.RecordTypeId);
                    
                    //caseToUpdate.putSObject('Hotel__r',new Hotel__c(Hotel_Id__c=cas.Hotel_ID__c));   
                    if(cas.Concerned_country__c != Label.DE && cas.Concerned_country__c != Label.AT && cas.Concerned_country__c != Label.PL){//Modified by TMA-EIL CG CRMSS-847 01/09/2020
                        
                        caseToUpdate.Status = label.WaitingHotel;
                    }else
                        if(cas.Concerned_country__c == Label.DE || cas.Concerned_country__c == Label.AT || cas.Concerned_country__c == Label.PL){//Modified by TMA-EIL CG CRMSS-847 01/09/2020
                            if(cas.type == Label.AP01_RealEstateOffer){
                                
                                caseToUpdate.Status = Label.AP01_Case_waitingDev;
                                hotelWrapper.emailTemplateId=Label.AP01_Case_TemplateDev;
                            } else
                                if(cas.type == Label.AP01_Case_ApplyHotel){
                                    
                                    caseToUpdate.Status = Label.AP01_Case_waitingOps;
                                    hotelWrapper.emailTemplateId=label.AP01_Case_TemplateOps;
                                } else
                                    if(cas.type == Label.AP01_Case_InvoiceRequest || cas.type == Label.AP01_Case_JobApp || cas.type == Label.AP01_Case_CancellationRequest || cas.type == 'General Hotel Request'){
                                        
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
            
            if(listCaseToUpdate != null && listCaseToUpdate.size()>0){
                
                update listCaseToUpdate; 
            }
            
            for(Case cas:listCase){
                
                if (cas.Hotel_ID__c != null && mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c) != null){
                    
                    string emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                    string templateId = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).emailTemplateId;
                    if(cas.Concerned_country__c == label.AP01_Case_ES ){
                        
                         if(cas.Salesforce_Case_Type__c == Label.Case_SFType_GeneralRequest || cas.Salesforce_Case_Type__c == Label.Case_SFType_FeedbackStay || cas.Salesforce_Case_Type__c == Label.Case_SFType_ProbBooking
                           || cas.Salesforce_Case_Type__c == Label.Case_SFType_Companies || cas.Salesforce_Case_Type__c == Label.Case_SFType_Groups || cas.Salesforce_Case_Type__c == Label.Case_SFType_BBHClub){
                               
                               emailHotel = Label.AP01_Case_SpainEmail;
                           }
                        else{
                            
                            emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                        }
                    }
                    system.debug('### cg hotelWrapper.hotelCountry'+hotelWrapper.hotelCountry);
                    //Added by TMA-EIL CG CRMSS-764 13/07/2020 Start
                    if(cas.Concerned_country__c == label.AP01_Case_PT){
                        
                        if(cas.Salesforce_Case_Type__c == Label.Case_SFType_GeneralRequest || cas.Salesforce_Case_Type__c == Label.Case_SFType_FeedbackStay || cas.Salesforce_Case_Type__c == Label.Case_SFType_ProbBooking
                           || cas.Salesforce_Case_Type__c == Label.Case_SFType_Companies || cas.Salesforce_Case_Type__c == Label.Case_SFType_Groups || cas.Salesforce_Case_Type__c == Label.Case_SFType_BBHClub){
                               
                               emailHotel = Label.AP01_Case_PortugalHotel;
                               //emailHotel = 'cynthia.geagea@ei-technologies.com';
                               system.debug('### cg emailHotel 1'+emailHotel);
                           }
                        else{
                            
                            emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                            system.debug('### cg emailHotel 2'+emailHotel);
                        }
                    }
                    //Added by TMA-EIL CG CRMSS-764 13/07/2020 End
                    
                    if(cas.Concerned_country__c == Label.DE || cas.Concerned_country__c == Label.AT || cas.Concerned_country__c == Label.PL){//Modified by TMA-EIL CG CRMSS-847 01/09/2020
                        
                        emailhotel = '';
                        
                        if(cas.type == Label.AP01_RealEstateOffer){
                            
                            emailhotel = Label.AP01_Case_devEmail;
                        } else
                            if(cas.type == Label.AP01_Case_ApplyHotel){
                                
                                emailhotel = Label.AP01_Case_OpsEmail;
                            } else
                                if(cas.type == Label.AP01_Case_InvoiceRequest || cas.type == Label.AP01_Case_JobApp || cas.type == Label.AP01_Case_CancellationRequest || cas.type == 'General Hotel Request'){
                                    
                                    emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                                }else 
                                    if(cas.type == Label.AP01_Case_CustomerFeedback){
                                        
                                        emailHotel = Label.AP01_Case_CustomerCareEmail;
                                    }
                    }
                    // TMA JK - 698 start
                    if(cas.Concerned_country__c == 'IT')
                    {     
                       if(cas.Type== 'Hotel job application') 
                        {
                            emailHotel = label.AP01_Case_HRItalia_Email;
                        }
                        else if(cas.Type== 'Commercial topic')
                        { 
                            emailHotel = label.AP01_Case_commerciale_Email; 
                        }
                        else
                        {
                           emailHotel = mapHotelIdToHotelWrapper.get(cas.Hotel_ID__c).hotelEmail;
                        }
                    }
                    // TMA JK - 698 end
                    
                    system.debug('emailHotel' + emailHotel);
                    if(!string.isBlank(emailHotel)){   
                        
                        string[] toAddresses = new String[]{emailHotel};    
                            //string[] CcAddresses = new string[]{label.SupportEmail}; 
                            system.debug('toAddresses' + toAddresses);
                        system.debug('cas.contactId' + cas.contactId);
                        system.debug('templateId' + templateId);
                        system.debug('cas.contactEmail' + cas.contactEmail);
                        //Modified by TMA-EIL CG CRMSS-852
                         if(cas.concerned_country__c == 'FR' && (cas.type == 'Promotional booking modification'||cas.Salesforce_Case_Type__c == 'Promotional booking modification') )
                        {
                            templateId = label.WebCaseFrenchEmailTemplateId2;
                        }
                        Messaging.SingleEmailMessage singleEmailMessage = Utils.CreateSingleEmailMessage(toAddresses,null,
                                                                                                         cas.contactId,cas.Id,templateId,cas.ContactEmail);
                 
                        singleEmailMessage.setTreatTargetObjectAsRecipient(false);
                        singleEmailMessage.setSaveAsActivity(true);
                        singleEmailMessage.setSenderDisplayName(null);
                        singleEmailMessage.setOrgWideEmailAddressId(orgEmailAddress.id);
                        Messaging.sendEmail(new Messaging.Email[] { singleEmailMessage });
                    } 
                }  
            }
        }
    } 
    //get the template email id from the hotel spoken languages or country
    public static string getHotelSpokenLanguage(string hotelCountry, String caseRT){
        
        string emailLanguage;
        string language;
        string emailTemplateId;  
        
        //Modified by TMA-EIL CG CRMSS-847 01/09/2020
        if(hotelCountry == label.DE || hotelCountry == label.AT || hotelCountry == label.PL || hotelCountry == label.FR || hotelCountry == label.AP01_Case_CA || hotelCountry == Label.AP01_Case_PT || hotelCountry == label.AP01_Case_ES  || hotelCountry == label.IT ){
            
            emailLanguage = hotelCountry;
        }
        else{
            
            emailLanguage = label.EN;
        }                  
        
        if(emailLanguage == label.DE || emailLanguage == label.AT || emailLanguage == label.PL){//Modified by TMA-EIL CG CRMSS-847 01/09/2020
            
            emailTemplateId = label.WebCaseGermanEmailTemplateId;
        }else
            if(emailLanguage == Label.FR){
                //Modified by TMA-EIL CG CRMSS-852
              /*  if(IsPromotional)
                {
                    emailTemplateId = label.WebCaseFrenchEmailTemplateId2;//'00X0Q000000JztZ';
                }
                else{
               */     emailTemplateId = label.WebCaseFrenchEmailTemplateId;
               // } 
            }else
                if(emailLanguage == label.EN){
                    
                    emailTemplateId = label.WebCaseEnglishEmailTemplateId;
                }
        if(emailLanguage == label.IT){
            
            emailTemplateId = label.WebCaseItalyEmailTemplateID;
        }
        else 
            if (emailLanguage == label.AP01_Case_CA || emailLanguage == label.AP01_Case_ES || emailLanguage == Label.AP01_Case_PT){
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
        List<String> listHotelSFID = new List<String>();
        
        for(case cas:listCase){
            //fill case sf type
            if(cas.Concerned_country__c == 'FR'){
                
                if(cas.type == 'BB Hotels Club Program' || cas.type == 'A question about your B&B Hotels CLUB subscription'){
                    
                    cas.Salesforce_Case_Type__c = 'Club'; 
                }else if(cas.type == 'Update/delete customer opinion'){
                    
                    cas.Salesforce_Case_Type__c = 'Signalement avis client';
                }else if(cas.type == 'Forgotten object'){
                    
                    cas.Salesforce_Case_Type__c = 'Forgotten object';
                }else if(cas.type == 'Duplicate Invoice'){
                    
                    cas.Salesforce_Case_Type__c = 'Duplicate Invoice';
                }else if(cas.type == 'Booking confirmation'){
                    
                    cas.Salesforce_Case_Type__c = 'Booking confirmation';
                }else if(cas.type == 'Feedback regarding your stay' || cas.type == 'Problem with a booking'){
                    
                    cas.Salesforce_Case_Type__c = 'Réclamation'; 
                }else if(cas.type == 'General request'){
                    
                    cas.Salesforce_Case_Type__c = 'General request';
                }
                //Modified by TMA-EIL CG CRMSS-852
                else if(cas.type == 'Promotional booking modification'){
                    
                    cas.Salesforce_Case_Type__c = 'Promotional booking modification';
                }
            }
            //Added by TMA-EIL CG CRMSS-764 13/07/2020 Start
            else if (cas.Concerned_country__c != 'FR'){
                
                if(cas.type == 'General request'){
                    
                    cas.Salesforce_Case_Type__c = 'General request';
                }
                else if(cas.type == 'Feedback regarding your stay'){
                    
                    cas.Salesforce_Case_Type__c = 'Feedback regarding your stay';
                }
                else if(cas.type == 'B&B Hotels CLUB' || cas.type == 'Groups' || cas.type == 'Companies' || 
                        cas.type == 'Problem with an invoice' || cas.type == 'Forgotten object' || cas.type == 'Problem with a booking' 
                        || cas.type == 'Booking confirmation'){
                    
                    cas.Salesforce_Case_Type__c = cas.type;
                }
            }
            //Added by TMA-EIL CG CRMSS-764 13/07/2020 End
            
            //&& cas.Origin==label.CaseWebOrigin removed crmss-643
            if(!string.isBlank(cas.Hotel_ID__c) ){
                
                listHotelId.add(cas.Hotel_ID__c);            
            }else if(!string.isBlank(cas.Hotel__c) ){
                
                listHotelSFID.add(cas.Hotel__c);
            }
        }
        if((listHotelId != null && listHotelId.size() > 0) || (listHotelSFID != null && listHotelSFID.size()>0)){
            
            Map<String,String> mapHotelExtID = new Map<String,String>();
            
            list<Hotel__c> listHotel = [Select Email__c,Hotel_ID__c,Country__c
                                        From Hotel__c
                                        Where Hotel_ID__c IN: listHotelId or id IN :listHotelSFID];
            
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
    public class HotelWrapper{
        
        public string hotelEmail{get;set;}
        public string hotelCountry{get;set;}
        public string emailTemplateId{get;set;}
        public string CaseId{get;set;}
        
        public HotelWrapper(){
            
            hotelEmail = null;
            emailTemplateId = null;
            CaseId = null;
            hotelCountry = null;
        }
    }
    
    //Create a person account when a web to case is created and the web account does not exist
    public static void CreatePersonAccount(list<Case> triggerNew){
        
        system.debug('@@@ ap01 case  CreatePersonAccount');
        list<Case> listCase = new list<Case>();
        set<string> setEmail = new set<string>();
        string lowerCaseEmail;
        //Get all the web Case that don't have a contactId
        for(Case cas: triggerNew){
            
            //removed crmss-643 cas.Origin==label.CaseWebOrigin &&
            if( !string.isBlank(cas.SuppliedEmail) && (cas.ContactId==null || !cas.Contact.IsPersonAccount)){   
                
                listCase.add(cas);
                lowerCaseEmail = cas.SuppliedEmail;
                lowerCaseEmail = lowerCaseEmail.toLowerCase();
                setEmail.add(lowerCaseEmail);
            }
        }
        if(listCase.size() > 0){
            
            list<Case> listCaseToUpdate = new list<case>();
            //If the email is duplicated (person account and contact), get the person account related to it 
            list<Account> listPersonAccount = [Select Id,PersonEmail,PersonContactId
                                               From Account
                                               Where IsPersonAccount = true
                                               And PersonEmail IN: setEmail];
            map<string,Id> mapEmailPersonContactId = new map<string,Id>();
            
            for(Account acc: listPersonAccount){
                
                if(!mapEmailPersonContactId.containsKey(acc.PersonEmail)){
                    
                    mapEmailPersonContactId.put(acc.PersonEmail,acc.PersonContactId);
                }
            }
            //Create a Person Account for the case with no contactId or with a contactId = contact(not personAccount)
            list<Account> listAccountToInsert = new list<Account>();          
            for(Case cas: listCase){
                
                if(!mapEmailPersonContactId.containsKey((cas.SuppliedEmail).toLowerCase())){
                    
                    Account acc = new Account();
                    acc.FirstName = cas.First_Name__c;
                    
                    if (cas.Last_Name__c != null && cas.Last_Name__c != ''){
                        
                        acc.LastName = cas.Last_Name__c; 
                    }else{
                        
                        acc.LastName = 'LastName';
                    }
                    
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
            for(Account acc: listAccount){
                
                if(!mapEmailPersonContactId.containsKey(acc.PersonEmail)){
                    
                    mapEmailPersonContactId.put(acc.PersonEmail,acc.PersonContactId);
                }
            }
            //Get the list of case to update
            list<case> listCaseWithNoContact = [Select Id,SuppliedName,SuppliedEmail
                                                From Case
                                                Where Id IN: listCase];
            //update the cases
            for(case cas:listCaseWithNoContact){
                
                cas.ContactId =  mapEmailPersonContactId.get((cas.SuppliedEmail).toLowerCase());
                cas.AccountId = cas.Contact.AccountId;
                listCaseToUpdate.add(cas);
            }
            
            if(listCaseToUpdate != null && listCaseToUpdate.size()>0){
                
                update listCaseToUpdate; 
            }
        }
    }
    
}