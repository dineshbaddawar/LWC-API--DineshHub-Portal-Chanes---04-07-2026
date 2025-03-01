({
    getAccountRecords : function(component, helper){
        var action = component.get("c.getAccountList");
        action.setCallback(this, function(response){
            var state = response.getState();
            var data;
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.AccountList", result);
            }
        });
        $A.enqueueAction(action);
    },
    sortData : function(component, fieldName, sortDirection){
        var fname = fieldName;
        var data = component.get("v.AccountList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.AccountList", data);
    },
    
    sortBy : function(field, reverse){
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function(a, b){
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
})