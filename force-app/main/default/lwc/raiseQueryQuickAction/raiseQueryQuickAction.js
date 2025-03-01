import { LightningElement,api,track,wire } from 'lwc';
import sendCaseRequestToTargetOrg from '@salesforce/apex/SalesforceSourceORGAPIHelper.callCreateCaseMethod';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class RaiseQueryQuickAction extends LightningElement {
 @api recordId;
 error;

 connectedCallback(){
        setTimeout(() => {
            this.callMethod();
        }, 300);
    }
callMethod(){
    debugger;
    sendCaseRequestToTargetOrg({recordId : this.recordId})
    .then((result) =>{
       if(result == 'SUCCESS'){
        const event = new ShowToastEvent({
        title: 'SUCCESS',
        message: 'Case Raised Successfully !',
        variant: 'success',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
       }else{
        const evt = new ShowToastEvent({
        title: 'Error',
        message: 'Some unexpected error',
        variant: 'error',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
       }
    })
    .catch((error) =>{
      this.error = error;
    })
}

}