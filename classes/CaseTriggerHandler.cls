public with sharing class CaseTriggerHandler {
	public CaseTriggerHandler() {
		
	}

	public void HandleAfterInsert(List<Case> newCaseList, List<Case> oldCaseList){
		System.debug('>> newCaseList : ' + newCaseList);
		System.debug('>> oldCaseList : ' + oldCaseList);

		for(Case newCase : newCaseList){
			CaseTriggerHandlerHelper.sendNotification(newCase.Id);
		}
	}
}