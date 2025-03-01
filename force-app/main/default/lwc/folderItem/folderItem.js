import { LightningElement, api, wire, track } from 'lwc';
import folderpng from '@salesforce/resourceUrl/folderpng';
import PreviewPDF from '@salesforce/apex/FileExplorerHelper.PreviewPDF';
export default class FolderItem extends LightningElement {
     @api item = [];
     selectedRecordIdPDF;
     selectedFolderName;
     showPDF = false;
     error;
     pdfUrl;
     folderfile = folderpng;
     showUploadFileButton = false;
     showDeleteFileButton = false;
     myCustomVarinat;
     showUploadFileScreen = false;
     @api myRecordId = '0065i00000KO5xyAAD';

     get acceptedFormats() {
          return ['.pdf', '.png'];
      }

     handleItemClickNew(event){
          debugger;
          this.selectedRecordIdPDF = event.currentTarget.dataset.recordId;
          const clickedItemId = event.currentTarget.dataset.recordId;
          this.item = this.item.map(item => ({
               ...item,
               items: item.items.map(subItem => ({
                   ...subItem,
                   variant: subItem.id === clickedItemId ? 'success' : 'default'
               }))
           }));
          if ( this.selectedRecordIdPDF !=undefined) {
               this.showUploadFileButton = false;
               this.showDeleteFileButton = true;
              
          }
          this.getViewPreviewFile();
          console.log('Selected Record ID:', selectedRecordId);
     }

     handleFolderClick(event) {
          debugger;
          this.selectedFolderName = event.currentTarget.dataset.recordId;
          if (this.selectedFolderName != undefined) {
               this.showUploadFileButton = true;
               this.showDeleteFileButton = false;
               
          }
     }
     
     getViewPreviewFile(){
          debugger;
          PreviewPDF({procDocId : this.selectedRecordIdPDF})
          .then(result =>{
              if(result){
              this.showPDF = true;
               if(result){
                  const pdfBlob = this.base64ToBlob(result, 'application/pdf');
                  this.pdfUrl = URL.createObjectURL(pdfBlob);
               }
              }
          })
          .catch(error =>{
           this.error = error;
          })
     }
     
    base64ToBlob(base64String, contentType) {
     debugger;
     const byteCharacters = atob(base64String);
     const byteArrays = [];
     for (let offset = 0; offset < byteCharacters.length; offset += 512) {
         const slice = byteCharacters.slice(offset, offset + 512);
         const byteNumbers = new Array(slice.length);
         for (let i = 0; i < slice.length; i++) {
             byteNumbers[i] = slice.charCodeAt(i);
         }
         const byteArray = new Uint8Array(byteNumbers);
         byteArrays.push(byteArray);
     }
         return new Blob(byteArrays, { type: contentType });
    }
     
     deleteFiles() {
          debugger;
     }
     
     uploadFile() {
          this.showUploadFileScreen = true;
          this.showPDF = false;
          let folderName = this.selectedFolderName;
          debugger;
     }

     handleUploadFinished(event) {
          debugger;
          // Get the list of uploaded files
          const uploadedFiles = event.detail.files;
          alert('No. of files uploaded : ' + uploadedFiles.length);
      }
     
}