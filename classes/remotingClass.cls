global with sharing class remotingClass {
 
      public Book__c pos{get;set;}
      public List<Book__c> title{get;set;}
      public List<Book__c> positions{get;set;}
 
      public remotingClass() {
         pos = [select Name from Book__c where Name = 'All is said'];
      }
     
      @RemoteAction
      global static Book__c getBookDetails(String pos) {
          return [select Book__c.Name, Price__c, Language__c, Category__c,Author__r.Name from Book__c 
                  WHERE  Book__c.Name =: pos];
 
      }
}