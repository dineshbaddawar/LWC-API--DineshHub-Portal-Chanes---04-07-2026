({
    MaxFileSize : 4500000, // 5.5MB
    ChukFileSize : 750000,  // 750KB
    uploadHelper: function(component, event) { 
        debugger;
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileuploader").get("v.files");
        // Getting First File Using Index
        var file = fileInput[0];
        var self = this;        
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function
        if(file.size > self.MaxFileSize){
            component.set("v.fileName", 'Alert : File Size can not Exceed ' + self.MaxFileSize + 'bytes.\n' + ' SELECTED File Size: ' + file.size);
            return;
        }
        
        //  Creating a FileReader Object
        debugger;
        var objFileReader = new FileReader();
        // Settin onload Function of FileReader Object
        objFileReader.onload = $A.getCallback(function(){
            var fileContents = objFileReader.result;
            console.log("fileContents ::", fileContents);
            var base64 = 'base64';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // Calling the Upload Process Method
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess : function(component, file, fileContents){
        debugger;
        // set a default size or startpostiton as 0 
        var startPosition = 1;
        // calculating the end size or endPostion using Math.min() function which is return the min. value  
       // var endPosition = fileContents.length;
          var endPosition = Math.min(fileContents.length, startPosition + this.ChukFileSize);
         console.log("The End Position ::",endPosition);
          var attachId = component.get("v.recordId");
        component.set("v.parentId",attachId);
        // starting with the initial chunk, and seting the attachId(last parameter)is null in the begin
        this.uploadInChunk(component, file,fileContents, startPosition, endPosition,'');
    },
    
    uploadInChunk : function(component, file, fileContents, startPosition, endPosition, attachId){
        debugger;
        // calling the apex method 'SaveFile''
        var getchunk = fileContents.substring(startPosition, endPosition);
       // console.log("getchunk ::"getchunk);
        //  var getChunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveFile");
        var attachId = component.get("v.recordId");
        action.setParams({
            parentId : component.get("v.parentId"),
            fileName : file.name,
            base64Data : encodeURIComponent(getchunk),
            ContentType : file.type,
            fileId: attachId
            
        });
        
        debugger;
        // Setting Callback Method
        action.setCallback(this, function(response){
            // Storing response or AttachmentId
            attachId = response.getReturnValue(); 
            console.log("attachId ::",attachId);
            var State = response.getState();
            if(State === 'SUCCESS'){
                // update the start position with end postion
                startPosition = endPosition;
                endPosition =  Math.min(fileContents.length, startPosition + this.ChukFileSize);
                 // check if the start postion is still less then end  then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if(startPosition < endPosition){
                  // this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId) 
                   alert("File has been updated Successfully")
                }else{
                    alert("ERROR")
                }
                // handling the response error
            } else if(State === 'INCOMPLETE'){
                alert("From Server :"+response.getReturnValue());
            } else if(State === 'ERROR'){
                var error = response.getErrors();
                if(error){
                    if(error[0] && errror[0].message){
                        console.log("Error message ::" + error[0].message);
                    }
                }else{
                    console.log("Unkown Error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})