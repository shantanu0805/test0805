/**
 * Test the lookup component
 * 
 * @author Anup Jadhav
 * @copyright Salesforce 2016
 */
//@isTest
public class SFG_LookupComponentLtngCtrlrTest {
    /*
    static testMethod void testGetListForSObject() {
        
        String response = '';
        Test.startTest();
            
            // Act
            // Get the hr portal user
            User hrPortalUser  = [ SELECT Id 
                                   FROM User 
                                   WHERE Name = 'John Rambo' LIMIT 1 ];

            System.runAs(hrPortalUser) {
                response = SFG_LookupComponentLightningController.getListForSObject('Account', ' ', false);
            }
        Test.stopTest();
        // Assert
        // System.debug(response);
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {

            // Start at the array of invoices.

            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

                while (parser.nextToken() != null) {
                    System.debug(' parser nextToken '+parser.nextToken());
                     if (parser.getCurrentToken() == JSONToken.VALUE_STRING && 
                        parser.getText().contains('Portal Account')) {  
                        System.assertEquals(parser.getText(), 'Portal Account Parent');
                    } 
                }
            }
        }
    }

    @isTest static void testGetListForSObjectForCommunityUser() {
        
        String response = '';
        Test.startTest();
       
        // Get the hr portal user
        User hrPortalUser  = [ SELECT Id 
                               FROM User 
                               WHERE Name = 'John Rambo' LIMIT 1 ];

        System.runAs(hrPortalUser) {
            response = SFG_LookupComponentLightningController.getListForSObject('Account', ' ', true);
        }
        Test.stopTest();
        // Assert
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {

            // Start at the array of invoices.

            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

                while (parser.nextToken() != null) {
                    System.debug(' parser nextToken '+parser.nextToken());
                     if (parser.getCurrentToken() == JSONToken.VALUE_STRING && 
                        parser.getText().contains('Portal Account')) {  
                        System.assertEquals(parser.getText(), 'Portal Account Parent');
                    } 
                }
            }
        }
    }

    @isTest static void testGetListForSObjectForCommunityUser2() {
        
        String response = '';
        Test.startTest();

            // Get the hr portal user
            User hrPortalUser  = [ SELECT Id, ContactId, Contact.AccountId 
                                   FROM User 
                                   WHERE Name = 'John Rambo' LIMIT 1 ];

            Account childAcc = [SELECt Id, Name FROM Account WHERE Name = 'Portal Account Child2' LIMIT 1];
            COntact con = new Contact(Id = hrPortalUser.ContactId, AccountId = childAcc.Id);
            update con;

            System.runAs(hrPortalUser) {
                response = SFG_LookupComponentLightningController.getListForSObject('Account', ' ', true);
            }
        Test.stopTest();
        // Assert
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {

            // Start at the array of invoices.

            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

                while (parser.nextToken() != null) {
                    System.debug(' parser nextToken '+parser.nextToken());
                     if (parser.getCurrentToken() == JSONToken.VALUE_STRING && 
                        parser.getText().contains('Portal Account')) {  
                        System.assertEquals(parser.getText(), 'Portal Account Parent');
                    } 
                }
            }
        }
    }

    @testSetup static void createTestData() {
        
        // Need the customer community plus profile id 
        // to create the Portal Account below
        Profile hrUserProfile = [ SELECT Id, Name, UserType 
                                  FROM Profile 
                                  WHERE Name = 'HR Community User' LIMIT 1] ;

        // Super annoying that I need this too
        // but need to retrieve a sys admin user below
        // for finance approver
        Profile sysAdminProfile = [ SELECT Id, Name, UserType 
                                     FROM Profile 
                                    WHERE Name = 'System Administrator' LIMIT 1] ;

        // All accounts in qa/dev seem to be created with
        // the corporate record type
        RecordType corporateRT = [ SELECT DeveloperName, Id, IsActive,
                                          Name,SobjectType 
                                    FROM RecordType 
                                   WHERE SobjectType = 'Account' 
                                     AND DeveloperName = 'Corporate' 
                                     AND IsActive = true LIMIT 1];

        // Need this user to set the Finance Approver field on
        // the parent account because it is a mandatory field 
        // when the Debtor flag is set
        User financeApprover = [ SELECT Id 
                                 FROM User
                                 WHERE ProfileId = :sysAdminProfile.Id 
                                   AND UserRoleId != null 
                                   AND isActive = true LIMIT 1];

        System.runAs(financeApprover) {
            // Setting the minimum mandatory fields and nothing else
            // for the parent account
            Account portalAccountParent             = new Account(name = 'Portal Account Parent');
            //portalAccountParent.RecordTypeId        = corporateRT.Id ;
            //portalAccountParent.Country__c          = 'UNITED KINGDOM';
            portalAccountParent.BillingCity         = 'London';
            //portalAccountParent.Region__c           = 'Europe';
            //portalAccountParent.Type__c             = 'Key';
            portalAccountParent.Phone               = '07590728789';
            //portalAccountParent.CurrencyIsoCode     = 'GBP';
            portalAccountParent.BillingCountry      = 'UNITED KINGDOM';
            //portalAccountParent.Debtor__c           = true;
            //portalAccountParent.Finance_Approver__c = financeApprover.Id;
            insert portalAccountParent;

            // Now that I have the parent account, lets 
            // create two child accounts
            // Child account 1
            Account portalAccountChild1         = new Account(name = 'Portal Account Child1');

            portalAccountChild1.Phone           = '07590728789';
            //portalAccountChild1.CurrencyIsoCode = 'GBP';
            portalAccountChild1.BillingCountry  = 'UNITED KINGDOM';
            portalAccountChild1.BillingCity     = 'London';
            portalAccountChild1.ParentId        = portalAccountParent.Id;
            insert portalAccountChild1;

            // Child account 2
            Account portalAccountChild2         = new Account(name = 'Portal Account Child2');

            portalAccountChild2.Phone           = '07590738789';
            //portalAccountChild2.CurrencyIsoCode = 'USD';
            portalAccountChild2.BillingCountry  = 'USA';
            portalAccountChild2.BillingCity     = 'SF';
            portalAccountChild2.ParentId        = portalAccountParent.Id;
            insert portalAccountChild2;

            // Now that we have the parent child accounts setup
            // with the debtor flag on the parent account
            // It is time to create contacts
            Contact portalContact       = new Contact();
            portalContact.FirstName     = 'PortalFirst';
            portalContact.LastName      = 'PortalLast';
            portalContact.Email         = 'portal.contact@santafe.com';
            portalContact.AccountId     = portalAccountParent.Id;
            insert portalContact;

            // Finally after all that hassle create the freakin
            // portal user
            User hrPortalUser               = new User();
            hrPortalUser.Email              = 'john.rambo@tiger.com';
            hrPortalUser.ProfileId          = hrUserProfile.Id;
            hrPortalUser.UserName           = 'john.rambo@tiger.com.hrportal';
            hrPortalUser.Alias              = 'Rambo';
            hrPortalUser.TimeZoneSidKey     = 'America/New_York';
            hrPortalUser.EmailEncodingKey   ='ISO-8859-1';
            hrPortalUser.LocaleSidKey       ='en_US';
            hrPortalUser.LanguageLocaleKey  ='en_US';
            hrPortalUser.ContactId          = portalContact.Id;
            hrPortalUser.PortalRole         = 'Manager';
            hrPortalUser.FirstName          = 'John';
            hrPortalUser.LastName           = 'Rambo';
            insert hrPortalUser;
        }
        
    }
    */
}