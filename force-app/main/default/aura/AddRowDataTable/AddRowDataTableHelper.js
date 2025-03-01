({
	validateAccountRecords : function(component, event) {
		// Validate all Account records
		var isValid = true;
        var accountRecList = component.get("v.accountList");
        for(var i=0; i < accountRecList.length; i++){
            if(accountRecList[i].Name == ''){
                  isValid = false;
                alert('Account Name can not be Blank on '+(i + 1)+' row Number');
            }
        }
        return isValid;
	},
})