public without sharing class CloneListUtil {

    public static Database.SaveResult createCloneParentRecord() {
        Savepoint sp = Database.setSavepoint();//For possible rollback if there are errors present in DML
        system.debug('>> Inside createCloneParentRecord >> sp createdin createCloneParentRecord');
        Book__c  testBook = new Book__c (Name = 'Test Book'); 
        Database.SaveResult svResult = Database.Insert(testBook, true);
        system.debug('>> svResult : ' + svResult);
        if(svResult.isSuccess()) {
            Database.rollback(sp);//Rollback if errors present
        }
        return svResult;
    }
}