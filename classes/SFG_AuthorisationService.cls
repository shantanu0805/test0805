/**
* Used to verify access check for sObjects and fields
* 
* @copyright Salesforce 2016
*/

public interface SFG_AuthorisationService {

    Boolean isUpdateable(Map<sObjectType, List<String>> sObjectFieldsMap);
    Boolean isAccessible(Map<sObjectType, List<String>> sObjectFieldsMap);
    Boolean isCreateable(Map<sObjectType, List<String>> sObjectFieldsMap);
    Boolean isDeletable(Map<sObjectType, List<String>> sObjectFieldsMap);
    Boolean isQueryable(Map<sObjectType, List<String>> sObjectFieldsMap);


}