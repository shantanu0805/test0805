({

    doInit : function(component, event, helper) {
        // Assing HTML ID for label and input, so they're gonna be linked together
        var d = new Date();
        var id = d.getTime() + Math.floor((Math.random() * 10) + 1);
        component.set('v.inputId', 'input_' + id);
        component.set('v.resultsHolderId', 'resultsHolder_' + id);
        // Init component - load data if possible
        helper.initLookupInput(component);
    },

    onKeyUp : function(component, event, helper) {
        var inputValue = event.target.value;
        var requiredCharacters = component.get('v.lookupStart');
        var keyTimeout = component.get('v.keyTimeout');
        clearTimeout(keyTimeout);
        keyTimeout = setTimeout($A.getCallback(function(){
            if (component.isValid()) {
                component.set('v.lookupLoading', true);
                setTimeout($A.getCallback(function(){
                    if (component.isValid()) {
                        if (inputValue.length >= requiredCharacters) {
                            helper.searchAction(component, inputValue);
                        } else {
                            component.set('v.items', []);
                            component.set('v.resultsOpen', false);
                        }
                        component.set('v.lookupLoading', false);                
                    }
                }), 50);
            }
        }), 500);
        component.set('v.keyTimeout', keyTimeout);
    },

    onBlur : function(component, event, helper) {
        helper.closeResults(component, event.target.value);
    },

    selectItem : function(component, event, helper) {
        var index   = event.currentTarget.getAttribute('data-item');
        var items   = component.get('v.items');
        var input   = component.find('input');
        var field   = component.get('v.fieldToSelect');
        var item    = items[index];
        component.set('v.labelValue', item._inputLabel);
        component.set('v.selectedValue', item[field]);
        component.set('v.value', item[field]);
        component.set('v.resultsOpen', false);

        // Fire event, there might be some inputs
        // which are waiting for this input to change
        helper.fireEvent(component, item[field], item._inputLabel);
    },

    handleInputLookupEvt : function(component, event, helper) {
        if (component.get('v.listenToEvent')) {
            var _params = event.getParams();
            // Check if this is input which we're listening for
            if (_params.lookupName === component.get('v.listenToLookup') && !_params.keepValues) {
                // Show spinner
                component.set('v.lookupLoading', true);
                // Reset selected values to default
                helper.resetLookupInput(component);
                // Init component again
                helper.initLookupInput(component);
                // Send reset event
                helper.fireEvent(component, '', ''); 
            }
        }
    },

    onErrorChange : function(component, event, helper) {
        // var field = component.find('input');
        // field.set('v.errors', component.get('v.errors'));
    },

    onDataChange : function(component, event, helper) {
        if (component.get('v.selectedValue') === '') {
            component.set('v.labelValue', null);
            // If lookup field is listening for other component - it should be cleared out
            if (component.get('v.listenToLookup') !== '') {
                helper.resetLookupInput(component);
            }
        }
    },

    onKeepList : function(component, event, helper) {
        component.set('v.keepList', true);
    },

    offKeepList : function(component, event, helper) {
        var canClose = true;

        if (document.activeElement) {
            if (document.activeElement.id === component.get('v.inputId')) {
                canClose = false;
            }
        }

        if (component.get('v.keepList') && canClose) {
            component.set('v.keepList', false);
            var input = component.find('input').getElement();
            helper.closeResults(component, input.value);
        }
    },

    clearTimeout : function(component) {
        var timeout = component.get('v.timeout');
        if (timeout) {
            clearTimeout(timeout);
        }
    }

})