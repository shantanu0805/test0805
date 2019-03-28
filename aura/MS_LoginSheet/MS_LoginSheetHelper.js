({
	getRecentlyViewed : function(component) {

		console.log('>> Inside Helper > getRecentlyViewed');
		var action = component.get('c.getRecentlyViewed');

		action.setCallback( this, function(response) {
			var state = response.getState();
			if( component.isValid() && state === 'SUCCESS' ) {
				var respVal = response.getReturnValue();
				console.log('>> Data returned from Apex Controller : ' + respVal);
				component.set('v.recentCreds', respVal);
				component.set('v.showSpinner', false);
				console.log('v.recentCreds : ' + JSON.stringify(respVal));
			} else {
				console.log('Failed to load controller data ' + response.getError());
			}
		});
		$A.enqueueAction( action );
	},
    
    getAllClientCreds : function(component, event, helper) {
	   
		console.log('>> Inside Helper > getAllClientCreds');
		component.set('v.showSpinner', true);
		component.set('v.noCredsFound', false);
		component.set('v.displayClientDetails', false);
		var action = component.get('c.getAllClientCreds');

		action.setParams({
			accountId:    component.get('v.selectedClient')
		});

		action.setCallback( this, function(response) {
			var state = response.getState();
			if( component.isValid() && state === 'SUCCESS' ) {
				var respVal = response.getReturnValue();
				console.log('>> Data returned from Apex Controller : ' + respVal);
				if(respVal.length == 0){
					component.set('v.noCredsFound', true);
					component.set('v.displayResults', false);
					component.set('v.showSpinner', false);
				}
				else{
					component.set('v.noCredsFound', false);
					component.set('v.allClientCreds', respVal);
					component.set('v.selectedClientName', respVal[0].name);
					console.log('v.allClientCreds : ' + JSON.stringify(respVal));
					component.set('v.displayResults', true);
					component.set('v.showSpinner', false);
				}
			} else {
				console.log('Failed to load controller data ' + response.getError());
				component.set('v.showSpinner', false);
			}
		});
		$A.enqueueAction( action );
    },
    
    getClientDetails : function(component, event, helper) {
	   
		console.log('>> Inside Helper > getClientDetails');
		component.set('v.showSpinner', true);
		component.set('v.displayResults', false);
		//component.set('v.displayClientDetails', true);
		
		var action = component.get('c.getClientDetails');

		action.setParams({
			accountId:    component.get('v.selectedClient')
		});

		action.setCallback( this, function(response) {
			var state = response.getState();
			if( component.isValid() && state === 'SUCCESS' ) {
				var respVal = response.getReturnValue();
				console.log('>> Data returned from Apex Controller : ' + respVal);
				console.log('>> Client Details : ' + JSON.stringify(respVal));
				console.log('>> Name  : ' + respVal[0].name);
				console.log('>> Contacts  : ' + respVal[0].contacts);
				console.log('>> Contact Name  : ' + respVal[0].contacts[0].Name);
				component.set('v.clientDetails', respVal[0]);
				component.set('v.displayResults', false);
				component.set('v.displayClientDetails', true);
				component.set('v.showSpinner', false);
			} else {
				console.log('Failed to load controller data ' + response.getError());
				component.set('v.showSpinner', false);
			}
		});
		$A.enqueueAction( action );
		
    },

    updateLastViewed : function(component, event, helper) {
	   
		console.log('>> Inside Helper > updateLastViewed');
		component.set('v.showSpinner', true);		
		var currentTs = Date.now();
		console.log('>> currentTs : ' + currentTs);
		var action = component.get('c.updateLastViewed');

		action.setParams({
			"credentialId" :   component.get('v.selectedLogin')
		});

		action.setCallback( this, function(response) {
			var state = response.getState();
			if( component.isValid() && state === 'SUCCESS' ) {
				var respVal = response.getReturnValue();
				console.log('>> response : ' + respVal);
				component.set('v.showSpinner', false);
			} else {
				console.log('Failed to update timestamp ' + response.getError());
				component.set('v.showSpinner', false);
			}
		});
		$A.enqueueAction( action );
		
    }
    
})