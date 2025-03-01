import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getFieldFromFieldSet from '@salesforce/apex/GetFieldSet.getFieldFromFieldSet';

export default class NavToNewRecord extends NavigationMixin(LightningElement) {
    @api recordId;
    @track result;
    // @track mapData = [];

    // connectedCallback() {
    //     // initialize component
    // }

    @wire(getFieldFromFieldSet, { oppId: '$recordId' })
    getOppRecords({ error, data }) {
        debugger;
        console.log('data====', data);
        if (data != null) {
            //var datJSON = JSON.stringify(data);

            //    delete data.attributes;
            //this.result = data;
            // var conts = data;
            // for (var key in conts) {
            //     this.mapData.push({ value: conts[key], key: key }); //Here we are creating the array to show on UI.
            // }
            //this.mapData = data;

            //console.log('data After====', mapData);
            this.navigateToNewContactWithDefaults(data);

        } else {
            console.log('The Error --> ' + error);
        }
    }

    navigateToNewContactWithDefaults(datJSON) {
        const defaultValues = encodeDefaultFieldValues(datJSON);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}