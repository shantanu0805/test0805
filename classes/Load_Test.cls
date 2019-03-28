@isTest
private class Load_Test {

    @isTest(seeAllData=true)
    static void doTest(){
      PostInstalLoadController obj = new PostInstalLoadController();
      obj.loadData();
    }

}