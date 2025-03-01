import { LightningElement } from 'lwc';
export default class Recordpickerporductname extends LightningElement {
//@api recordId;
    AccountId;
    Product2;
   // @track mergeValue;
    mergeContactId = 'Silver';
    filter = {};

        matchingInfo = {
            primaryField: { fieldPath: "Name" },
            additionalFields: [{ fieldPath: 'Family' }],
        };

        connectedCallback() {
                setTimeout(() => {
                   // this.recordId = this.recordId;
                    this.callFilterMethod();
                }, 300);
            }

              callFilterMethod(){
            debugger;
                    this.filter = {
                        criteria: [
                            {
                                fieldPath: 'Family',
                                operator: 'eq',
                                value: this.mergeContactId,
                            },
                        ],
                    };
                
            }

            handleChangeCase(){
                debugger;
            }
}