global class batchJobOnBooks implements Database.Batchable<sObject>{
   global final String Query;
   global final String Entity;
   global final String Field;
   global final Integer Value;

   global batchJobOnBooks (String q, String e, String f, Integer v){
             Query=q; Entity=e; Field=f;Value=v;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
      for(Sobject s : scope){
          s.put(Field,Value); 
      }      
     update scope;
   }

   global void finish(Database.BatchableContext BC){
        Book__c record = new Book__c();
      //  record = [SELECT Name,Batch_Job_Number__c,Batch_Fired__c
      //            FROM Book__c LI];
		System.debug('Finish called || record = ');
   }
}