({
    handlechange : function(component, event, helper) {
        alert("Method called")
      // this will contain the String of the "value" attribute of the selected option
      var selectedOptionValue = event.getParam("value");
      alert("Option selected with value: '" + selectedOptionValue + "'");
    }
})