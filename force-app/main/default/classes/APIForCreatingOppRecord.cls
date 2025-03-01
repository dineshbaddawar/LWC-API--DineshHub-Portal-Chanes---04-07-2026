@RestResource(urlMapping='/APIToInsertOpportunity/*')
global class APIForCreatingOppRecord {
    
    @HttpPost
    global Static responseWrapper OppCreation(){
        responseWrapper responseJSON = new responseWrapper();
        try{
            System.debug('taskList--> '+RestContext.request.requestBody.toString());
            OpportunityDetails oppData = OpportunityDetails.parse(RestContext.request.requestBody.toString());
            System.debug('oppData--> '+oppData);
            Opportunity opp = new Opportunity();
            opp.AccountId = string.valueOf(oppData.OppAccountId);
            System.debug('opp.AccountId--> '+opp.AccountId);
            opp.Name = oppData.Name;
            opp.CloseDate = Date.valueOf(oppData.OppcloseDate); 
            opp.NextStep = String.valueOf(oppData.OppNextStep) ;
            opp.StageName = String.valueOf(oppData.OppStage) ;
            opp.Type = String.valueOf(oppData.Opptype) ;
            opp.Probability = Decimal.valueOf(oppData.OppProbality) ;
            opp.LeadSource = String.valueOf(oppData.OppleadSource) ;
            opp.Email__c = String.valueOf(oppData.OppEmail) ;
            opp.Url__c = String.valueOf( oppData.OppUrl);
            opp.Phone__c = String.valueOf(oppData.OppPhone) ;
            insert opp;
            responseJSON.Message = 'Opportunity Record Created Successfully';
            responseJSON.OppId = opp.Id;
        }catch(Exception e){
           // HandleException.CreateErrorMsg('Utility', 'getUpdateContactList', e);
            responseJSON.Message = e.getMessage();
        }
        return responseJSON;
    }
    global Class responseWrapper{
        global String Message;
        global String OppId;
    }
    
}

/*
{
    "OppAccountId": "0015i00000Td71gAAB",
    "Name": "Republic Day",
    "OppNextStep": "Completed",
    "Opptype": "New Customer",
    "OppProbality": 99,
    "OppStage": "Prospect",
    "OppcloseDate": "2023-01-26",
    "OppleadSource": "Web",
    "OppEmail": "dinesh@gmail.com",
    "OppUrl": "salesforce.com",
    "OppPhone": "7588229058"
}
 */