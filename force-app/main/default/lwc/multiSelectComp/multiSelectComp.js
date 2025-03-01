import { LightningElement,api,track } from 'lwc';
export default class MultiSelectComp extends LightningElement {

@track selectedContacts = [];
    selectedContactList = [];
    handleSelectedRecords(event) {
        debugger;
        this.selectedContacts = event.detail.selRecords;
        if(this.selectedContacts.length !=0){
         console.log('Selecte Record Details > Name == > '+JSON.stringify(this.selectedContacts[0].name) +' && ID == >'+JSON.stringify(this.selectedContacts[0].recId));
        }
    }
}