public class YourController {
    public string varA { get; set; } // use the proper type
    public String pName{get;set;}
    public String pn{get;set;}

    public YourController() {
        pn = String.valueOf(GetPageName()).toLowerCase();
        System.debug('Page Name '+ pn);
    }   
     private String GetSFPageName()
        {
                  String pageName = ApexPages.CurrentPage().getUrl();     // THIS IS THE CLOSEST YOU CAN GET SO FAR
                  
                  if(Test.isRunningTest())
                   {
                       pageName = 'abc/abc/abc' ;
                   }
                  System.debug('After extracting using /:' + pageName);
            
                    pageName = pageName.split('/')[2];          // IT ALWAYS STARTS WITH / SPLIT and EXTRACT IT
                    
                    pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');   // YOU WANT TO END AT THE QUESTION MARK BUT
                    
                    System.debug('After encoding /:' + pageName);
                    
                    
                      // YOU HAVE TO ENCODE IT FIRST
                      string[] pageNameExtra = pageName.split('%3F',0);   // %3F IS THE VALUE OF THE QUESTION MARK IN UTF-8           
                    
                      // SO YOU MAY SPLIT THE STRING AT THAT POINT
                      pageName = pageNameExtra[0]; 
                                               // FOR THIS PURPOSE YOU ONLY NEED THE FIRST
                    
                    System.debug('Final page name:' + pageName);                
                    
                    return pageName;
            }
            public string GetPageName()  {
                
                String pageName = ApexPages.currentPage().getParameters().get('name');
                
                if (pageName == '' || pageName == null )
                           pageName = GetSFPageName();
                  
                          
                return pageName;
             }
             
              
}