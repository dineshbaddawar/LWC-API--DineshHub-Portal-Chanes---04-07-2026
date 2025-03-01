import { LightningElement,wire,api,track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Contact.Name','Contact.AccountId'];
export default class RecordPickerForContactUsingAccountId extends LightningElement {
    @api recordId;
    AccountId;
    contact;
    @track mergeValue;
    mergeContactId;
    filter = {};

        matchingInfo = {
            primaryField: { fieldPath: "Name" },
            additionalFields: [{ fieldPath: 'Name' }],
        };

        connectedCallback() {
                setTimeout(() => {
                    this.recordId = this.recordId;
                    this.callFilterMethod();
                }, 300);
            }

            callFilterMethod(){
            debugger;
            if (this.AccountId) {
                this.hasParentId = true;
                    this.filter = {
                        criteria: [
                            {
                                fieldPath: 'AccountId',
                                operator: 'eq',
                                value: this.AccountId,
                            },
                            {
                                fieldPath: 'Id',
                                operator: 'ne',
                                value: this.recordId,
                            },
                        ],
                        filterLogic: '1 AND 2',
                    };
                }
            }

    // For getting record detail using recordId
 @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredContact({ error, data }) {
        if (error) {
            console.log('Error Occered in @Wire-->'+error.body.message);
        } else if (data) {
            this.AccountId = data.fields.AccountId.value;
        }
    }

    // For getting selected contactId
     handleChangeCase(event){
         debugger;
        this.mergeContactId = event.detail.recordId;
        console.log('mergeCaseId==>'+this.mergeContactId);
    }
}