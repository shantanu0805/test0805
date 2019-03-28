global class ScheduleBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        String q = 'SELECT Industry FROM Account LIMIT 10';
        String e = 'Account';
        String f = 'Industry';
        String v = 'Life Sciences';

        UpdateAccountFields batchable = new UpdateAccountFields(q,e,f,v);
        database.executebatch(batchable);
    }
}