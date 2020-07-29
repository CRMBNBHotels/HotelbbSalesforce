/*
* @author: TMA-EI JK
* @date: 19/04/2019 
* @description: This class is used to serialize / deserialize / get value for the object. It will be used by th webservice for a possible rollback/modif base on the response of the webservice.
* @Test: AP02_SObject_WS_test
* @Coverage: 89 %
*/
public class AP02_SObject_WS {
    //Declare object
    //It will contains the object it self + any other property needed to be saved but it is not a field
    public class SerializeObject {
        public SObject sobj {get;set;}
        public Integer nbPoint {get;set;}
        public String typePt {get;set;}
        public string Reason{get;set;}
        
        //Added by TMA Cynthia Geagea - CRMSS 260 - 27/08/2019 - Start
        public string Description {get;set;}
        //Added by TMA Cynthia Geagea - CRMSS 260 - 27/08/2019 - End
    }
    
    //Method used to create a initialize a serializedObject instance using the real object sent and serialize the instance
    public static Map<String,String> Serialize(Map<String,sObject> mapSObject,Map<String,String> mapType, Map<String,Integer> mapNBPT ){
        Map<String,String> mapJson = new Map<String,String>();
        For(String sobjID : mapSObject.keyset()){
            SerializeObject serObj = new SerializeObject();
            SObject sobj = mapSObject.get(sobjID);
            serObj.sobj = sobj;
            if(mapType != null && mapType.containsKey(sobjID) && mapNBPT != null && mapNBPT.containsKey(sobjID) ){
              serObj.typePt =  mapType.get(sobjID);
              serObj.nbPoint =  mapNBPT.get(sobjID); 
            }
            mapJson.put(sobjID,JSON.serialize(serObj));
        }
        return mapJson;
    }
    
    //Method used to deserialize the create instance of serializedObject 
    public static Map<String,SerializeObject> Deserialize(Map<String,String> mapSObjectJson) {
        Map<String,SerializeObject> mapSerObj = new Map<String,SerializeObject>();
        For(String sobjID : mapSObjectJson.keyset()){
            SerializeObject serObj = new SerializeObject();
            serObj = (SerializeObject)JSON.deserializeStrict(mapSObjectJson.get(sobjID),SerializeObject.Class);
            mapSerObj.put(sobjID,serObj);
        }
        return mapSerObj;
    }
    
    //Method used to create a map of the object id -> map of field value
    public static Map<ID,Map<String,String>> GetFieldAndValueMap(Map<String,SerializeObject> mapSerObj) {
        Map<ID,Map<String,String>> mapFieldVal = new Map<ID,Map<String,String>>();
        Map<String,String>  mapfieldValue =  new Map<String,String>();
        For(String objID : mapSerObj.keyset()){
            SerializeObject serObj = mapSerObj.get(objID);
            mapfieldValue = GetFieldAndValue(serObj);
            mapFieldVal.put(objID,mapfieldValue);
        }
        return mapFieldVal;
    }
    
    //Method used to create a map field name -> value
    Public Static  Map<String,String> GetFieldAndValue(SerializeObject SerObj){
        Schema.SObjectType sObjType = SerObj.sobj.getSObjectType();
        Map<String,String> mapFieldVal = new Map<String,String>();
        Map<String,Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();
        for(String fieldName : mfields.keyset()){
            mapFieldVal.put(fieldName,String.valueof(SerObj.sobj.get(fieldName)));
        }
        return mapFieldVal;
    }
    
    Public Static Sobject SetFieldAndValue(Sobject SObj, Set<String> setFieldToInclude){
        Set<String> setFieldToUpdate = new Set<String>();
        for(String fieldName : setFieldToInclude){
            setFieldToUpdate.add(fieldName.toLowerCase());
        }
        Schema.SObjectType sObjType = SObj.getSObjectType();
        SObject sobjModif = sObjType.newSObject();
        Map<String,Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();
        for(String fieldName : mfields.keyset()){
            Schema.DescribeFieldResult fieldResult = mfields.get(fieldName).getDescribe();
            if(setFieldToUpdate.contains(fieldName.toLowerCase())  && fieldResult.isUpdateable()){
                sobjModif.put(fieldName,SObj.get(fieldName) );
            }
        }
        return sobjModif;
    }
    
}