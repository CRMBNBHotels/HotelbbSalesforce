/** 
* Apex Class Handler trigger 
*
* @author  JKA
* @version 0.1
* @date    22/01/2020 
* 
** -- History         
* -- Date          Name        Version      Remarks
* -- -----------   ----------   -------      ---------------------------------------
*/

public without sharing class ContactHandler {
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public ContactHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Contact[] newRecords){
        system.debug('@@@@@ in Contact OnBeforeInsert');
        List<Contact> Listcont = new List<Contact>();
        for(Contact cont : newRecords ){
            if(cont.MobilePhone!=null)
            {
                Listcont.add(cont);
            }
        }
        if(Listcont!=null && Listcont.size()>0)
        {
            /*if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('Ap01_Contact')) 
               || !UtilsBypass.canISkipApexClass('Ap01_Contact') 
               || !UtilsBypass.canISkipApexMethod('MAJMobileCountryCode')){
                   Ap01_Contact.MAJMobileCountryCode(Listcont);
               }*/
            
        }
        
    }
    
    public void OnAfterInsert(Contact[] newRecords,Map<ID, Contact> recordMap, Map<ID, Contact> recordMapOld){
        
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    }
    
    public void OnBeforeUpdate(Contact[] oldRecords, Contact[] updatedRecords, Map<ID, Contact> recordMap, Map<ID, Contact> recordMapOld){
        system.debug('@@@@@ in Contact OnBeforeUpdate');

        //TMABNB-62
        List<Contact> Listcont = new List<Contact>();
        for(Contact cont : updatedRecords ){
            if(cont.MobilePhone!=null && recordMapOld.get(cont.Id).MobilePhone !=cont.MobilePhone )
            {
                Listcont.add(cont);
            }
        }
        if(Listcont!=null && Listcont.size()>0)
        {
            /*if((UtilsBypass.getUserBypassApexClass() != null && !UtilsBypass.getUserBypassApexClass().contains('Ap01_Contact')) 
               || !UtilsBypass.canISkipApexClass('Ap01_Contact') 
               || !UtilsBypass.canISkipApexMethod('MAJMobileCountryCode')){
                   //TMABNB-JK-55
                   Ap01_Contact.MAJMobileCountryCode(Listcont);
               }*/
        }
    }
    
    public void OnAfterUpdate(Contact[] oldRecords, Contact[] updatedRecords, Map<ID, Contact> recordMap,  Map<ID, Contact> recordMapOld){  
        
        
    }
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
        
    } 
    
    public void OnBeforeDelete(Contact[] recordsToDelete, Map<ID, Contact> recordMap){
        
    }
    
    public void OnAfterDelete(Contact[] deletedRecords, Map<ID, Contact> recordMap){
        
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
        
    }
    
    public void OnUndelete(Contact[] restoredRecords){
        
    }
    
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext{
        get{ return !IsTriggerContext;}
    }
}