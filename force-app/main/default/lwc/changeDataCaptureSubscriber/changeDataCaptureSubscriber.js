import { LightningElement, api } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import AssignTask from '@salesforce/apex/changeDataCaptureController.AssignTask';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ChangeDataCaptureSubscriber extends LightningElement {
     
     debugger;
    channelName = '/data/OpportunityChangeEvent';
    subscription = {};
    @api recordId;

    subscribed;

    // Tracks changes to channelName text field
     handleChannelName(event) {
        //  alert(" handleChannelName")
          debugger;
        this.channelName = event.target.value;
    }

     renderedCallback() {
        //  alert(" renderedCallback")
          debugger;
        if (!this.subscribed) {
            this.handleSubscribe();
            this.subscribed = true;
        }
    }

    // Initializes the component
     connectedCallback() {
        //  alert(" connectedCallback")
          debugger;
        // Register error listener
        this.registerErrorListener();

    }

    // Handles subscribe button click
     handleSubscribe() {
        //  alert(" handleSubscribe")
          debugger;
        // Callback invoked whenever a new event message is received
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
            // Response contains the payload of the new message received
            this.handleMessage(response);
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
          subscribe(this.channelName, -1, messageCallback).then(response => {
               debugger;
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    // Handles unsubscribe button click
     handleUnsubscribe() {
          debugger;
        //  alert(" handleUnsubscribe")
        // Invoke unsubscribe method of empApi
          unsubscribe(this.subscription, (response) => {
               debugger;
            console.log('unsubscribe() response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

     registerErrorListener() {
       //   alert(" registerErrorListener")
          debugger;
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }

     handleMessage(response) {
        //  alert("handleMessage")
          debugger;
          if (response) {
              // alert("Method Apex 1")
               if (response.hasOwnProperty('data')) {
               //     alert("Method Apex 2")
                let responsePayload = response.data.payload;    
                if (responsePayload.hasOwnProperty('StageName') && responsePayload.hasOwnProperty('ChangeEventHeader')) {
                    if (responsePayload.ChangeEventHeader.hasOwnProperty('recordIds') && responsePayload.StageName == 'Closed Won') {
                        let currentRecordId = responsePayload.ChangeEventHeader.recordIds.find(element => element == this.recordId);
                        console.log('currentRecordId', currentRecordId);
                        if (currentRecordId) {
                            AssignTask({
                                recordid: this.recordId
                            }).then(result => {
                                const event = new ShowToastEvent({
                                    title: 'Task Assigned',
                                    message: 'A task has been assigned to you, please complete them.',
                                    variant: 'success'
                                });
                                this.dispatchEvent(event);
                            }).catch(error => {
                                console.log(error);
                            })
                        }
                    }

                }
            }
        }
    }
}