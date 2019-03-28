global class BookBatchJobScheduler implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        String q = 'SELECT Name,Total_in_inventory__c FROM Book__c';
        String e = 'Book';
        String f = 'Total_in_inventory__c';
        Integer v = 300;

        batchJobOnBooks batchable = new batchJobOnBooks(q,e,f,v);
        database.executebatch(batchable);
    }
}