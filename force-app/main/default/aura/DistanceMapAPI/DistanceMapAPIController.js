({
    
    changeHandler :  function(component, event, helper) {
        debugger;
        var desstination = component.find('destination').get("v.value");
        var origin =  component.find('origin').get("v.value");
        component.set("v.destrinationcode", desstination);
        component.set("v.origincode", origin);
    },
    
    GetDistance : function(component, event, helper) {
        debugger;
        var action = component.get("c.GetDistanceFromGoogleMaps");
        action.setParams({
            "Origin" : component.get("v.origincode"),
            "Destination" : component.get("v.destrinationcode")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.ShowTable", true);
                var data = response.getReturnValue();
                var mileDistance = data.rows[0].elements[0].distance.text;
                let newvalue = mileDistance.replace(/mi/g, " ") * 1.60934;
                console.log("Distance in KM "+mileDistance);
                component.set("v.destinationAddressValue", data.destination_addresses[0]);
                component.set("v.originAddressValue", data.origin_addresses[0]);
                component.set("v.distance", newvalue+' KM');
                component.set("v.duration", data.rows[0].elements[0].duration.text);
            }else{
                alert("ERROR")
            }
        });
        $A.enqueueAction(action);
    }
})