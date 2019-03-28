global class BatchToUpdateStock implements Database.Batchable<sObject>,   Database.AllowsCallouts {

     public String query;
     public List<String> properties {get; set;}
     public List<String> values {get; set;}

     global BatchToUpdateStock(String q, List<String> properties, List<String> values){
                 query=q;
     }
   
     global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
     }

     global void execute(Database.BatchableContext BC, List<sObject> scope) {         

      List<Stock__c> stocksToUpdate = (List<Stock__c>)scope;  
      List<Stock__c> newValues = new List<Stock__c>();

       for(Stock__c a : stocksToUpdate ){ 
       Stock__c stock = new Stock__c();
           stock.Name = a.Name; 
           stock.Value__c = a.Value__c; 
           stock.StockName__c = 'a0Ho0000006aTRWEA2';
           newValues.add(a);
       } 
       insert newValues; 
    }   

    global void finish(Database.BatchableContext BC){
       //you can also do some after-the-job-finishes work here  
    }
}