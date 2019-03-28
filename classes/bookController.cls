global with sharing class bookController {
 
      public Book__c pos{get;set;}
      public List<Book__c> title{get;set;}
      public List<Book__c> positions{get;set;}
 
      public bookController() {
 
         pos = [select Name from Book__c where Name = 'All is said'];
      }
       /**
 
      * Method that creates the select option dynamically.
 
      **/
 
      public List<SelectOption> getOptions() {
 
          List<SelectOption> options = new List<SelectOption>();
          title = [select Book__c.Name from Book__c];
         //Creating an NULL option.
         options.add(new SelectOption('none','--Select--'));
         for( Book__c a :title ){
 
            options.add(new SelectOption(a.Name,a.Name));
         }
         return options;
      }
 
      /**
 
      * Remote action involved with Javascript remoting and is made global
 
      **/
 
      @RemoteAction
      global static Book__c[] getBookDetails(String pos) {
          return [select Book__c.Name, Price__c, Language__c, Category__c,Available__c from Book__c WHERE
                  Book__c.Name =: pos];
 
      }
 
}