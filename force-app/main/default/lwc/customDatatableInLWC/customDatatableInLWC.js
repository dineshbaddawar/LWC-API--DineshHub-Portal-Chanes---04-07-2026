import { LightningElement, track, wire } from 'lwc';
import retriveCons from '@salesforce/apex/LWCUtilityHelper.getContacts';
export default class CustomDatatableInLWC extends LightningElement {
// reactive variables
    @track data = [];
    @track error;
    @track bShowModal = false;
    @track selectedCons;

    // opening the modal
    openModal() { this.bShowModal = true; }
    // closeing the modal
    closeModal() { this.bShowModal = false;}

    // Getting Contacts using Wire Service
    @wire(retriveCons)
    contacts(result) {
        debugger;
        if (result.data) {
            this.data = result.data;
            this.error = undefined;

        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }

    // Select the all rows
    allSelected(event) {
        debugger;
        let selectedRows = this.template.querySelectorAll('lightning-input');
        
        for(let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].type === 'checkbox') {
                selectedRows[i].checked = event.target.checked;
            }
        }
    }

    showContacts() {
        debugger;
        this.bShowModal = true;

        this.selectedCons = [];

        let selectedRows = this.template.querySelectorAll('lightning-input');

        // based on selected row getting values of the contact
        for(let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].checked && selectedRows[i].type === 'checkbox') {
                this.selectedCons.push({
                    Name: selectedRows[i].value,
                    Id: selectedRows[i].dataset.id
                })
            }
        }
    }
}