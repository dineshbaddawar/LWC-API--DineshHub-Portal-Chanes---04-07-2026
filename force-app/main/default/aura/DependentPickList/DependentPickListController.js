({
    doInit : function(component, event, helper) {
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldApI = component.get("v.dependingFieldAPI");
        var objDetail = component.get("v.objDetail"); 
        helper.fetchPicklistValues(component, objDetail, controllingFieldAPI, dependingFieldApI);
    },
    
    onControllerFieldChange : function(component, event, helper){
        var controllerValueKey = event.getSource().get("v.value");
        var dependentFieldMap = component.get("v.depnedentFieldMap");
        if(controllerValueKey != '-- None --'){
            var ListDependentFields = dependentFieldMap[controllerValueKey];
            if(ListDependentFields.length > 0){
                component.set("v.DisabledDependentFld", false);
                helper.fetchDepValues(component, ListDependentFields);
            }else{
                component.set("v.DisabledDependentFld", true);
                component.set("v.listDependingValues", ['-- None --']);
            }
        } else{
            component.set("V.listDependingValues", ['-- None --']);
            component.set("v.DisabledDependentFld", true);
        }
    }
})