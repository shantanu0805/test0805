global class QuoteBatchJobScheduler implements Schedulable
{    
 public String query;
 public static String childName{get;set;}
 public static String childValue{get;set;}
 public List<String> properties {get; set;}
 public List<String> values {get; set;}
 
    global void execute(SchedulableContext sc)
    {
        String q = 'SELECT Name,StockName__c,Value__c FROM Stock__c';
        
         try {                  
                StockQuoteWS.StockQuoteSoap proxyClass = new StockQuoteWS.StockQuoteSoap();
                String retVal = proxyClass.GetQuote('acn');
                 //  XML Parsing
                System.debug(' :::::::::: Inside XML Parsing :::::::::: ');
                Dom.Document doc = new Dom.Document();
                doc.load(retVal);

                //Retrieve the root element for this document.
                Dom.XMLNode rootElement= doc.getRootElement();
                System.debug('Root Element >>>>>  ' + rootElement);
                
                String stock = rootElement.getChildElement('Stock', null).getName();
                //String symbol = rootElement.getChildElement('Symbol', null).getText();
                // print out specific elements
                System.debug('Stock : ' + stock );
               // System.debug('Symbol : ' + symbol );
                Dom.XMLNode childElements = rootElement.getChildElement('Stock', null);
                // Alternatively, loop through the child elements.
                // This prints out all the elements of the address
                for(Dom.XMLNode child : childElements.getChildElements()) {
               System.debug('Child Elements of Root :::: '+child.getName() +' :: ' + child.getText());
               childName = child.getName();
               properties.add(childName);
               System.debug('childName  : ' + childName);
               childValue = child.getText();
               values.add(childValue);
               Stock__c auth = new Stock__c(Name = childName, Value__c = childValue, StockName__c = 'a0Ho0000006aTRWEA2' );
               insert auth;
                }
                //  ** End of XML Parsing                                                                                                                                                       
           
          // now do what u want to with response.               
          }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
          }
          
        BatchToUpdateStock batchable = new BatchToUpdateStock(q,properties,values);
        database.executebatch(batchable);
    }
}