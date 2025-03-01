import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllFolderDetails from '@salesforce/apex/OneDriveAPIHelper.getAllFolderDetails';
import getAllFilesFromFolder from '@salesforce/apex/OneDriveAPIHelper.getAllFilesFromFolder';
import createFolder from '@salesforce/apex/OneDriveAPIHelper.CreateFolder';
import DeleteFolder from '@salesforce/apex/OneDriveAPIHelper.DeleteFolder';
import uploadFile from '@salesforce/apex/OneDriveAPIHelper.uploadFileToOneDrive';

export default class OneDriveFolderCreation extends LightningElement {
    @track folderData = [];
    @track fileData = [];
    @track showFiles = false;
    @track isShowFileScreen = false;
    @track selectedFolderId = '';
    @track folderPath = [];
    @api recordId;
    @track isLoading = false;
    isModalOpen = false;
    @track isDeletingToastLoading = false;
    @track isLoadingFolderFiles = false;
    @track isFileCreationLoading = false;
    isFolderCreationTrue = false;
    @track folderName = '';
    error;
    @track spinnerMessage = 'Please wait, deleting file...';
    @track showFileScreen = false;

    connectedCallback() {
        debugger;
        this.loadFolders();
    }

    loadFolders() {
         this.isLoading = true;
        getAllFolderDetails()
            .then(result => {
                 this.isLoading = false;
                 this.isShowFileScreen = true;
                 this.folderData = Object.entries(result).map(([name, details]) => ({
                label: name,
                value: details.id,
                createdDateTime: details.createdDateTime
            }));
            })
            .catch(error => {
                console.error('Error fetching folder details:', error);
            });
    }

    handleRowClick(event) {
        debugger;
        // this.isLoading = true;
        this.isLoadingFolderFiles = true;
        this.spinnerMessage = 'Loading files, Please wait !';
        const folderId = event.currentTarget.getAttribute('data-id');
        this.selectedFolderId = folderId;
        this.loadFiles(folderId);
       // this.updateFolderPath(folderId);
    }

    loadFiles(folderId) {
        debugger;
        getAllFilesFromFolder({ folderId })
            .then(result => {
                //   this.isLoading = false;
                  this.isLoadingFolderFiles = false;
                try {
                    const parsedResult = JSON.parse(result);
                     if(parsedResult.length > 0){
                        this.showFileScreen = true;
                     }else{
                        
                     }
                    if (Array.isArray(parsedResult)) {
                        this.fileData = parsedResult.map(file => ({
                            label: file.filename,
                            url: file.fileurl,
                            createdDateTime: file.createdDateTime,
                            size: this.formatFileSize( file.size)
                            // mimeType: file.mimeType
                        }));
                    } else {
                        console.error('Unexpected data format:', parsedResult);
                    }
                    this.showFiles = true;
                } catch (e) {
                    console.error('Error parsing files JSON:', e);
                    this.showFiles = false;
                }
            })
            .catch(error => {
                console.error('Error fetching files:', error);
                this.showFiles = false;
            });
    }

    formatFileSize(bytes) {
        debugger;
        if (bytes < 1024) {
            return `${bytes} Bytes`;
        } else if (bytes < 1048576) { // 1024 * 1024 = 1048576
            return `${(bytes / 1024).toFixed(2)} KB`;
        } else {
            return `${(bytes / 1048576).toFixed(2)} MB`;
        }
    }

    handleFileClick(event) {
        debugger;
        const fileUrl = event.currentTarget.getAttribute('data-url');
        window.open(fileUrl, '_blank');
    }

    handleDeleteFileClick(event) {
        debugger; 
        this.isDeletingToastLoading = true;
        this.isShowFileScreen = false;
        const folderId = event.currentTarget.dataset.id;
        setTimeout(() => {
            DeleteFolder({ folderId: folderId })
                .then((result) => {
                    this.isDeletingToastLoading = false; 
                    if (result === 'SUCCESS') {
                        this.toast('Folder Deleted Successfully!');
                        this.loadFolders();
                    } else {
                        this.toast(`Error occurred: ${result}`);
                    }
                })
                .catch((error) => {
                    console.error('Error deleting folder:', error);
                    this.isDeletingToastLoading = false;
                    this.toast('An error occurred while deleting the folder.');
                });
        }, 2000);
    }


    handleBackClick() {
        this.showFiles = false;
        this.selectedFolderId = '';
        this.folderPath = [];
    }

    ShowFolderCreateScreen() {
        debugger;
        this.isModalOpen = true;
    }

    handleFolderCreation(){
        debugger;
        this.isFileCreationLoading = true;
        this.isModalOpen = false;
        if(this.folderName){
            createFolder({folderName : this.folderName}) .then(result =>{
                this.isFileCreationLoading = false;
                if(result && result == 'SUCCESS'){
                   this.toast('Folder Created Successfully !');
                   setTimeout(() => {
                    window.location.reload();
                   }, 100);
                }
            })
            .catch(error =>{
             console.log('Error == >'+this.error);
            })
        }
    }

    handleFileUpload() {
        debugger;
        this.template.querySelector('input[type="file"]').click();
    }

    handleFileChange(event) {
        debugger;
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = () => {
                // Create a Blob from the file content
                this.fileData = {
                    filename: file.name,
                    content: reader.result, // Store ArrayBuffer or Data URL
                    recordId: this.recordId
                };
                console.log('File Data:', this.fileData);
            };
            reader.readAsArrayBuffer(file); // Read file as ArrayBuffer
        }
    }

    handleClick() {
        debugger;
        const { content, filename, recordId } = this.fileData;
    
        // Convert the Blob content to Base64 for Apex method
        const reader = new FileReader();
        reader.onloadend = () => {
            const base64 = reader.result.split(',')[1]; // Extract base64 content
            uploadFile({ base64, filename, recordId })
                .then(result => {
                    this.fileData = null;
                    this.toast(`${filename} uploaded successfully!`);
                })
                .catch(error => {
                    console.error('Error uploading file:', error);
                });
        };
    
        // Read Blob as Data URL to get Base64 content
        reader.readAsDataURL(content);
    }
    
    toast(title){
        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent)
    }

    // updateFolderPath(folderId) {
    //     debugger;
    //     // For simplicity, let's assume we have a way to get the folder hierarchy
    //     // In practice, you would need to fetch the path from the server or maintain it in a state
    //     this.folderPath = this.calculateFolderPath(folderId);
    // }

    // calculateFolderPath(folderId) {
    //     // Placeholder for actual path calculation
    //     // This should be replaced with logic to build the full path based on the current folderId
    //     return [
    //         { label: 'OneDrive', value: '' },
    //         { label: 'FolderName', value: folderId, isLast: false }
    //     ];
    // }

    // handlePathClick(event) {
    //     debugger;
    //     const folderId = event.currentTarget.getAttribute('data-id');
    //     if (folderId) {
    //         this.loadFiles(folderId);
    //         this.updateFolderPath(folderId);
    //     }
    // }

    handleInputChange(event) {
        debugger;
        this.folderName = event.target.value;
    }

     closeModal() {
        console.log('Modal closed');
        this.isModalOpen = false;
     }

}