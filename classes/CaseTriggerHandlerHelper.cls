public with sharing class CaseTriggerHandlerHelper {
	public CaseTriggerHandlerHelper() {
		
	}
	@future (callout=true)
	public static void SendNotification(Id caseId) {

	    HttpRequest req = new HttpRequest();
	    HttpResponse res = new HttpResponse();
	    Http http = new Http();

	    String jsonBody = GetRequestPayload(caseId);
	    System.debug('>> jsonBody : ' + jsonBody);
	    //req.setHeader('Accept', 'application/x-www-form-urlencoded');
	    req.setEndpoint('https://hooks.slack.com/services/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');
	    req.setMethod('POST');
	    jsonBody = EncodingUtil.urlEncode(jsonBody, 'UTF-8');
	    /*
	    System.debug('>> URLEncoded jsonBody : ' + jsonBody);
	    jsonBody = jsonBody.replace('%7C', '|');
	    jsonBody = jsonBody.replace('&#124;', '|');
	    String withPipe = jsonBody.replaceAll('&#124;', '|');
	    System.debug('>> With Pipe jsonBody : ' + jsonBody);
	    System.debug('>> With Pipe withPipe : ' + withPipe);
	    */
	    req.setBody('payload=' + jsonBody);
	    System.debug('>> req.getBody : ' + req.getBody());
	    try {
	        res = http.send(req);
	    } catch(System.CalloutException e) {
	        System.debug('Callout error: '+ e);
	        System.debug(res.toString());
	    }

	}

	private static String GetRequestPayload(Id caseId){

		Case newCase = [SELECT Id, Account.Name, Priority, Subject, Description, Contact.Name FROM Case WHERE Id = :caseId];
		System.debug('>> newCase : ' + newCase);
		SlackNotificationPayload obj = new SlackNotificationPayload();
		
		List<SlackNotificationPayload.cls_attachments> attachments = new List<SlackNotificationPayload.cls_attachments>();
		SlackNotificationPayload.cls_attachments attachment = new SlackNotificationPayload.cls_attachments();
		attachment.text = '_Case Details:_';
		List<String> formatings = new list<String> { 'pretext' , 'text' , 'fields'};
		attachment.mrkdwn_in = formatings;
		attachment.fallback = 'Priority : *' +  newCase.Priority + '* - <https://shantanu0805-dev-ed.my.salesforce.com/' +  newCase.Id + '|View Case>\n';
		attachment.fallback += 'Account : ' + newCase.Account.Name + '\n';
		attachment.fallback += 'Contact : ' + newCase.Contact.Name + '\n';
		attachment.pretext  = 'Priority : *' + newCase.Priority + '* - <https://shantanu0805-dev-ed.my.salesforce.com/' +  newCase.Id + '|View Case>\n';
		attachment.pretext += 'Account  : *' + newCase.Account.Name + '*\n';
		attachment.pretext += 'Contact  : *' + newCase.Contact.Name + '*\n';
		attachment.color = '#D00000';
		
		List<SlackNotificationPayload.cls_fields> fields = new List<SlackNotificationPayload.cls_fields>();
		SlackNotificationPayload.cls_fields field = new SlackNotificationPayload.cls_fields();
		field.title = newCase.Subject;
		field.value = newCase.Description;
		fields.add(field);
		attachment.fields = fields;
		attachments.add(attachment);
		obj.text = '*New Case Assignment Notification*';
		obj.mrkdwn = true;
		obj.attachments = attachments;
		System.debug('>> JSON Obj : ' + obj);
		String jsonBody = json.serialize(obj);
		//payload: {	"text" : "This is a line of text in a channel.\nAnd this is another line of text.", "icon_url": "https://slack.com/img/icons/app-57.png", "icon_emoji": ":ghost:", "attachments":[ { "fallback":"New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/500|Test out Slack message attachments>", "pretext":"New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/5001J00000TNT16|Test out Slack message attachments>", "color":"#D00000", "fields":[ { "title":"Notes", "value":"This is much easier than I thought it would be.", "short":false } ], "actions": [ { "name": "game", "text": "Thermonuclear War", "style": "danger", "type": "button", "value": "war", "confirm": { "title": "Are you sure?", "text": "Wouldn't you prefer a good game of chess?", "ok_text": "Yes", "dismiss_text": "No" } } ], } ] }
		//payload :{"text":"*** New Case Notification ***","attachments":[{"pretext":"New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/500&#124;Test out Slack message attachments","fields":[{"value":"Not able to login into Production. Please help. Thanks Tim.","title":"Subject"}],"fallback":"New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/500&#124;Test out Slack message attachments","color":"#D00000","actions":null}]}
		//return 'payload:' + jsonBody;
		return jsonBody;
	}
}