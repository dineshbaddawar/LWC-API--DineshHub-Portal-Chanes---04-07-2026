import { LightningElement, api } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import excelFileReader from "@salesforce/resourceUrl/ExcelReaderPlugin";
let XLS = {};
import insertBulkCaseXlsxFiel from '@salesforce/apex/BulkCaseUploadController.insertBulkCaseXlsxFiel';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BulkCaseUploadURL from '@salesforce/label/c.BulkCaseUploadURL';

export default class BulkCaseRecordUploadXlsx extends LightningElement {

    error;
    data;
    jsonData = [];
    showTable = false;
    showUploadFile = true;
    @api docTempName;
    strUploadFileName;
    objExcelToJSON;
    BulkCaseUploadURL = BulkCaseUploadURL;

    connectedCallback() {
        debugger;
        this.docTempName = this.docTempName;
        Promise.all([loadScript(this, excelFileReader)])
             .then(() => {
                  XLS = XLSX;
             })
             .catch((error) => {
                  console.log("An error occurred while processing the file");
             });
   }

   @api
   handleFileUpload(event) {
        debugger;
        console.log(event);
        this.handleUploadFinished(event);
   }

    handleUploadFinished(event) {
        debugger;
        const strUploadedFile = event.detail.files;
        if (strUploadedFile.length && strUploadedFile != "") {
            this.strUploadFileName = strUploadedFile[0].name;
            var extension = this.strUploadFileName.split('.').pop();
            this.handleProcessExcelFile(strUploadedFile[0]);
        }
    }

    handleProcessExcelFile(file) {
        debugger;
        let objFileReader = new FileReader();
        objFileReader.onload = (event) =>{
            let objFiledata = event.target.result;
            let objFileWorkbook = XLS.read(objFiledata, {
                 type: "binary"
            });
            this.objExcelToJSON = XLS.utils.sheet_to_row_object_array(objFileWorkbook.Sheets["Sheet1"]);
            if (this.objExcelToJSON.length === 0) {
                var SheetFileName = objFileWorkbook.SheetNames;
                this.objExcelToJSON = XLS.utils.sheet_to_row_object_array(objFileWorkbook.Sheets[SheetFileName]);
           }
           if (this.objExcelToJSON.length > 0) {
            debugger;
            Object.keys(this.objExcelToJSON).forEach((key) => {
                const replacedKey = key.trim().toUpperCase().replace(/ss+/g, "_");
                if (key !== replacedKey) {
                     this.objExcelToJSON[replacedKey] = this.objExcelToJSON[key];
                     delete this.objExcelToJSON[key];
                }
            });
            console.log('objExcelToJSON' + this.objExcelToJSON);
            let data = JSON.parse(JSON.stringify(this.objExcelToJSON));
            let objList = [];
            let index = 0;
            var orderNumbers = [];

            for(var i=0;i<data.length; i++){
               index += 1;
               var rawDate = data[i]["Date Of Order"];
               var formattedDate = this.formatExcelDate(rawDate);
               var obj = {
                    "orderno" : data[i]["Order No"],
                    "item": data[i]["Item"],
                    "oosquantity": data[i]["OOS Quantity"],
                    "oosskucode": data[i]["OOS SKU Code"],
                    "reason": data[i]["Reason"],
                    "remarks": data[i]["Remarks"],
                    "dateoforder": formattedDate,
                    "shippingmobileno": data[i]["Shipping Mobile No"],
                    "sno": index
               };
               objList.push(obj);    
            }
            
            this.jsonData = objList;
            this.showTable = true;
            this.showUploadFile = false;

            const value = 'HideCSV';
            const valueChangeEvent = new CustomEvent("valuechange", {
               detail: { value }
             });
             // Fire the custom event
             this.dispatchEvent(valueChangeEvent);

           }
        }
        objFileReader.onerror = function (error) {
            this.dispatchEvent(
                 new ShowToastEvent({
                      title: "Error while reading the file",
                      message: error.message,
                      variant: "error"
                 })
            );
       };
       objFileReader.readAsBinaryString(file);
    }

    closeAction(){
     debugger;
     window.location.href = this.BulkCaseUploadURL;
    }
    HandleImportRecord(){
     debugger;
     insertBulkCaseXlsxFiel({jsonString : JSON.stringify(this.jsonData), docTempName : this.docTempName}).then(result =>{
    if(result !=null && result == 'SUCCESS'){
     this.dispatchEvent(
          new ShowToastEvent({
               title: "SUCCESS",
               message: 'Record Uploaded Successfully !',
               variant: "success"
          })
     );
     setTimeout(() => {
          window.location.href = this.BulkCaseUploadURL;
      }, 3000);
    
    }else{
     alert('Something went wrong !');
    }
     })
     .catch(error =>{
          console.log('Error == >'+error);
     })
    }

    formatExcelDate(serialDate){
     debugger;
     if (!serialDate) return '';
     const excelStartDate = new Date(1900, 0, 1); // January 1, 1900
        const daysOffset = serialDate - 1; // Excel starts from 1, so subtract 1 day
        const convertedDate = new Date(excelStartDate.getTime() + daysOffset * 24 * 60 * 60 * 1000);
        
        // Format the date to DD-MM-YYYY
        const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
        return new Intl.DateTimeFormat('en-GB', options).format(convertedDate);
    }
}