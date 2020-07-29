public Interface BB_Object_Sync_Interface {
    SObject actionBadResponse(String strResponse, String sfdcId,Set<String> listField);
    void actionGoodResponse(String strResponse);
}