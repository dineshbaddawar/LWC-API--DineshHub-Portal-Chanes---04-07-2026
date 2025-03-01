import { LightningElement,api,track } from 'lwc';
import getAccountcount from '@salesforce/apex/AccountRelatedCount.getAccountcount';
export default class AccountRelatedCount extends LightningElement {

@api recordId;
@track contactCount;
@track opportunityCount;
@track caseCount;

 connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }
   
    getRecordDetails(){
        debugger;
        getAccountcount({recordId : this.recordId})
        .then(data =>{
            if(data){
                console.log("data :",data);
                var jsondata = JSON.stringify(data); 
                this.contactCount = data.contactCount;
                this.opportunityCount = data.OpportunityCount;
                this.caseCount = data.caseCount;
            }
        })
    }

}