public class PostInstalLoadController{

    public void loadData(){
        
        
       methodToCreateUserAndAssignPermSet();    
    
    //insertCases();
        
    }
    
    
    public void methodToCreateUserAndAssignPermSet() {
        
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Name = 'Setup_Audit_Fields'];
        System.debug('>> userInfo : ' + userInfo.getUserId());
        PermissionSetAssignment permAssignment = new PermissionSetAssignment(PermissionSetId = permSet.Id , 
                                                                            AssigneeId = userInfo.getUserId());
        insert permAssignment;
        
        User user1 = genericUserCreation('Standard User','Brenda','Sevice');    
        insert user1; 
        
        User user2 = genericUserCreation('System Administrator','Jay','Sevice');    
        insert user2;
        
        caseCreationMethod(userInfo.getUserId());
    }
    
    //Insert Cases
    public void insertCases(){
    
        System.debug('>> Inside insertCases');
        List<Map<String, String>> csvMapList = CSVController.readCSV('Case');
        System.debug('>> csvMapList : ' + csvMapList);
        List<Case> caseList = (List<Case>)CSVController.createSObject('Case', csvMapList);
        System.debug('>> caseList : ' + caseList);
        insert caseList;
    }
    
    
    public user genericUserCreation(String profileToAssign, String firstName ,String LastName) {
        
        Profile prfileToAssign = [SELECT Id FROM Profile WHERE Name =: profileToAssign];
        
        user newUser = new user (firstName = firstName , LastName = LastName,
                                 ProfileId = prfileToAssign.Id, Alias = 'Tcode',
                                 TimeZoneSidKey = 'GMT',
                                 Email = firstName+'.'+LastName +'@rnrexample.com',
                                 Username = firstName+'.'+LastName+'@rnrexample.com',
                                 CommunityNickname = firstName +'.'+LastName+'comm1',
                                 LocaleSidKey = 'en_US',
                                 LanguageLocaleKey = 'en_US',
                                 EmailEncodingKey = 'UTF-8');
                                        
        return newUser; 
        
    }
    
    @future
    private static void caseCreationMethod(Id userId) {
        
        Case newCase = new Case(CreatedById = userId, CreatedDate = System.Today()-7, Origin  = 'Web');
        insert newCase;
        
    }
    
       
}