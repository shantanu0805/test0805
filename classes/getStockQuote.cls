public class getStockQuote{

public static String response{get;set;}
public static String childName{get;set;}
public static String childValue{get;set;}

public getStockQuote(){
    childName = 'abc';
}

  @RemoteAction
  public static String getQuote(String quote) {
  
    StockQuoteWS.StockQuoteSoap proxyClass = new StockQuoteWS.StockQuoteSoap();
    String retVal = proxyClass.GetQuote(quote);
    System.debug(retVal);
    response = retVal; 
    
     //  XML Parsing
        System.debug(' :::::::::: Inside XML Parsing :::::::::: ');
        Dom.Document doc = new Dom.Document();
        doc.load(response);

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
           System.debug('childName  : ' + childName);
           childValue = child.getText();
        }
        //  ** End of XML Parsing
        
    return retVal;
 }
}