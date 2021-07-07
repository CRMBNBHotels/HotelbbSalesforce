/*******************************************************************************************************************************************************************
* @author: Kanel Services  - Amira 
* @date: 08/02/2021
* @details : Test Class for AP03_Contract
*
*********************************************************************************************************************************************************************/
@isTest (SeeAllData=false)
public class AP03_Contract_Test {
  public static Contract ctrct;
  public static Account pAcc;

  private static testMethod void testScheduler_CLCreditExpirationDate(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
      ctrct.CreditCardExpDate__c=system.today().addMonths(1);
      update ctrct;

      test.startTest(); 
        Schedule_CLCreditExpirationDate testScheduleErr = new Schedule_CLCreditExpirationDate();
        String cron_ex = '0 0 0 15 3 ? 2050';
        String jobIdErr = System.schedule('JOB7',cron_ex  , testScheduleErr );                             
      test.stopTest();
    }
  }
  
  private static testMethod void testScheduler_CarteLogeeNotifExpiration(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();     
      ctrct.status='Activated';
      ctrct.CreditCardExpDate__c=system.today();
      update ctrct;
     
      test.startTest(); 
        String query ='SELECT id,Owner.Email,Owner.Name,ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c '+
        'FROM Contract '+
        'WHERE CorporateCode__c != Null AND Status != \'Expired\' AND RecordType.DeveloperName=\'Carte_log_e_RT_France\' AND CreditCardExpDate__c=TODAY ' +
        'LIMIT 1';

        Batch_carteLogeeNotifActions batchLaunch = new Batch_carteLogeeNotifActions(query, 'expiration');
        database.executebatch(batchLaunch,1);              
      test.stopTest();
    }
  }
    
 private static testMethod void testScheduler_CLFactureNotif(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();     
      ctrct.status='Activated';
      ctrct.CreditCardExpDate__c=system.today();
      update ctrct;
     
      test.startTest(); 
        string query ='select id,Owner.Email,Owner.Name,ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c,contact__r.Email,ContractTerm, ContactComptabilite__r.Email , ContactComptabilite__c '+
             'from Contract '+
             'where CorporateCode__c !=null and Status = \'Activated\' and RecordType.DeveloperName=\'Carte_log_e_RT_France\'';

        Batch_FactureNotifs batchLaunch = new Batch_FactureNotifs(query);
        database.executebatch(batchLaunch,1);              
      test.stopTest();
    }
  }
  
 private static testMethod void testScheduler_Facture(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
        
      test.startTest(); 
        Schedule_CLFactureNotif testScheduleErr = new Schedule_CLFactureNotif();
        String cron_ex = '0 0 0 15 3 ? 2036';
        String jobIdErr = System.schedule('JOB7',cron_ex  , testScheduleErr );                             
      test.stopTest();
    }
  }

  private static testMethod void CarteLogeeReconduction_Test(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();

      ctrct.status='Activated';
      ctrct.StartDate=system.today();
      ctrct.ContractTerm=12;
      ctrct.Expiration_Date__c=ctrct.StartDate+ctrct.ContractTerm;
      update ctrct;

      List<Contract> aContractList = [select id,Owner.Email,Owner.Name,ContractNumber, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c,ContractTerm FROM Contract];

      test.startTest(); 
        AP03_Contract.carteLogeeNotifActions(aContractList,'Reconduction');                
      test.stopTest();
    }
  }

private static testMethod void CarteLogeeNotifFacture_Test(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();

      ctrct.status='Activated';
      ctrct.StartDate=system.today();
      update ctrct;

      List<Contract> aContractList = [select id,Owner.Email,Owner.Name,ContractNumber,Contact__r.name,Contact__r.email, ContactComptabilite__r.Email,ContactComptabilite__c, Status, EndDate,Expiration_Date__c,CreditCardExpDate__c,ContractTerm FROM Contract];

      test.startTest(); 
        AP03_Contract.CarteLogeeNotifFacture(aContractList);                
      test.stopTest();
    }
  }
  private static testMethod void testScheduler_Reconduction(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
      ctrct.status='Activated';
   
      ctrct.StartDate=system.today();
      ctrct.ContractTerm=12;
      ctrct.Expiration_Date__c=ctrct.StartDate+ctrct.ContractTerm;
      update ctrct;

      test.startTest(); 
        Schedule_CLReconductionTacite testScheduleErr = new Schedule_CLReconductionTacite();
        String cron_ex = '0 0 0 15 3 ? 2022';
        String jobIdErr = System.schedule('JOB8',cron_ex,testScheduleErr );                             
      test.stopTest();
    }
  }

  private static testMethod void testScheduler_NotifExpCreditCard(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
      ctrct.status='Expired';
      ctrct.CreditCardExpDate__c=system.today();
      update ctrct;

      test.startTest(); 
        Schedule_Batch_CLNotifyCreditCardExp testScheduleErr = new Schedule_Batch_CLNotifyCreditCardExp();
        String cron_ex = '0 0 0 15 3 ? 2023';
        String jobIdErr = System.schedule('JOB6',cron_ex  , testScheduleErr );                             
      test.stopTest();
    }
  }

  private static testMethod void testScheduler_Batch_CLRelevedesFactures(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
      ctrct.status='Activated';
   
      ctrct.StartDate=system.today();
      ctrct.ContractTerm=12;
      ctrct.Expiration_Date__c=ctrct.StartDate+ctrct.ContractTerm;
      update ctrct;

      test.startTest(); 
      Schedule_Batch_CLRelevedesFactures testScheduleErr = new Schedule_Batch_CLRelevedesFactures();
        String cron_ex = '0 0 0 15 3 ? 2022';
        String jobIdErr = System.schedule('JOB8',cron_ex,testScheduleErr );                             
      test.stopTest();
    }
  }

  private static testMethod void test_validate1ActivecUser_ActivateContract(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
      try{
        //Add Another similar Carte Logée          
        CarteLogeeUser__c cUser = New CarteLogeeUser__c(Contract__c = ctrct.Id,
                                                        Active__c = true,
                                                        Account__c = pAcc.Id);
        insert cUser;

        ctrct.status='Activated';
        ctrct.StartDate=system.today();
        ctrct.ContractTerm=12;
        ctrct.Expiration_Date__c=ctrct.StartDate+ctrct.ContractTerm;

        test.startTest(); 
          update ctrct;              
        test.stopTest();
      }catch (Exception e){}
    }
  }

  private static testMethod void test_validate1ActivecUser_updateCarteLogee(){
    User usr = createUser();
    insert usr;
    System.Assert(usr.Id != null);

    System.runas(usr){
      //  Create Records
      createRecords();
      try{
        //Add Another similar Carte Logée          
        CarteLogeeUser__c cUser = New CarteLogeeUser__c(Contract__c = ctrct.Id,
                                                        Active__c = false,
                                                        Account__c = pAcc.Id);
        insert cUser;

        ctrct.status='Activated';
        ctrct.StartDate=system.today();
        ctrct.ContractTerm=12;
        ctrct.Expiration_Date__c=ctrct.StartDate+ctrct.ContractTerm;
        update ctrct;
        test.startTest(); 
          cUser.Active__c = true;
          update cUser;            
        test.stopTest();
      }catch (Exception e){}
    }
  }


  private static void createRecords(){
    //Create Account 
    Id CompanyAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company').getRecordTypeId();
    Account acc = new Account(Name = 'TestAccount', RecordTypeId = CompanyAccountRTId, BillingCountry = 'Algeria', BillingPostalCode='1');
    Database.Insert(acc,true);
    System.assert(acc.Id != null);

    //Create Person Account
    pAcc = new Account(  
                                Externalid__c       = 'testJill',
                                FirstName           = 'JillCarey', 
                                LastName            = 'AdminJill', 
                                recordTypeId        = Label.PersonAccountRecordTypeId, 
                                Email__pc           = 'JillCareyjdoe@bbtest.com', 
                                PersonMobilePhone   = '+33 000000000', 
                                BillingCountry      = 'France'); 
    Database.Insert(pAcc,true);
    System.assert(pAcc.Id != null);

    //Create Opportunity
    Id CorporateRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
    Opportunity opp = new Opportunity(Name = 'TestOpportunity',RecordTypeId = CorporateRTId, AccountId = acc.id, StageName = 'Booked', CloseDate = date.valueOf('2019-08-25'));
    Database.Insert(opp,true);
    System.assert(opp.Id != null);  
      
    //Create Contact
    contact cont = new contact();
    cont.AccountId = acc.Id;
    cont.LastName='test';
    cont.MobilePhone='+33 777';
    cont.Email = 'Test@email.com';
    insert cont ;
     
    //create Corporate Code
    Corporate_code__c corp = new Corporate_code__c();
    corp.name = 'FR1234';
    insert corp;
    System.assert(corp.Id != null);
       
    //create Contract
    String carteLogeeRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Carte_log_e_RT_France').getRecordTypeId();
    ctrct = Utils.CreateContract();
    ctrct.AccountId = acc.Id;
    ctrct.CorporateCode__c = corp.Id;
    ctrct.RecordtypeId = carteLogeeRTId;
    ctrct.Contact__c = cont.Id;
    ctrct.ContactComptabilite__c = cont.Id;
    ctrct.Status = 'Draft';
    insert ctrct;


    //Create Carte Logée User
    CarteLogeeUser__c cUser = New CarteLogeeUser__c(Contract__c = ctrct.Id,
                                                    Active__c = true,
                                                    Account__c = pAcc.Id);
    insert cUser;
    
    //create Document
    ContentVersion cv = new ContentVersion();
    cv.Title = 'booking_Test Document';
    cv.PathOnClient = 'TestDocument.pdf';
    cv.VersionData = Blob.valueOf('Test Content');
    cv.IsMajorVersion = true;
    Insert cv;
      
    //Get Content Documents
      Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;

   //Create ContentDocumentLink 
    ContentDocumentLink cdl = New ContentDocumentLink();
    cdl.LinkedEntityId = ctrct.Id;
    cdl.ContentDocumentId = conDocId;
    cdl.shareType = 'V';
    Insert cdl;

    //Create Table Des Ventes
    TableVente__c vente = New TableVente__c(
                                              Contrat__c = ctrct.Id,                       // Contrat
                                              Quantite__c = 2,                        // Quantité
                                              Nomhotel__c = 'Lille Centre Grand Palais',   // Nom de l’hotel
                                              Taux_TVA__c = 0,                             // Taux TVA
                                              PrenomBooker__c = 'Gk6ny7t8m',               // Prénom du booker
                                              NomBooker__c = 'Htqrbshzs',                  // Nom du booker
                                              Montant_TTC__c = 113,                        // Montant TTC
                                              Nom_du_stayer__c = 'DINAR',                  // Nom du stayer
                                              NumReservation__c = 'BB25913',               // N° de réservation
                                              DateSejour__c = System.Today().AddMonths(-1),  // Date du séjour
                                              IdPrestation__c = 'CT',                      // Id de la prestation
                                              NumFactureAvoir__c = '76424',                // Numéro de facture / Avoir
                                              LibellePrestation__c = 'Taxe de sejour',     // Libellé de la prestation
                                              IDCRSClient__c = '483300',                   // ID CRS Client
                                              Externalid__c = '124'                       // External Id
                                            );
    insert vente; 
  }
  private static User createUser(){
          
    Id standardUserProfileID = [SELECT ID, Name FROM Profile WHERE Name='System Administrator'].ID;

    User usr = New User(  FirstName              = 'Admin Test' , 
                          LastName               = 'Admin' ,  
                          alias                  = 'AjdoeT' , 
                          email                  = 'Adminjdoe@bbtest.com', 
                          username               = 'AdminjohnD@testuser.com', 
                          CommunityNickname      = 'AdminDoe032' , 
                          EmailEncodingKey       = 'UTF-8',
                          // DefaultCurrencyIsoCode = 'EUR', 
                          LocaleSidKey           = 'en_US', 
                          LanguageLocaleKey      = 'en_US',
                          TimeZoneSidKey         = 'Europe/Paris', 
                          ProfileID              = standardUserProfileID,
                          Phone                  = '+33 23 45 67 89',
                          BypassValidationRule__c = true,
                          BypassProcessBuilder__c = false,
                          BypassWorkflow__c       = false

    ); 
    return usr;     
          
  }
}