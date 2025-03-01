({
    fetchPickListVal : function(component, fieldName, elementId) {
        debugger;
        var action = component.get("c.getPicklitValueFromSobject");
        action.setParams({
            "objObject" : component.get("v.objInfo"),
            "fld" : fieldName
        });
        var optValues = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            var allPickValues = response.getReturnValue();
            if(allPickValues != undefined && allPickValues.length > 0){
                optValues.push({
                    class: "optionClass",
                    label: "--None--",
                    value: ""
                });
                for(var i=0; i < allPickValues.length;i++){
                    optValues.push({
                        class: "optionClass",
                        label: allPickValues[i],
                        value: allPickValues[i]
                    });
                }
                component.find(elementId).set("v.options", optValues);
            }
            
        });
        $A.enqueueAction(action);
    },
})