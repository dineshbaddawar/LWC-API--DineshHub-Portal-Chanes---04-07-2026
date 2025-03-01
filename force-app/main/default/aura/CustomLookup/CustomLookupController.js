({
    searchField : function(component, event, helper) {
        debugger;
      //  alert("searchField Method Called")
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find("resultBox");
        component.set("v.LoadingText", true);
        if(currentText.length > 0){
            $A.util.addClass(resultBox, 'slds-is-open');
        }else{
            $A.util.removeClass(resultBox, 'slds-is-open')
        }
        
        var action = component.get("c.getResults");
        action.setParams({
            "ObjectName": component.get("v.objectName"),
            "fieldName" : component.get("v.fieldName"),
            "value" : currentText
        });
        
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.searchRecords",result);
                if(component.get("v.searchRecords").length == 0) {
                    console.log("Record Not Found")
                }
            } else if( State === 'ERROR'){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: "+errors[0].message);
                    }
                } else{
                    console.log("Unknown Error");
                }
            }
            component.set("v.LoadingText", false);
        });
        $A.enqueueAction(action);
    },
    
    setSelectedRecord : function(component, event, helper) {
        debugger;
      //  alert("setSelectedRecord Method Called")
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
        component.set("v.selectedRecordName", event.currentTarget.dataset.name);
        component.set("v.selectedRecordId", currentText);
        component.find("userinput").set("v.readonly", true);
    },
    
    resetData : function(component, event, helper) {
        debugger;
      //  alert("resetData Method Called")
        component.set("v.selectedRecordName",'');
        component.set("v.selectedRecordId","");
        component.find("userinput").set("v.readonly",false);
    },
    
})