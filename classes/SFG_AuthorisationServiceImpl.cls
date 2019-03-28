public with sharing class SFG_AuthorisationServiceImpl 
    implements SFG_AuthorisationService {
    
    public Boolean isUpdateable(Map<sObjectType, List<String>> sObjectFieldsMap) {
        Boolean isUpdateable = true;
        
        for (sObjectType sobjType : sObjectFieldsMap.keySet()) {
            if (!sobjType.getDescribe().isUpdateable()) {
                System.debug('!!! '+sobjType.getDescribe());
                isUpdateable = false;
                continue;
            }
            Map<String,Schema.SObjectField> sobjFieldDescribeMap = sobjType.getDescribe().fields.getMap();
            if(sObjectFieldsMap.get(sobjType) != null &&
                sObjectFieldsMap.get(sobjType).size() > 0) {
                for (String fieldToCheck : sObjectFieldsMap.get(sobjType)) {
                    if( sobjFieldDescribeMap.get(fieldToCheck) != null && 
                        !sobjFieldDescribeMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                        System.debug('!!! '+fieldToCheck);
                        isUpdateable = false;
                    }
                }
            }
        }
        
        return isUpdateable;
    }

    public Boolean isAccessible(Map<sObjectType, List<String>> sObjectFieldsMap) {
        Boolean isAccessible = true;

        for (sObjectType sobjType : sObjectFieldsMap.keySet()) {
            if (!sobjType.getDescribe().isAccessible()) {
                isAccessible = false;
                continue;
            }
            Map<String,Schema.SObjectField> sobjFieldDescribeMap = sobjType.getDescribe().fields.getMap();
            if(sObjectFieldsMap.get(sobjType) != null &&
                sObjectFieldsMap.get(sobjType).size() > 0) {
                for (String fieldToCheck : sObjectFieldsMap.get(sobjType)) {
                    if( sobjFieldDescribeMap.get(fieldToCheck) != null && 
                        !sobjFieldDescribeMap.get(fieldToCheck).getDescribe().isAccessible()) {
                        isAccessible = false;
                    }
                }
            }
        }
        
        return isAccessible;
    }
    
    public Boolean isCreateable(Map<sObjectType, List<String>> sObjectFieldsMap) {
        Boolean isCreateable = true;
        for (sObjectType sobjType : sObjectFieldsMap.keySet()) {
            if (!sobjType.getDescribe().isCreateable()) {
                isCreateable = false;
                System.debug('!!! sobjType.getDescribe(): '+sobjType.getDescribe());
                continue;
            }
            Map<String,Schema.SObjectField> sobjFieldDescribeMap = sobjType.getDescribe().fields.getMap();
            if(sObjectFieldsMap.get(sobjType) != null &&
                sObjectFieldsMap.get(sobjType).size() > 0) {
                for (String fieldToCheck : sObjectFieldsMap.get(sobjType)) {
                    if( sobjFieldDescribeMap.get(fieldToCheck) != null && 
                        !sobjFieldDescribeMap.get(fieldToCheck).getDescribe().isCreateable()) {
                            System.debug('!!! fieldToCheck: '+fieldToCheck);
                        isCreateable = false;
                    }
                }
            }
        }
        
        return isCreateable;
    }
    
    public Boolean isDeletable(Map<sObjectType, List<String>> sObjectFieldsMap) {
        Boolean isDeletable = true;

        for (sObjectType sobjType : sObjectFieldsMap.keySet()) {
            if (!sobjType.getDescribe().isDeletable()) {
                isDeletable = false;
                continue;
            }
        }
        
        return isDeletable;
    } 
    
    public Boolean isQueryable(Map<sObjectType, List<String>> sObjectFieldsMap) {
        Boolean isQueryable = true;

        for (sObjectType sobjType : sObjectFieldsMap.keySet()) {
            if (!sobjType.getDescribe().isQueryable()) {
                isQueryable = false;
                continue;
            }
        }
        
        return isQueryable;
    }
    
}