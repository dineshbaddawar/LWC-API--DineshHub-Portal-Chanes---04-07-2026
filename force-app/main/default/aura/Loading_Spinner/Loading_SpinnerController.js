({
    retriveContactList : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', editable:'true', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', editable:'true', type: 'phone'},
            {label: 'Email', fieldName: 'Email', editable:'true', type: 'email'}
        ]);
        debugger;
        helper.showSpinner(component);
        var action = component.get("c.conListDatFromApex");
        var accId = component.get("v.recordId");
        action.setParams({
            "accId":accId
        })
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State != "ERROR"){
                component.set("v.conListData", response.getReturnValue());
                helper.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    }
})