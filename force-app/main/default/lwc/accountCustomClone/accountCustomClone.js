import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getFieldSetFromAccount from '@salesforce/apex/UtilityClass.getFieldSetFromAccount';

export default class AccountCustomClone extends NavigationMixin(LightningElement) {
    @api recordId;
    @wire(getFieldSetFromAccount, { accId: '$recordId' })
    getOppRecords({ error, data }) {
        debugger;
        console.log('data====', data);
        if (data != null) {
            this.datafromMethod(data);

        } else {
            console.log('The Error --> ' + error);
        }
    }
    datafromMethod(datJSON) {
        const defaultValues = encodeDefaultFieldValues(datJSON);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}