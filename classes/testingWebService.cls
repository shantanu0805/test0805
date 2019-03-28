global class testingWebService{

      @RemoteAction
      global static freeWebServicesComSoap.addResponse_element getResult(Integer a, Integer b) {
      
      Datetime cDT = System.now();
      freeWebServicesComSoap.addSoap obj = new freeWebServicesComSoap.addSoap();
      freeWebServicesComSoap.addResponse_element  obj1 = obj.add(a,b);
 
      System.debug('webservice response: ' + obj1);
      System.debug('webservice response time : ' + obj1.time_x);
      return obj1;
      }

}