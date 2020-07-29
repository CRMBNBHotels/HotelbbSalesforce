/**
* Class used for the implementation of the PAD methodology
* @version 1.00 
* @author EI Technologies
* @Trigger ALL
* @CodeCoverage 100% 
*/
public without sharing class PAD 
{
    
        public static String bypassTrigger; //List of bypassed triggers
        
        public static final User user;
        
        static {
            
            user = [Select BypassApex__c
                   from User 
                   where Id=:UserInfo.getUserId()];
            bypassTrigger = ';'+ user.BypassApex__c+ ';';                                                                                                                                   
            System.debug('>>>>> PAD constructor : END <<<<<'+bypassTrigger);
        }
          
        /**
        * Method used for the class PAD
        * @param c object of type JonctionServicePrestation__c
        * @return boolean
        */
         public static boolean canTrigger(string Name){
            return (bypassTrigger.indexof(';' + Name + ';') == -1);

         }
    
         
        
        
}