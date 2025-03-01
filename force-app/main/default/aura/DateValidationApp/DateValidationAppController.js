({
   init:function(component, event,helper){
    component.set("v.userDateTime",new Date().toISOString());
},

endDateUpdated: function(component,event,helper){
    var target = event.getSource();

    if(!$A.util.isUndefinedOrNull(target)) {
        var enteredValue = target.get("v.value");
        var g = new Date();
        if(Date.parse(enteredValue) > g.getTime()){
            component.find("end-date").set("v.value",null);
            alert('Invalid Date');
        }
    }
}
});