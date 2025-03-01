({
    ValidateEmail : function(component, event, helper) {  
        console.log("Method Called")
        var emailField = component.find("txtEmail");
        console.log("emailField--------: ",emailField)
        var emailFieldValue = emailField.get("v.value");
        console.log("emailFieldValue--------: ",emailFieldValue)
        // Store Regular Expression
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
          console.log("regExpEmailformat--------: ",regExpEmailformat)
        // check if Email field in not blank,
        // and if Email field value is valid then set error message to null, and remove error CSS class.
        // ELSE if Email field value is invalid then add Error Style Css Class, and set the error Message.          
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(emailFieldValue.match(regExpEmailformat)){
                emailField.set("v.errors", [{message: 'Email is valid'}]);
                $A.util.removeClass(emailField, 'slds-has-error');                
            }else{
                $A.util.addClass(emailField, 'slds-has-error');
                emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);               
            }
        } 
    },
 })