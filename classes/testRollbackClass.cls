public without sharing class testRollbackClass {
    
    public class RollBackException extends Exception {}
    public static boolean status;
    public static boolean checkDml(List<Account> acc){
        Savepoint sp = Database.setSavepoint();
        system.debug('>> Inside checkDml >> sp created');
        for(Account acc1: acc){
            Database.SaveResult saveParentResult = CloneListUtil.createCloneParentRecord();
            if(saveParentResult.isSuccess()) {
                system.debug('>> saveParentResult success');
                testRollbackClass.status = true;
                throw new RollBackException('Custom Error'); 
                system.debug('>> After throw Exception 11 ');
                Database.rollback(sp);
            } else {
                testRollbackClass.status = false;
                for(Database.Error dbError : saveParentResult.getErrors()) {
                    System.debug('@@@@Error In Opportunity Amend Process>>>>' + dbError.getStatusCode().name() + ' : ' + dbError.getMessage()); 
                    throw new RollBackException(dbError.getMessage()); 
                    system.debug('>> After throw Exception');
                    Database.rollback(sp);
                } 
            }
        }
        return testRollbackClass.status;
    }
}