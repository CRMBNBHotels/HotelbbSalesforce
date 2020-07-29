@isTest
public class BB_Object_Test {
    @isTest
    static void testInitialization() {
        BB_Object bbObj = new BB_Object();
        Map<String, String> mapHeaderToValue = bbObj.initializeRequestHeader();
        String method = bbObj.initializeRequestMethod();
        String apiKey = bbObj.getApiKey();
		String cleanedResponse = bbObj.cleanResponse('bb:@*End');
    }
}