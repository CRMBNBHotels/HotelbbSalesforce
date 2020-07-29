public without sharing virtual class BB_Object {
     
    public final String apiKey = Label.BBUS_WalletAPIKey;
    
    public Map<String, String> initializeRequestHeader() {
        Map<String, String> mapHeaders = new Map<String, String>();
        mapHeaders.put('content-type', 'application/json');
        mapHeaders.put('Accept', 'application/json');
        mapHeaders.put('x-Gateway-APIKey', Label.BBUS_HeaderAPIKey);
        return mapHeaders;    
    } 
    
    public String initializeRequestMethod() {
        return 'POST';
    }
    
    @TestVisible
    protected String getApiKey() {
        return apiKey;
    }
    
    @TestVisible
    protected String cleanResponse(String strResponse) {
        system.debug('test cleanResponse strResponse'+strResponse);
        strResponse = strResponse.replace('bb:', '');
        strResponse = strResponse.replace('@', '');
        strResponse = strResponse.replace('*','');
        strResponse = strResponse.replace('End', 'EndTime');
        return strResponse;
    }
}