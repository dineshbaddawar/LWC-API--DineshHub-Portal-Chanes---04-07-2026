import { LightningElement, track } from 'lwc';

export default class ParentComponent extends LightningElement {
    @track selectedFolderId;

    handleFolderSelect(event) {
        debugger;
        this.selectedFolderId = event.detail.folderId;
    }
}