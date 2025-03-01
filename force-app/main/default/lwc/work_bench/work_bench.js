import { LightningElement, track, wire, api } from 'lwc';
import fetchObjectsInfo from '@salesforce/apex/FetchObjects.fetchObjectsInfo';
import fetchFieldsInfo from '@salesforce/apex/FetchObjects.fetchFieldsInfo';
import sampleMC from '@salesforce/messageChannel/myMessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFIELD from '@salesforce/schema/User.Name';

export default class Work_bench extends LightningElement {
    @wire(MessageContext) context;
    @track options = []; // Stores object options
    @track fieldsOption = []; // Stores field labels and API names
    @track selectedFields = []; // Stores API names for SOQL query
    @track selectedObject;
    @track filterOptions = [
        { label: '=', value: '=' },
        { label: '<=', value: '<=' },
        { label: '<', value: '<' },
        { label: '>=', value: '>=' },
        { label: '<>', value: '<>' },
        { label: 'in', value: 'in' },
        { label: 'not in', value: 'not in' },
        { label: 'like', value: 'like' }
    ];
    actualQuery = '';

    @track error;
    @track userId = Id;
    @track currentUserName;

    @wire(getRecord, { recordId: Id, fields: [UserNameFIELD] })
    currentUserInfo({ error, data }) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
        } else if (error) {
            this.error = error;
        }
    }

    @wire(fetchObjectsInfo)
    wiredObjects({ data, error }) {
        if (data) {
            this.options = data.map(item => ({ label: item, value: item }));
        } else if (error) {
            console.log(error);
        }
    }

    // Handle Object Selection
    optionHandler(event) {
        debugger;
        this.selectedObject = event.target.value;
        this.actualQuery = '';
        this.selectedFields = [];
        this.template.querySelector('.cool-textarea').value = '';

        fetchFieldsInfo({ obj: this.selectedObject })
            .then(data => {
                this.fieldsOption = data.map(item => ({
                    label: item.label, // Show Label in UI
                    value: item.apiName // Use API Name for Query
                }));
            })
            .catch(error => {
                console.log(error);
            });
    }

    // Handle Field Selection
    fieldsHandler(event) {
        debugger;
        const selectedValues = event.target.value; // API names
        this.selectedFields = selectedValues;

        // Construct SOQL Query
        this.actualQuery = `SELECT ${this.selectedFields.join(', ')} FROM ${this.selectedObject}`;
        this.template.querySelector('.cool-textarea').value = this.actualQuery;
    }

    // Filter Handlers
    filterFieldHandler(event) {
         debugger;
        this.choosedFilterField = event.target.value;
    }

    filterOperatorHandler(event) {
         debugger;
        this.choosedOperatorField = event.target.value;
    }

    filterValueHandler(event) {
         debugger;
        this.choosedValueField = event.target.value;
    }

    // Add Filter Logic
    filterHandler() {
         debugger;
        if (!this.actualQuery.includes('WHERE')) {
            this.actualQuery += ` WHERE ${this.choosedFilterField} ${this.choosedOperatorField} '${this.choosedValueField}'`;
        } else {
            this.actualQuery += ` AND ${this.choosedFilterField} ${this.choosedOperatorField} '${this.choosedValueField}'`;
        }
        this.template.querySelector('.cool-textarea').value = this.actualQuery;
    }

    // Run Query
    runQueryHandler() {
         debugger;
        let dataToSend = 'SUCCESS';
        publish(this.context, sampleMC, { lmsData: { data: this.actualQuery } });

        const sendDataEvent = new CustomEvent('senddata', {
            detail: { dataToSend }
        });
        this.dispatchEvent(sendDataEvent);
    }
}