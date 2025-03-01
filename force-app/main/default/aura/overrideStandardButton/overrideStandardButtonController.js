({
	doInit : function(component, event, helper) {
        debugger;
        try{
            component.find("accountRecordCReator").getNewRecord(
            "Account", // Sobject Type
                "null", // recordTypeId
                false,    // skip cache
                $A.getCallback(function(){
                    const rec = component.get("v.newAccount");
                    const err = component.get("v.newAccountError");
                    if(err || (rec === null)){
                        console.log("Error:" +err);
                        return;
                    }
                })
            );
            
        }catch(e){
            console.log({e})
        }
	},
    
    saveAccount : function(component, event, helper) {
        debugger; 
      //  alert("Save Account")
        component.find("accountRecordCReator").saveRecord(function(saveResult){
            if(saveResult.state === "SUCCESS"){
                var resultToast = $A.get("e.force:showToast");
                resultToast.setParams({
                     "variant": "success",
                    "message" : "Account Created Successfully !"
                   
                });
                resultToast.fire();
            } else if(saveResult.state === 'ERROR'){
                console.log("Error : "+ JSON.stringify(saveResult.error));
            }
        });
        debugger;
        var navEvent = $A.get("e.force:navigateToList");
        var accountViewId = '00B5i00000BVniMEAT';
                navEvent.setParams({
                    "listViewId": accountViewId,
                    "listViewName": 'Recently Viewed Accounts',
                    "scope": "Account"
                });
                navEvent.fire();
    }
});