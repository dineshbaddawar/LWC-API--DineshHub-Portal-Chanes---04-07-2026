({
    GetAccountNameGroup : function(component, event) {
        debugger;
        var action = component.get("c.QueryAccountName");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var result = response.getReturnValue();
                var AssignAccGroupMap = [];
                for(var key in result.AssignAccountMap){
                    AssignAccGroupMap.push({
                        key : key,
                        value : result.AssignAccountMap[key].Name
                    });
                }
                component.set("v.AssignAccGroupList",AssignAccGroupMap);
                component.set("v.AllContactListView", result.AllContactlistView);
            }else{
                alert("ERROR")
            }
        });
        $A.enqueueAction(action);
    },
    showWarning : function(component, event) {
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Please select a Record !',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },	
    
})