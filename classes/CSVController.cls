public class CSVController 
{
    
    public static List<Map<String, String>> readCSV(String fileName){
        
            List<Map<String, String>> records = new List<Map<String, String>>();
            Document csvDoc = [SELECT Body,FolderId,Name FROM Document  WHERE Folder.Name='MPLoadData' and Name=:fileName];
            
            //Convert the uploaded file which is in BLOB format into a string
            String csvStr =  blobToString( csvDoc.Body,'ISO-8859-1');
            
            //Now sepatate every row of the excel file
            List<String> filelines = csvStr.split('\n');
            
            //Get field Type Map
            Map<String, String> fieldTypeMap = getFieldTypeMap(fileName);
            
            List<String> header = filelines[0].split(',');
            
            for (Integer i=1;i<filelines.size();i++){
                List<String> row = filelines[i].split(',');
                Map<String, String> rowMap = new Map<String, String>();
                for (Integer j=0; j<row.size(); j++){
                    rowMap.put(header[j].toLowerCase().trim(), row[j]);
                }
                records.add(rowMap);
            }
        
        return records;
    }
    public static List<SObject> createSObject(String objName, List<Map<String, String>> recMap){
        
            List<SObject> records = new List<SObject>();
            //Get field Type Map
            Map<String, String> fieldTypeMap = getFieldTypeMap(objName);
            
            //System.debug('\n\nFIELDMAP: ' + fieldTypeMap);
            
            for (Map<String, String> mp: recMap){
                SObject sObj = Schema.getGlobalDescribe().get(objName).newSObject();
                
                for(String fieldName: mp.keySet()){
                    String fieldValueStr = mp.get(fieldName);
                    //System.debug('\n\nfieldName: ' + fieldName + ' == ' + fieldValueStr + ' == ' + fieldTypeMap.containsKey(fieldName));
                    if(fieldTypeMap.containsKey(fieldName)){
                        if(fieldTypeMap.get(fieldName).toLowerCase()=='boolean'){
                            Boolean b = fieldValueStr.toLowerCase()=='true'?true:false;
                            sObj.put(fieldName, b);
                        }
                        else if(fieldTypeMap.get(fieldName).toLowerCase()=='date'){
                            sObj.put(fieldName, Date.parse(fieldValueStr));
                        }
                        else if(fieldTypeMap.get(fieldName).toLowerCase()=='datetime'){
                            sObj.put(fieldName, DateTime.parse(fieldValueStr));
                        }
                        else if(fieldTypeMap.get(fieldName).toLowerCase()=='double' && fieldValueStr!=null && fieldValueStr.trim()!=''){
                            sObj.put(fieldName, Double.valueOf(fieldValueStr));
                        }
                        else if(fieldTypeMap.get(fieldName).toLowerCase()=='integer' && fieldValueStr!=null && fieldValueStr.trim()!=''){
                            sObj.put(fieldName, Integer.valueOf(fieldValueStr));
                        }
                        else if(fieldValueStr!=null && fieldValueStr.trim()!=''){
                            sObj.put(fieldName, fieldValueStr);
                        }
                    }
                }
                //System.debug('\n\nREC: ' + sObj);
                records.add(sObj);
            }
        
        return records;
    }
    
    public static Map<String, String> getFieldTypeMap(String objName){
        
        Map<String, String> fieldTypeMap = new Map<String, String>();
        
        Map<String, Schema.SObjectField> fieldMap =  Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        for(String key : fieldMap.keySet()){
            Schema.DescribeFieldResult fieldResult = fieldMap.get(key).getDescribe();
            if(fieldResult.isCreateable()){
                fieldTypeMap.put(key, String.valueOf(fieldResult.getSOAPType()));
            }
        }
        
        return fieldTypeMap;
    }
    
   
        /**
         This function convers the input CSV file in BLOB format into a string
        @param input    Blob data representing correct string in @inCharset encoding
        @param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
     */
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }         
}