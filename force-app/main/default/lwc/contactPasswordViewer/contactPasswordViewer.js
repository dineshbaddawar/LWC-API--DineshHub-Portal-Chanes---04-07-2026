import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import PASSWORD_FIELD from '@salesforce/schema/Contact.Password__c'; // Update with your actual field API name

const fields = [PASSWORD_FIELD];

export default class ContactPasswordViewer extends LightningElement {
    @api recordId; // To pass the Contact record ID
    password = ''; // To hold the decrypted password
    inputType = 'password'; // Default input type for masking
    toggleIcon = 'utility:hide'; // Default icon

    @wire(getRecord, { recordId: '$recordId', fields })
    contactHandler({ error, data }) {
        debugger;
        if (data) {
            this.password = data.fields.Password__c.value;
        } else if (error) {
            console.error('Error fetching contact password:', error);
        }
    }

    togglePasswordVisibility() {
        debugger;
        if (this.inputType === 'password') {
            this.inputType = 'text';
            this.toggleIcon = 'utility:preview';
        } else {
            this.inputType = 'password';
            this.toggleIcon = 'utility:hide';
        }
    }
}