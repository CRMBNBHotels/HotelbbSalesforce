public without sharing class DataTableWrapper {

    @AuraEnabled public List<String> listHeaders;
    @AuraEnabled public List<TableRecord> listRecords;
    @AuraEnabled public String pageKey;
    @AuraEnabled public String pageDateKey;
    @AuraEnabled public String errorMessage;
    public class TableRecord {
        @AuraEnabled public List<TableField> listFields;
    }
    
    public class TableField {
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String fieldType;
        @AuraEnabled public String SFID;
        
        public TableField(String val, String type, String recordId) {
            fieldValue = val;
            fieldType = type;
            SFID = recordId;
        }
    }
}