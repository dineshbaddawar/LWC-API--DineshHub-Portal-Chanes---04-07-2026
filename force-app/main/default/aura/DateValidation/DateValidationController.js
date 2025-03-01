({
	dateUpdate : function(component, event, helper) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()
        var yyyy = today.getFullYear();
       
        if(dd < 10){
            dd = '0'+dd;
            
            
        }
      
        if(mm < 10){
           mm = '0'+mm;
            
        }
         debugger;
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
         debugger;
        if(component.get("v.myDate") !=null && component.get("v.myDate") < todayFormattedDate){
             debugger;
            component.set("v.validationError", true);
             debugger;
        }else{
            component.set("v.validationError", false);
             debugger;
        }
        
	},
    
    submit : function(component, event, helper){
        debugger;
        var isDateError = component.get("v.dateValidationError");
        if(isDateError != true){
            alert("Date is invalid, Please Select date from Future");
        }
    }
})