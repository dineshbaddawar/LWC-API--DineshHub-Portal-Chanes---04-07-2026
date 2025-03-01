import { LightningElement,api, track } from 'lwc';
import LeadCreation from '@salesforce/apex/LeadCreationOnQRScan.LeadCreation';
import LightningConfirm from "lightning/confirm";
import LightningAlert from 'lightning/alert';
import staticlogo from '@salesforce/resourceUrl/logo';
//import getPickListValuesMethod from '@salesforce/apex/LeadCreationOnQRScan.getPickListValuesMethod';
import getAccountRecord from '@salesforce/apex/LeadCreationOnQRScan.getAccountRecord';

export default class QrCodeScannerLWC extends LightningElement {
 @track isLoading = false;
    addimage = staticlogo;
    @api recordId;

    @track firstname;
    @track lastname;
    @track phone;
    @track email;
  @track doctorName;

    connectedCallback(){
        setTimeout(() => {
         //   this.getRecordDetails();
           // this.getPicklistValue();
            this.accountMethod();
         }, 300);
    }

 accountMethod() {
        getAccountRecord({
            recordId : this.recordId
        })
            .then(result => {
                this.doctorName = result.Name;
            })
            .catch(error => {
                this.error = error;
            });
    }

 HandleChange(event){
        debugger;
        let value=event.target.value;
        if(event.target.name=='FirstName'){
             this.firstname=value;
        }
        else if(event.target.name=='LastName'){
            this.lastname=value;
        }
        else if(event.target.name=='Phone'){
            this.phonevalue=value;
        }
        else if(event.target.name=='Email'){
             this.email=value;
        }
       
    }

    handleCorrectPhone(PhoneToverify){
        var regExpPhoneformat = /^[0-9]{1,10}$/g;
        if (PhoneToverify.match(regExpPhoneformat)) {
            return true;
        }
        else {
            window.alert('Enter a valid Phone');
            return false;
           
        }
    }

       handleIncorrectEmail(emailtocheck) {
        debugger;

        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (emailtocheck.match(regExpEmailformat)) {
            return true;
        }
        else {
           
            window.alert('Enter a valid Email');
            return false;
        }

    }

      HandleSumbit(){
        this.isLoading = true;
        window.setTimeout(() => { this.isLoading = false;}, 2000);
       let incorrectvaluePhone= this.handleCorrectPhone(this.phonevalue);
       let incorrectvalueEmail= this.handleIncorrectEmail(this.email);
        debugger;
        if(this.firstname!=null && (this.phonevalue!=null && incorrectvaluePhone==true) && this.lastname!=null && (this.email!=null && incorrectvalueEmail==true)){
            LeadCreation({firstName:this.firstname,LastName:this.lastname,Phone:this.phonevalue,Email:this.email,recordId:this.recordId})
            .then(result=>{
                if(result=='success'){
                   //this.showToast();
                   this.handleConfirm();
                 //  eval("$A.get('e.force:refreshView').fire();");
                   this.firstname='';
                   this.phonevalue='';
                   this.lastname='';
                   this.email='';
                }
            })
            .catch(error=>{
                console.log('error='+error);
            })
        }else{
            this.handleAlertClick();
        }
        
    }

      async handleConfirm() {
        debugger;
        // const result = await LightningConfirm.open({
        //   message: "Lead Created Successfully",
        //   theme: "success",
        //   label: "Success"
        // });
        console.log("🚀 ~ result");
        window.open("https://web.twinhealth.com/");
      }

      async handleAlertClick() {
        await LightningAlert.open({
            message: 'One Of The Field is Empty',
            theme: 'error', // a red theme intended for error states
            label: 'Error!', // this is the header text
        });
        //Alert has been closed
    }

}