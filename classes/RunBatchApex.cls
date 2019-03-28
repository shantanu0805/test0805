public class RunBatchApex {
// Query for 10 accounts
String q = 'SELECT Industry FROM Account LIMIT 10';
String e = 'Account';
String f = 'Industry';
String v = 'Life Sciences';
//Id batchInstanceId = Database.executeBatch(new UpdateAccountFields(q,e,f,v), 5);
UpdateAccountFields batchable = new UpdateAccountFields(q,e,f,v);
String cronID = System.scheduleBatch(batchable, 'job example', 1);
CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :cronID];

// TimesTriggered should be 0 because the job hasn't started yet.
//System.assertEquals(0, ct.TimesTriggered);
//System.debug('Next fire time: ' + ct.NextFireTime);

}