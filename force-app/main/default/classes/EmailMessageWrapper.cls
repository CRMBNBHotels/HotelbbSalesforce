/**
* This class is a wrapper that contains all necessary attributes to send emails
* @version 1.00 13 january 2020
* @author TMA
*/
public with sharing class EmailMessageWrapper {
    public String FromAddress;
    public String FromDisplayName;
    public List<String> ToAddress ;
    public String ToAddressId ;
    public String BccAddress ;
    public String Subject;
    public Map<String,String> ParameterSubjectMap ;
    public String Body;
    public Map<String,String> ParameterBodyMap ;
    
    public EmailMessageWrapper(String fromAddr,string fromDisplayName, List<String> toAddr, Id toAddrId, String sub, Map<String, String> mapSubjectParams, Map<String, String> mapBodyParams) {
        this(fromAddr, fromDisplayName, toAddr , toAddrId, null, sub, mapSubjectParams, null, mapBodyParams );
    }

    public EmailMessageWrapper(String fromAddr, string fromDisplayName, List<String> toAddr, Id toAddrId, String bccAddr, String sub, Map<String, String>  mapSubjectParams, String body, Map<String, String> mapBodyParams) {
        this.FromAddress = fromAddr;
        this.FromDisplayName= fromDisplayName;
        this.ToAddress = toAddr;
        this.ToAddressId = toAddrId;
        this.BccAddress = bccAddr;
        this.Subject = sub;
        this.ParameterSubjectMap = mapSubjectParams;
        this.Body = body;
        this.ParameterBodyMap = mapBodyParams;
    }
}