({

    initLookupInput : function(component) {
      var fields  = component.get('v.optionalWhere');
      var values  = component.get('v.optionalWhereValues');
      var include = component.get('v.includeFields');

      if (typeof values === 'string') {
        values = JSON.parse(values);
        // Make sure array will be empty on the start
        if (values.length === 1 && values[0] === '') {
          values = [];
        }
      }

      // There's no optional conditions for lookup field
      if (fields.length === 0 && values.length === 0) {
          this.getListForSObject(component);
      } else if (fields.length > 0 && values.length > 0) {
          // Build where string - only if there's enough data in optionalWhereValues
          if (fields.length === values.length) {
              var whereQuery = "";
              var wheres = [];

              if ($A.util.isArray(include)) {
                if (include.length === 0) {
                  for (var i = 0; i < fields.length; i++) {  
                    include[i] = true;
                  }
                } else {
                  for (var i = 0; i < include.length; i++) {  
                    include[i] = JSON.parse(include[i]);
                  }               
                }
              } else {
                include = JSON.parse(include);
              }

              for (var i = 0; i < fields.length; i++) {
                if (include[i]) {
                  if (values[i] === 'true' || values[i] === 'false') {
                    wheres.push(fields[i] + " = " + values[i]);
                  } else {
                    var vals = values[i].split(',');
                    if (vals.length > 1) {
                      wheres.push(fields[i] + " IN (" + values[i] + ")");
                    } else {
                      wheres.push(fields[i] + " = '" + values[i] + "'");
                    }
                  }
                }
              }
              whereQuery = ' WHERE ' + wheres.join(' AND ');
              component.set('v.optionalWhereQuery', whereQuery);
              this.getListForSObject(component);
          }
        } else {
          // Input won't do anything, so hide loader
          component.set('v.lookupLoading', false);
        }
    },

    resetLookupInput : function(component) {
      // Set all values to default values
      component.set('v.records', []);
      component.set('v.items', []);
      component.set('v.labelValue', null);
      component.set('v.selectedValue', null);
    },

    searchAction : function(component, inputValue) {
        var items  = component.get('v.records');
        var labels = component.get('v.labelFields');
        var glue   = component.get('v.glue');

        var _term = inputValue;
        var _terms = _term.split(' ');
        var patterns = [];
        for (var i = 0, j = _terms.length; i < j; i++) {
          var term = _terms[i];
          if (term !== '' && term !== ' ') {
            term = term.replace(/(\s+)/,"(<[^>]+>)*$1(<[^>]+>)*");
            term = term.replace(/[\\^$*+?.()|[\]{}]/g, '\\$&');
            if (term !== '') {
                patterns.push(new RegExp("("+term+"(?![^<]*>))", "gi"));
            }
          }
        }
    
        var _items = [];
        for (var i = 0, j = items.length; i < j; i++) {
            var matchingPatterns = 0;
            // Save it as a new string, not the reference
            items[i]._combinedLabel = '' + items[i]._originalLabel + '';
            for (var k = 0, l = patterns.length; k < l; k++) {
                if (patterns[k].test(items[i]._inputLabel)) {
                    items[i]._combinedLabel = items[i]._combinedLabel.replace(patterns[k], "<span>$1</span>");
                    matchingPatterns++
                }
            }
            if (matchingPatterns > 0 && matchingPatterns === patterns.length) {
                items[i].matchingPatterns = matchingPatterns;
                _items.push(items[i]);
            }
        }

        if (_items.length > 0) {
            //_items.sort(function(a,b) {return (a['matchingPatterns'] < b['matchingPatterns']) ? 1 : ((b['matchingPatterns'] < a['matchingPatterns']) ? -1 : 0);} );
        }        
        
        component.set('v.items', _items);
        component.set('v.resultsOpen', true);
    },

    getListForSObject : function(component) {
        var action = component.get('c.getListForSObject');

        action.setParams({
            sobjectType:    component.get('v.className'),
            optionalWhere:  component.get('v.optionalWhereQuery'),
            filterByUser:   component.get('v.filterByUser')
        });

        action.setCallback( this, function(response) {
            var state = response.getState();
            if( component.isValid() && state === 'SUCCESS' ) {
                var respVal = response.getReturnValue();
                if (respVal !== '') {
                  component.set('v.records', JSON.parse(respVal));
                  this.prepareObjects(component);
                  if (component.get('v.selectedValue') !== '') {
                    this.searchForSelectedItem(component);
                  }
                } else {
                  console.log('%c Response from APEX Controller for Lookup input was empty ', 'background: black; color: orange;');
                }
                component.set('v.lookupLoading', false);
            } else {
                console.log('Failed to load controller data ' + response.getError());
            }
        });
        $A.enqueueAction( action );
    },

    prepareObjects : function(component) {
      var records = component.get('v.records');
      for (var i = 0, j = records.length; i < j; i++) {
        Object.defineProperties(records[i], {
          inputLabel: {
            __proto__: null,
            enumerable: false,
            configurable: false,
            value: null,
            writable: true
          },
          _inputLabel: {
            get: function() { return this.inputLabel; },
            set: function(value) { this.inputLabel = value },
            configurable: true,
            enumerable: true
          },
          combinedLabel: {
            __proto__: null,
            enumerable: false,
            configurable: false,
            value: null,
            writable: true
          },
          _combinedLabel: {
            get: function() { return this.combinedLabel; },
            set: function(value) { this.combinedLabel = value; },            
            configurable: true,
            enumerable: true
          },
          originalLabel: {
            __proto__: null,
            enumerable: false,
            configurable: false,
            value: null,
            writable: true
          },
          _originalLabel: {
            get: function() { return this.originalLabel; },
            set: function(value) { this.originalLabel = value; },            
            configurable: true,
            enumerable: true
          }          
        });
      }      
      /* Current solution - will remove all setters and getters and change object type */
      records = JSON.parse(JSON.stringify(records));

      var labels = component.get('v.labelFields');
      var glue   = component.get('v.glue');

      for (var i = 0, j = records.length; i < j; i++) {
        records[i]._combinedLabel = [];
        if (labels.length > 1) {
          for (var m = 0, n = labels.length; m < n; m++) {
              records[i]._combinedLabel.push(records[i][labels[m]]);
          }
          var _label = records[i]._combinedLabel.join(glue);
          records[i]._inputLabel = 
          records[i]._originalLabel = _label;
          records[i]._combinedLabel = _label;
        } else {
          var _label = JSON.parse(JSON.stringify(records[i][labels[0]]));
          records[i]._inputLabel = _label;
          records[i]._originalLabel = _label;
          records[i]._combinedLabel = _label;
        }
      }

      component.set('v.records', records);
    },

    fireEvent : function(component, selectedValue, selectedLabel, keepValues) {
      if (component.get('v.fireEvent')) {
        var compEvent = $A.get('e.slacknotify:LookupInputEvt');
        compEvent.setParams({
            'lookupName'    : component.get('v.lookupName'),
            'selectedValue' : selectedValue,
            'selectedLabel' : selectedLabel,
            'keepValues'    : keepValues
        });
        compEvent.fire();
      }
    },

    searchForSelectedItem : function(component) {
      var field   = component.get('v.fieldToSelect');
      var records = component.get('v.records');
      var value   = component.get('v.selectedValue');
      var labels  = component.get('v.labelFields');
      var glue    = component.get('v.glue');

      for (var i = 0, j = records.length; i < j; i++) {
        if (records[i][field] === value) {
          component.set('v.value', records[i][field]);
          if (labels.length > 1) {
            var label = [];
            for (var m = 0, n = labels.length; m < n; m++) {
              label.push(records[i][labels[m]]);
            }
            component.set('v.labelValue', label.join(glue));
            this.fireEvent(component, value, label.join(glue), true);
          } else {
            component.set('v.labelValue', records[i][labels[0]]);
            this.fireEvent(component, value, records[i][labels[0]], true);            
          }
          break;
        }
      }
    },

    closeResults : function(component, value) {
      var helper = this;
      var timeout = setTimeout(
        $A.getCallback(function() {
            if (component.isValid() && !component.get('v.keepList')) {
                component.set('v.resultsOpen', false);
                // User cleared out the input, should clean up selected value
                if (value === '' && component.get('v.selectedValue') !== '') {
                    component.set('v.selectedValue', '');
                    component.set('v.value', '');
                    helper.fireEvent(component, '', '');
                // User blurred input after changing value, but without selecting one
                // Lets reset input to latest selected value              
                } else if (value !== component.get('v.labelValue')) {
                    var current = component.get('v.labelValue');
                    var input   = component.find('input');
                    input.getElement().value = current;
                }
            }
        }), 2000);      
      component.set('v.timeout', timeout);
    }
})