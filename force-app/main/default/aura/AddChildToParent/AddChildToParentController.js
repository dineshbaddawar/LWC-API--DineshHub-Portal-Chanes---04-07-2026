({
    doInit : function(component, event, helper) {
        debugger;
   // alert("doInit Method called")
    helper.getChildRecors(component,event);
    },
    addSelected  : function(component, event, helper){
         debugger;
      //  alert("addSelected Method Called")
          var tempIDs = [];

          // get (find) all checkboxes with arua:id "checkBox"
          debugger;
          var getAllId = component.find("checkBox");

          // Iterating for loop and checking every check box value
          // If value is checked(true) then add those Id (store in Text attribute on checkbox) tempIDs variable.
          for(var i=0; i < getAllId.length; i++){
            if(getAllId[i].get("v.value") == true){
                tempIDs.push(getAllId[i].get("v.text"));
            }
          }

          // Calling helper function and passing all selected Record IDs.
          helper.addSelectedHelper(component, event, tempIDs);
    },

})