public class SlackNotificationPayload{
	public String text;	//This is a line of text in a channel.
	public Boolean mrkdwn; //true
	//public String icon_url;	//https://slack.com/img/icons/app-57.png
	//public String icon_emoji;	//:ghost:
	public cls_attachments[] attachments;
	public class cls_attachments {
		public String fallback;	//New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/500|Test out Slack message attachments>
		public String pretext;	//New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/5001J00000TNT16|Test out Slack message attachments>
		public String color;	//#D00000
		public List<String> mrkdwn_in; //["text", "pretext"]
		public String text; //Case Details
		public cls_fields[] fields;
		public cls_actions[] actions;
	}
	public class cls_fields {
		public String title;	//Notes
		public String value;	//This is much easier than I thought it would be.
		//public String short;	//false
	}
	public class cls_actions {
		public String name;	//game
		public String text;	//Thermonuclear War
		public String style;	//danger
		public String type;	//button
		public String value;	//war
		public cls_confirm confirm;
	}
	public class cls_confirm {
		public String title;	//Are you sure?
		public String text;	//Wouldn't you prefer a good game of chess?
		public String ok_text;	//Yes
		public String dismiss_text;	//No
	}
	public static SlackNotificationPayload parse(String json){
		return (SlackNotificationPayload) System.JSON.deserialize(json, SlackNotificationPayload.class);
	}
	/*
	static testMethod void testParse() {
		String json=		'{	'+
		'   "text" : "This is a line of text in a channel.\nAnd this is another line of text.",'+
		'	"icon_url": "https://slack.com/img/icons/app-57.png",'+
		'	"icon_emoji": ":ghost:",'+
		'	"attachments":['+
		'      {'+
		'         "fallback":"New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/500|Test out Slack message attachments>",'+
		'         "pretext":"New open task [Urgent]: <https://shantanu0805-dev-ed.my.salesforce.com/5001J00000TNT16|Test out Slack message attachments>",'+
		'         "color":"#D00000",'+
		'         "fields":['+
		'            {'+
		'               "title":"Notes",'+
		'               "value":"This is much easier than I thought it would be.",'+
		'               "short":"false"'+
		'            }'+
		'         ],'+
		'          "actions": ['+
		'            {'+
		'                    "name": "game",'+
		'                    "text": "Thermonuclear War",'+
		'                    "style": "danger",'+
		'                    "type": "button",'+
		'                    "value": "war",'+
		'                    "confirm": {'+
		'                        "title": "Are you sure?",'+
		'                        "text": "Wouldn't you prefer a good game of chess?",'+
		'                        "ok_text": "Yes",'+
		'                        "dismiss_text": "No"'+
		'                    }'+
		'                }'+
		'         ],'+
		'      }'+
		'   ]'+
		'}';
		SlackNotificationPayload obj = parse(json);
		System.assert(obj != null);
	}
	*/
}