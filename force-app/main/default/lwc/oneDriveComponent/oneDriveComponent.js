import { LightningElement,api,wire } from 'lwc';
import getAllFolderDetails from '@salesforce/apex/OneDriveAPIHelper.getAllFolderDetails';
export default class OneDriveComponent extends LightningElement {

    folderList = [];

    @wire(getAllFolderDetails)
    wiredAccounts(result) {
        debugger;
        this.folderList = result;
        if (result.data) {
        } else if (result.error) {
        }
    }
}