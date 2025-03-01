// API For Creating Task Record By using JSON Body
@RestResource(urlMapping='/APIToInsertTask/*')
global class APIToInsertTask {
    @httpPost
    global static responseWrapper TaskCreateAPI(){
        
        responseWrapper responseJSON = new responseWrapper();
        try{
            System.debug('taskList--> '+RestContext.request.requestBody.toString());
            TaskDetails taskdata = TaskDetails.parse(RestContext.request.requestBody.toString());
             System.debug('taskdata--> '+taskdata);
            if(taskdata != null){
                Task tk = new Task();
                tk.WhoId = String.valueOf(taskdata.WhoId);
                System.debug(' tk.WhoId ::'+ tk.WhoId);
                tk.CallDurationInSeconds = Integer.valueOf(taskdata.callDuration);
                tk.Status = String.valueOf(taskdata.status);
                tk.Subject = String.valueOf(taskdata.Subject);
                insert tk;
                responseJSON.Message = 'Task Created Successfully';
                responseJSON.ID =tk.id;
            } else {
                responseJSON.Message = 'Task Creation Failed';
            }
        }catch(Exception e){
            HandleException.CreateErrorMsg('APIToInsertTask', 'TaskCreateAPI', e);
            responseJSON.Message= e.getMessage();
        }
        return responseJSON;
    }
    global class responseWrapper {
        global String Message;
        global string ID;
    }
}

/* Request Body
{
"WhoId": "0035i00000DH6wzAAD",
"OwnerId": "0055i000003FaQuAAK",
"Subject": "Call",
"Status": "Completed",
"callDuration": "234"
}
*/