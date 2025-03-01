import { LightningElement, track, api, wire } from 'lwc';
import getAllDocuments from '@salesforce/apex/FileExplorerHelper.getDocCateList';

export default class FolderExplorer extends LightningElement {
     showFolderItem;
     @api recordId;
     getFolderFileData = [];
     error;
     @track folderStructure = [];

     connectedCallback() {
          debugger;
          this.showFolderItem = true;
          setTimeout(() => {
           this.getlDocumentMethod();
          }, 300);
     }

     getlDocumentMethod() {
          debugger;
          getAllDocuments({ opportunityId: this.recordId })
               .then(result => {
                    if (result) {
                         this.getFolderFileData = result;
                         let tempObj = [];
                         for (var i = 0; i < this.getFolderFileData.length; i++){
                              console.log('data === >' + JSON.stringify(this.getFolderFileData[i]));
                              let items = [];
                              for (var j = 0; j < this.getFolderFileData[i].Document_Files__r.length; j++){
                                   let childObj = {
                                        name: this.getFolderFileData[i].Document_Files__r[j].Name,
                                        type: 'file',
                                        id : this.getFolderFileData[i].Document_Files__r[j].Id
                                   };
                                   items.push(childObj);
                              }
                              let parentObj = {
                                   name: this.getFolderFileData[i].Name,
                                   type: 'folder',
                                   items : items
                              };
                              tempObj.push(parentObj);
                         }
                         this.folderStructure = tempObj;
               }
               })
               .catch(error => {
                    this.error = error;
          })
     }
          
}