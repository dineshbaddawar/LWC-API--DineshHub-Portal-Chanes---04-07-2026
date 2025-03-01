({
//To perform delete action.
    deltingCheckboxAccounts : function(component, event, deltIds) {
        debugger;
    //Calling apex method.
        var action = component.get('c.DeleteRecord');
        //passing the all selected record's Id's to apex method.
        action.setParams({
            "DeleteIds": deltIds
        });
       //Getting response.
        action.setCallback(this, function(response) {
            var state = response.getState();
            //If state is sucess then refreshing the View.
            if (state === "SUCCESS") {
                console.log('Inside delete'+state);
                component.set("v.selectedLeads", null);
                //Refresh the View.
                this.showSuccessToast(component,event)
                $A.get('e.force:refreshView').fire();
                  component.set('v.showDeleteBox', false);     
            }
        });
         
        $A.enqueueAction(action);
    },
    showSuccessToast: function(component,event){
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Record Deleted  Successfully !',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();    
    }
})