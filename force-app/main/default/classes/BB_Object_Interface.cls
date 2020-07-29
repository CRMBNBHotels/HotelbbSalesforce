public interface BB_Object_Interface {
    Map<String, String> initializeRequestHeader();
    String initializeRequestEndpoint();
    String initializeRequestEndpointUpdate();
    String initializeRequestBody(boolean includesPaging, String pageKey, String sfdcId, set<String> setfieldtoInclude, String PageDateKey);
    String initializeRequestMethod();
    DataTableWrapper createTableFromResponse(String strResponse);
    DataTableWrapper createTableFromBadResponse(String strResponse, integer errorCode);
}