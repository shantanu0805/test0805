public with sharing class GetQuoteCallWebService
{
    public List<String> properties {get; set;}
    public List<String> values {get; set;} 
    public String childName {get; set;}
    public String childValue {get; set;}
    public String stockName {get; set;}
    
    public GetQuoteCallWebService(){
        // Default Constructor
    }
    public GetQuoteCallWebService(List<String> prop, List<String> val){
            this.properties = prop;
            this.values = val;
            System.debug('all properties inside constructor : ' + properties);
            System.debug('all values inside constructor : ' + values);
    }

       public GetQuoteCallWebService getQuote(String quote) {

        // Calling the WebService
        StockQuoteWS.StockQuoteSoap proxyClass = new StockQuoteWS.StockQuoteSoap();
        // Catching the WebService Response
        String retVal = proxyClass.GetQuote(quote);
        System.debug(retVal);
         
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
               if(quote== 'acn'){
               stockName = 'a0Ho0000006aTRW';
               }
               else{
               stockName = 'a0Ho0000006aTXk';
               }
               values.add(childValue);
               Stock__c auth = new Stock__c(Name = childName, Value__c = childValue, StockName__c = stockName );
               System.debug('Record to be inserted : ' + auth );
              // insert auth;  
            }
            //  ** End of XML Parsing
            System.debug('all properties @ end of method : ' + properties);
            System.debug('all values @ end of method: ' + values);

        return new GetQuoteCallWebService(properties, values);
     }
    
}