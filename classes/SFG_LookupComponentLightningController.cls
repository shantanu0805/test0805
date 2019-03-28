/**
 * Apex controller for the Lookup Lightning Component 
 * 
 * @author Anup Jadhav
 * @copyright Salesforce 2016
 */
public without sharing class SFG_LookupComponentLightningController {
    
    private static SFG_Logger log = new SFG_Logger(SFG_LookupComponentLightningController.class);

    /**
     *  Dynamically calls the db to retrieve the list of 
     *  sObject records 
     *  @sobjecttype e.g. Contact, Account, Custom_Object__c
     *  @optionalWhere e.g. where id = blah
     *  @filterByUser if true, filter the results with related accountIds
     *  @return returns a json of sObject id and name
     */
    @AuraEnabled
    public static String getListForSObject(String sobjectType, String optionalWhere,  Boolean filterByUser) {

        log.enterMethod('getListForSObject').param('sobjectType', sobjectType);

        String recordIdNameJSOn = '';

        try {
                // return empty string for invalid param(s)
                if (sobjectType == '' || sobjectType == null) return recordIdNameJSOn;


                // santize the input to prevent SOQL injection
                sobjectType = String.escapeSingleQuotes(sobjectType);

                // Add sObject queryable check
                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sobjectType);
                SFG_AuthorisationService authService = new SFG_AuthorisationServiceImpl();
                Map<sobjectType, List<String>> sobjectTypeFieldsMap = new Map<sobjectType, List<String>>();
                sobjectTypeFieldsMap.put(convertType, new List<String>());
                if (!authService.isQueryable(sobjectTypeFieldsMap)) {
                    log.debug('the sObject : '+sobjectType+' is not queryable', false);
                    return recordIdNameJSOn;
                }

                String queryString = 'SELECT Id, Name FROM '+ sobjectType ;

                if (optionalWhere != null) {
                    log.debug('The optional where is: ', optionalWhere);
                    queryString +=  optionalWhere;
                }

                // The purpose of filterByUser
                // is to filter the results based on the 
                // accounts linked to the loggedIn user
                // because the class is now without sharing
                if (filterByUser == true) {
                    Set<Id> accountIds = new Set<Id>();

                    // get current user
                    User loggedInUser = [Select Id, contactId from User where Id = :UserInfo.getUserId()];

                    if(loggedInUser.contactId != null) {
                        // get user contact
                        Contact loggedInUserContact = [Select Id, accountId from Contact where Id = :loggedInUser.contactId];

                        if(loggedInUserContact.accountId != null) {
                            // get user current Account
                            Account currentUserAccount = [Select Id, ParentId from Account where Id = :loggedInUserContact.accountId];

                            accountIds.add(currentUserAccount.Id);

                            // check if its the parent or the child
                            if(currentUserAccount.ParentId == null) {
                                //either its the parent or the only account with no hierarcy
                                // check for children
                                List<Account> childAccounts = [Select Id from Account where ParentId = :currentUserAccount.Id];
                                if (childAccounts != null && childAccounts.size() > 0) {
                                    for(Account acct : childAccounts) {
                                        accountIds.add(acct.Id);
                                    }
                                }
                            } else {
                                // current account has a parent and therefore
                                // retrieve all kids
                                accountIds.add(currentUserAccount.ParentId);
                                // add it to the list and get all the siblings
                                List<Account> childAccounts = [Select Id from Account where ParentId = :currentUserAccount.ParentId];
                                if (childAccounts != null && childAccounts.size() > 0) {
                                    for(Account acct : childAccounts) {
                                        accountIds.add(acct.Id);
                                    }
                                }
                            }

                            if(accountIds.size() > 0) {
                                queryString += ' and Id IN :accountIds';
                            }
                        }
                        
                    }   


                }

                log.debug('The queryString is ', queryString);
                System.debug('>> The queryString is : ' + queryString);

                List<sObject> sobjList = Database.query(queryString);

                

                if (sobjList != null) {
                    recordIdNameJSOn = JSON.serializePretty(sobjList);
                    log.debug('The recordIdNameJSOn is ', recordIdNameJSOn);
                }
            
        } catch (Exception ex) {
            // Todo - add more sophisticated exception handling
            // return empty string for access and dml exception
            // throw aura exception for every other type of exception
            log.error('Exception inside LookupComponent getListForSObject methods', ex);
            
        }
        
        log.exitMethod('getListForSObject').withResult(recordIdNameJSOn);

        return recordIdNameJSOn;
    }


}