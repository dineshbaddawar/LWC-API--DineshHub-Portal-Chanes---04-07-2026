({   
    doInit : function(component, event, helper){
        component.set("v.columns", [
            {label:'Id', fieldName:"Id", sortable:true, type:'text', intialWidth: 300},
            {label: 'Name', fieldName:"Name", sortable:true, type:'text', intialWidth:400},
            {label: 'Phone', fieldName: 'Phone', sortable:true, type:'text', intialWidth: 300},
            {label: 'Created Date', fieldName: 'CreatedDate', sortable:true, type:'text', intialWidth: 400}
        ]);
        helper.getAccountRecords(component, helper);
        
    },
    updateSorting : function(component, event, helper){
        
        var fieldName = event.getParam('fieldName');
        console.log('fieldName====>',fieldName);
        
        var sortDirection = event.getParam('sortDirection');
        console.log('sortDirection 1====>',sortDirection);
        
        component.set("v.sortedBy", fieldName);
        console.log('fieldName====>',fieldName);
        
        component.set("v.sortedDirection", sortDirection);
        alert('sortDirection 2',sortDirection);
        
        console.log('sortDirection 3 ====>',sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
})