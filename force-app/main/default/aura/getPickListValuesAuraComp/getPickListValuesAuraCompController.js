({
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, 'Industry', 'accIndustry');
    },
    onPicklistChange : function(component, event, helper){
        debugger;
        alert("Hi")
    }
})