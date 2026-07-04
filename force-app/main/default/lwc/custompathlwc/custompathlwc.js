import { LightningElement, api, wire, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Component__c.Type__c'];
export default class Custompathlwc extends LightningElement {
   @api recordId;
   currentvalue = '';
   @track selectedvalue = '';
   @track compdata;


     statusStepMap = {
        'Aura': '1',
        'LWC': '2'
        // 'In Progress': '3',
        // 'Waiting on Submitter': '4',
        // 'Waiting on External Party': '5',
        // 'Waiting on Approval': '6',
        // 'CM Action Required': '7',
        // 'Solved': '8'
    };


     @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
     wiredOrderdata({ error, data }) {
        debugger;
        if (data) {
            this.compdata = data.fields;
            this.selectedvalue = this.statusStepMap[this.compdata.Type__c.value]
        } else if (error) {
            console.error('Error retrieving orderdata:', error);
        }
    }
     pathHandler(event) {
        debugger;
        let targetValue = event.currentTarget.value;
        let selectedvalue = event.currentTarget.label;
        this.currentvalue = targetValue;
        this.selectedvalue = selectedvalue; 
        this.handleUpdate();
    }

    handleUpdate() {
        debugger;
        const fields = {
        Id: this.recordId,
        Type__c: this.selectedvalue
     };

    const recordInput = { fields };

     updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Success",
                    message: "Type updated",
                    variant: "success"
                })
            );
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error updating account",
                    message: error.body.message,
                    variant: "error"
                })
            );
       });

    }
}