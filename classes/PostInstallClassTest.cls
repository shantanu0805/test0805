@isTest
private class PostInstallClassTest {

    @isTest(seeAllData=true)
    static void testInstallScript() {
    PostInstallClass postinstall = new PostInstallClass();
    Test.testInstall(postinstall, null);
  }

}