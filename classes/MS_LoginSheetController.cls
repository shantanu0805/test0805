public with sharing class MS_LoginSheetController {
    public MS_LoginSheetController() {
        
    }
    //test 
    
    @AuraEnabled
    public static List<LoginCredWrapper> getRecentlyViewed() {
        try{
            List<MS_Client_Login__c> recentItems = [SELECT Id, Client_Name__r.Name, Environment__c, Sandbox_Name__c, Login_Url__c FROM MS_Client_Login__c ORDER BY Last_Viewed_TS__c DESC LIMIT 3];
            List<LoginCredWrapper> recentRecords = new List<LoginCredWrapper>();
            for(MS_Client_Login__c singleItem : recentItems){
                LoginCredWrapper singleRecord = new LoginCredWrapper();
                singleRecord.recordId = singleItem.Id;
                singleRecord.name = singleItem.Client_Name__r.Name;
                singleRecord.environment = singleItem.Environment__c;
                singleRecord.sandbox = singleItem.Sandbox_Name__c;
                singleRecord.loginUrl = singleItem.Login_Url__c;
                recentRecords.add(singleRecord);
            }
            return recentRecords;
        }
        catch(Exception ex){
            System.debug('>> Exception in getting Client Creds : ' + ex);
            return null;
        }
    }
    
    
    @AuraEnabled
    public static List<LoginCredWrapper> getAllClientCreds(Id accountId) {
        try{
            List<MS_Client_Login__c> recentItems = [SELECT Id, Client_Name__r.Name, Environment__c, Sandbox_Name__c, Login_Url__c FROM MS_Client_Login__c WHERE Client_Name__r.Id =: accountId ORDER BY Last_Viewed_TS__c ];
            List<LoginCredWrapper> allRecords = new List<LoginCredWrapper>();
            for(MS_Client_Login__c singleItem : recentItems){
                LoginCredWrapper singleRecord = new LoginCredWrapper();
                singleRecord.recordId = singleItem.Id;
                singleRecord.name = singleItem.Client_Name__r.Name;
                singleRecord.environment = singleItem.Environment__c;
                singleRecord.sandbox = singleItem.Sandbox_Name__c;
                singleRecord.loginUrl = singleItem.Login_Url__c;
                allRecords.add(singleRecord);
            }
            return allRecords;
        }
        catch(Exception ex){
            System.debug('>> Exception in getting Client Creds : ' + ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static List<ClientWrapper> getClientDetails(Id accountId) {
        try{
            List<Account> clientDetail = [SELECT Name, BillingAddress, Description, Production_Org_Id__c, SFDC_Premier_Success_Plan__c, (SELECT Name, Email, Title, Phone FROM Contacts) FROM Account WHERE Id =: accountId];
            
            List<ClientWrapper> allRecords = new List<ClientWrapper>();
            for(Account singleItem : clientDetail){
                ClientWrapper singleRecord = new ClientWrapper();
                singleRecord.name = singleItem.Name;
                singleRecord.address = singleItem.BillingAddress;
                singleRecord.info = singleItem.Description;
                singleRecord.orgId = singleItem.Production_Org_Id__c;
                singleRecord.sfdcPlan = singleItem.SFDC_Premier_Success_Plan__c;
                singleRecord.contacts = singleItem.Contacts;
                allRecords.add(singleRecord);
            }
            
            return allRecords;
        }
        catch(Exception ex){
            System.debug('>> Exception in getting Client Details : ' + ex);
            return null;
        }
    }

    @AuraEnabled
    public static void updateLastViewed(Id credentialId) {
        try{
            System.debug('>> credentialId : ' + credentialId);
            System.debug('>> timeStamp : ' + String.valueof(DateTime.now().getTime()));
            MS_Client_Login__c currentCredential = [SELECT Id, Last_Viewed_TS__c FROM MS_Client_Login__c WHERE Id =: credentialId];
            System.debug('>> currentCredential : ' + currentCredential);
            currentCredential.Last_Viewed_TS__c = String.valueof(DateTime.now().getTime());
            update currentCredential;
        }
        catch(Exception ex){
            System.debug('>> Exception in updating timeStamp : ' + ex);
        }
    }
    
    public class LoginCredWrapper{

        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String recordId{get;set;}
        @AuraEnabled public String environment{get;set;}
        @AuraEnabled public String sandbox{get;set;}
        @AuraEnabled public String loginUrl{get;set;}
    }

    public class ClientWrapper{

        @AuraEnabled public String name{get;set;}
        @AuraEnabled public Address address{get;set;}
        @AuraEnabled public String info{get;set;}
        @AuraEnabled public String orgId{get;set;}
        @AuraEnabled public String sfdcPlan{get;set;}
        @AuraEnabled public List<Contact> contacts{get;set;}

    }
}