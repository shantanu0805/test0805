public class DomDocument {
 
    // Pass in the URL for the request
    // For the purposes of this sample,assume that the URL
    // returns the XML shown above in the response body
    public void parseResponseDom(String passed){
        System.debug('Passed String: ' + passed);
    /*    
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        // url that returns the XML in the response body
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
    */  
      Dom.Document doc = new Dom.Document();
        doc.load(passed);

        //Retrieve the root element for this document.
        Dom.XMLNode rootElement= doc.getRootElement();
        
        String symbol = rootElement.getChildElement('Symbol', null).getText();
        String last = rootElement.getChildElement('Last', null).getText();
        // print out specific elements
        System.debug('Symbol: ' + symbol);
        System.debug('Last : ' + last );
        
        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address
        for(Dom.XMLNode child : rootElement.getChildElements()) {
           System.debug(child.getText());
        }
    }
}