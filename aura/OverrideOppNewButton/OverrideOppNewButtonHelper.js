({
	createRecord : function (component) {
        console.log('>> Inside Helper method createRecord');
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Opportunity"
            /*,'defaultFieldValues': {
                'CloseDate': {!(Today() + 30)}
            }*/
        });
        createRecordEvent.fire();
    }
})