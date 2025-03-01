import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile';
import { CloseActionScreenEvent } from 'lightning/actions';
import { updateRecord } from 'lightning/uiRecordApi';

export default class ProfilePicUploader extends LightningElement {
     @api recordId;
     @api isLoaded = false;
     fileData;
     debugger;
     openfileUpload(event) {
         const file = event.target.files[0]
         var reader = new FileReader()
         reader.onload = () => {
             var base64 = reader.result.split(',')[1]
             this.fileData = {
                 'filename': file.name,
                 'base64': base64,
                 'recordId': this.recordId
             }
             console.log(this.fileData)
         }
         reader.readAsDataURL(file)
     }
     
     handleClick(){
          this.isLoaded = !this.isLoaded;
         const {base64, filename, recordId} = this.fileData
         uploadFile({ base64, filename, recordId }).then(result=>{
             this.fileData = null
             let title = `${filename} uploaded successfully!!`
             this.toast(title);
             this.isLoaded = !this.isLoaded;
             this.dispatchEvent(new CloseActionScreenEvent());
             updateRecord({ fields: { Id: this.recordId }})

         })
     }
 
     toast(title){
         const toastEvent = new ShowToastEvent({
             title, 
             variant:"success"
         })
         this.dispatchEvent(toastEvent)
     }
}