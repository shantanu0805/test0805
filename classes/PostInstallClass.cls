global class PostInstallClass implements InstallHandler {

  global void onInstall(InstallContext context) {

    if(context.previousVersion() == null) {
        
        System.debug('>> Inside PostInstallClass > onInstall ');
        PostInstalLoadController obj = new PostInstalLoadController();
        obj.loadData();
    }
    /*
    else
        if(context.previousVersion().compareTo(new Version(1,0)) == 0) {
        Survey__c obj = new Survey__c(name='Upgrading from Version 1.0');
        insert(obj);
    }

    if(context.isUpgrade()) {
        Survey__c obj = new Survey__c(name='Sample Survey during Upgrade');
        insert obj;
    } 

    if(context.isPush()) {
        Survey__c obj = new Survey__c(name='Sample Survey during Push');
        insert obj;
    }
    */
    }
  }