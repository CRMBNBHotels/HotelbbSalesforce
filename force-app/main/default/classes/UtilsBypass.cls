/** 
 * Apex class containing static methods to bypass or run ony once a trigger
 *
 * @author  Omar Bensouda Korachi <o.bensouda@obkconsulting.com>
 * @version 0.1
 * @date    11/10/2019 
 * 
 ** -- History         
 * -- Date          Name        Version      Remarks
 * -- -----------   ----------   -------      ---------------------------------------
 */
public without sharing class UtilsBypass {
    
    public static User                  currentUser;                    				                    /** Current User **/
    public static final Set<String>     executeOnceApexClass            = new Set<String>{};                /**  Set of classes to be executed only once */
    public static Set<String>           hasBeenExecutedApexClass        = new Set<String>();                /** Set of classes which has been executed*/
    public static final Set<String>     executeOnceTrigger              = new Set<String>{};                /**  Set of classes to be executed only once */
    public static Set<String>           hasBeenExecutedTrigger          = new Set<String>();                /** Set of classes which has been executed*/
    public static Set<String>           notBypassedTriggers             = new Set<String>();                /** Set of classes to be bypassed*/
    
    public static Map<String, String>   SKIP_APEXCLASS_MAP              = new Map<String, String>();        //ApexClass     -> Reason to skip
    public static Map<String, String>   SKIP_APEXTRIGGER_MAP            = new Map<String, String>();        //triggerName   -> Reason to skip
    public static Map<String, String>   SKIP_METHOD_MAP                 = new Map<String, String>();        //MethodName    -> Reason to skip

    /** 
    * Static getter returning the current user. 
    * Current User is queried in the Database if not loaded yet in Cache.
    * @author: Omar Bensouda Korachi
    * @return User The context User
    */     
    public static User getCurrentUser() { 
        System.debug('currentUser: '+ currentUser);
        System.debug('currentUser: '+ currentUser== null);
        if(currentUser == null) {
            currentUser = [SELECT ID,BypassWorkflow__c, BypassProcessBuilder__c, BypassApex__c, BypassValidationRule__c, UserName,
                           Profile.Name, Profile.Id, Email, Name, Phone
                           FROM User WHERE ID =:UserInfo.getUserID() LIMIT 1];
            System.debug('Fom Apex Class: UtilsBypass Method :getCurrentUser Value of currentUser: '+ currentUser);
        }
        return currentUser;
    }

    /** 
    * Static getter returning the current user. 
    * @Parm: User
    * @author: Omar Bensouda Korachi
    * @return User The context User
    */    
    public static void setCurrentUserParameter(User u){
        currentUser = u ;
        System.debug('Fom Apex Class: UtilsBypass Method :setCurrentUserParameter Value of currentUser: '+ currentUser);
    }

    /** 
    * Static getter returning true if the current user bypasses Apex Class
    * @author: Omar Bensouda Korachi
    * @return Boolean True if current user bypasses Validation Apex Class, else False 
    */         
    public static String getUserBypassApexClass() {
        return getCurrentUser().BypassApex__c;
    }

    /** 
    * Static getter returning true if the current user bypasses validation rules
    * @author: Omar Bensouda Korachi
    * @return Boolean True if current user bypasses Validation Rules, else False 
    */         
    public static Boolean getUserBypassVR() {
        return getCurrentUser().BypassValidationRule__c;
    }

    /** 
    * Static getter returning true if the current user bypasses Workflow
    * @author: Omar Bensouda Korachi
    * @return Boolean True if current user bypasses Workflow, else False 
    */         
    public static Boolean getUserBypassWF() {
        return getCurrentUser().BypassWorkflow__c;
    }
    
    /** 
    * Static getter returning true if the current user bypasses Process Builder
    * @author: Omar Bensouda Korachi
    * @return Boolean True if current user bypasses  Process Builder, else False 
    */         
    public static Boolean getUserBypassPB() {
        return getCurrentUser().BypassProcessBuilder__c;
    }
    
    /** 
     * Static method returning true when an apex class can execute, false if it must be bypassed
     * @author: Omar Bensouda Korachi
     * @param aClasName Name of the Apex Class written the same way it has been entered in the
     *                  BypassTriggers__c field of the user
     * @return Boolean true if the trigger can execute, false else
     */   
    public static Boolean canbyPassTrigger(String aTrigger) {  
        Boolean canbyPassTrigger = false; 
        if (SKIP_APEXTRIGGER_MAP.get(aTrigger)!= null){
            canbyPassTrigger = true;   
        }  
        if(UtilsBypass.notBypassedTriggers.contains(aTrigger)) {
            canbyPassTrigger = false;
        } 
        if(executeOnceApexClass.contains(aTrigger)) {
            if(hasBeenExecutedApexClass.contains(aTrigger)) {
                canbyPassTrigger = false;
            }
        }
        return canbyPassTrigger;
    }
    /**
    * Use to not bypass a trigger in all excution of the code for one contexte of limitation SFDC
    * @param aClassName Name of the Apex Class 
    * @author: Omar Bensouda Korachi
    */
    public static void setnotBypassedTriggers(String aTriggerName) {   
       UtilsBypass.notBypassedTriggers.add(aTriggerName);
    } 

    /**
    * Use to bypass a trigger in all excution of the code for one contexte of limitation SFDC
    * @param aClassName Name of the Apex Class 
    * @author: Omar Bensouda Korachi
    */
    public static void setexecuteOnceApexClass(String aClassName) {   
       executeOnceApexClass.add(aClassName);
       hasBeenExecutedApexClass.add(aClassName);
    } 
	
    /**
    * Use to bypass a trigger in all excution of the code for one contexte of limitation SFDC
    * @param aClasName Name of the Trigger
    * @author: Omar Bensouda Korachi
    */
    public static void setexecuteOnceTrigger(String aTriggerName) {   
       executeOnceTrigger.add(aTriggerName);
       hasBeenExecutedTrigger.add(aTriggerName);
    } 

    /**
    * Set : Use to bypass a Methode in the code 
    * @author: Omar Bensouda Korachi
    */
    public static void addSkipApexMethod(String nameOfTheMethod, String ReasontoSkip){
        UtilsBypass.SKIP_METHOD_MAP.put(nameOfTheMethod, ReasontoSkip);
    } 
    
    /**
    * Set : Use to bypass a Class in the code 
    * @author: Omar Bensouda Korachi
    */
    public static void addSkipApexClass(String nameOfTheApexClass, String ReasontoSkip){
        UtilsBypass.SKIP_APEXCLASS_MAP.put(nameOfTheApexClass, ReasontoSkip);
    } 

    /**
    * GET: Use to bypass a Methode in the code 
    * @author: Omar Bensouda Korachi
    */
    public static Boolean canISkipApexMethod(String nameOfTheMethod){
        Boolean canbyPass = false; 
        if(UtilsBypass.SKIP_METHOD_MAP.get(nameOfTheMethod)!=null){
             canbyPass = true; 
        }
        return canbyPass;
    } 
    
    /**
    * GET: Use to bypass a Class in the code 
    * @author: Omar Bensouda Korachi
    */
    public static Boolean canISkipApexClass(String nameOfTheApexClass){
        Boolean canbyPass = false; 
        if(UtilsBypass.SKIP_APEXCLASS_MAP.get(nameOfTheApexClass)!=null){
             canbyPass = true; 
        }
        return canbyPass;
    } 
}