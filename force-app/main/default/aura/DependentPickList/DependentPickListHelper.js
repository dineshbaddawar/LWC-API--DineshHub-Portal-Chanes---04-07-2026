({
    fetchPicklistValues : function(component,objDetails,controllerField, dependentField) {
        var action = component.get("c.getDependentMap");
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
       action.setCallback(this, function(response){
        debugger;
        var State = response.getState();
        if(response.getState() == 'SUCCESS'){
            var StoreResponse = response.getReturnValue();
            component.set("v.depnedentFieldMap", StoreResponse);
            var listOfkeys = [];
            var controllerField = [];

            for(var stringKey in StoreResponse){
                listOfkeys.push(stringKey);
            }
            if(listOfkeys !=undefined && listOfkeys.length > 0){
                controllerField.push('-- None --');
            }
            for(var i=0; i < listOfkeys.length; i++){
                controllerField.push(listOfkeys[i]);
            }
            component.set("v.listControllingValues", controllerField);
        }else{
            alert("Something Went Wrong......!")
        }
       });
       $A.enqueueAction(action);
    },

    fetchDepValues : function(component, ListDependentFields){
     var dependentField = [];
     dependentField.push('-- None --');
     for(var i = 0; i < ListDependentFields.length; i++){
        dependentField.push(ListDependentFields[i]);
     }
     component.set("v.listDependingValues", dependentField);
    },

})