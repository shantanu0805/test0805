public with sharing class RemotingWithWrapperClass
{
    public List<String> properties {get; set;}
    public List<String> values = new List<String> {};
     public RemotingWithWrapperClass(){
        // Default Constructor
    }
    public RemotingWithWrapperClass(List<String> properties, List<String> values){
            this.properties = properties;
            values = values;
            System.debug('all properties Main Class : ' + properties);
            System.debug('all values  Main Class : ' + values);
    }

       @RemoteAction
       public static WrapperClass getQuote(String quote) {
        List<String> properties = new List<String> {};
        List<String> values = new List<String> {};
        String childName;
        String childValue;
        String stockName;
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
               insert auth;  
            }
            //  ** End of XML Parsing
            System.debug('all properties  : ' + properties);
            System.debug('all values  : ' + values);

        return new WrapperClass(childName, childValue, properties, values);
     }
    public class WrapperClass
    {
        public String childName{get;set;}
        public String childValue{get;set;}
        List<String> properties = new List<String> {};
        List<String> values = new List<String> {};
        public WrapperClass(String Name, String Value,List<String> properties, List<String> values)
        {
            childName = Name;
            childValue = Value;
            properties = properties;
            values = values;
            
            RemotingWithWrapperClass obj = new RemotingWithWrapperClass(properties, values);
        }
    }
}