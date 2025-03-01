({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getPickListValue");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var result = response.getReturnValue();
                var pikclistValues = [];
                for( var i=0; i <result.length;i++ ){
                    pikclistValues.push({
                        label : result[i],
                        value : result[i]
                    });
                }
                component.set("v.picList",pikclistValues);
            }
        });
         $A.enqueueAction(action);
	},
    
    handlepickChange : function(component, event, helper){
        debugger;
        // getting the selected Values
        var selectedValues = event.getParam("value");
        component.set("v.selpicList", selectedValues);
    },
    
    getSelectedList : function(component, event, helper){
        // get Selected pickList value
        var getSelectedValuePickList = component.get("v.selpicList");
        if(getSelectedValuePickList.length == 0){
             alert("Please Add PikcList Value")
        }else{
              alert("PickList Added Successfully")
        }
      
    }
})