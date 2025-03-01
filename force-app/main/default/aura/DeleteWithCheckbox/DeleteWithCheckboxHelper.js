({
    onLoad: function(component, event) {
        debugger;
        console.log('onLoad call');
        
        var action = component.get('c.fetchContact');
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set('v.ListOfContact', response.getReturnValue());
                // set deafult count and select all checkbox value to false on load 
                component.set("v.selectedCount", 0);
                component.find("box3").set("v.value", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteSelectedHelper: function(component, event, deleteRecordsIds) {
        debugger;
        var action = component.get('c.deleteRecords');
        action.setParams({
            "lstRecordId": deleteRecordsIds
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == null || response.getReturnValue() == 0){
                    alert("SELECT RECORD")
                }else{
                    alert("SUCCESS")
                }
                
                // call the onLoad function for refresh the List view    
                this.onLoad(component, event);
            }
        });
        $A.enqueueAction(action);
    },
})