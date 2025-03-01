({
    //function to show the leads records.
    init : function(component, event, helper) {
        //Data-table columns.
        component.set('v.columns', [
            {label: 'Lead name', fieldName: 'Name', type: 'text'},
            {label: 'Company', fieldName: 'Company', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'Phone'},
            {label: 'Email', fieldName: 'Email', type: 'Email'},
            {label: 'Status', fieldName: 'Status', type: 'Picklist'}
             
        ]);
        //Calling apex method to featch the lead details.
        debugger;
        var action = component.get('c.featchLeadData');
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var leadData = response.getReturnValue();
                //Storing the reponse from server side to an attribute.
                component.set('v.data', response.getReturnValue());               
            }
        });
        $A.enqueueAction(action);
    },
    //Function to fetch recordIds of each row and to show the count.
    updateSelectedText: function (component, event) {
        debugger;
        //Get sleceted Checkbox rows.
        var selectedRows = event.getParam('selectedRows');
        //Store a count in an attribute.
        component.set('v.selectedRowsCount', selectedRows.length);
        //Stored in var to display count in console.
        //You can skip next two lines.
        var slectCount =selectedRows.length;
        console.log('slectCount'+slectCount);
        //Created var to store record id's for selected checkboxes. 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
             
            setRows.push(selectedRows[i]);
             
        }
        //Adding slelected recordIds to an attribute.
        component.set("v.selectedLeads", setRows);
        console.log('selected data:'+setRows);
 
        //Added this condition to show the button "Delete Leads".
        //If checkbox is selected then only it will show else no.
        if(slectCount>0){
            component.set('v.ButtonShow', true);
        }else{
            component.set('v.ButtonShow', false);
        }
    },
 
    //This fucntion to handle a delete functionality.
    handleClick : function(component, event, helper){
        debugger;
        //Created var that store the recordIds of selected rows.
        var records = component.get("v.selectedLeads");
        //Console log.
        console.log(records);
        //Calling helper to perform delete action.
        helper.deltingCheckboxAccounts(component, event, records);
    },
    // function to handle the Modal Popup window.
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showDeleteBox', true);
    },
 
    //Function to handle Cancel Popup.
    handleConfirmDialogCancel : function(component, event, helper) {
        console.log('Cancel');
        component.set('v.showDeleteBox', false);
    },
})