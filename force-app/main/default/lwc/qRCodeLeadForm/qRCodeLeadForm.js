import { LightningElement,api,track } from 'lwc';
import leadCreateForm from '@salesforce/apex/LeadQRCodeForm.createLeadFromQRcode';
export default class QRCodeLeadForm extends LightningElement {

@api recordId;
@track firstname;
@track lastname;
@track phone;
@track email;
@track company;

onChangeHandler(event){
    debugger;
     let value = event.target.value;
     if(event.target.name == "FirstName"){
         this.firstname = value;
         console.log("First Name "+this.firstname)
     }
     else if(event.target.name == "LastName"){
         this.lastname = value;
         console.log("Last Name "+this.lastname)
     }
     else if(event.target.name == "Phone"){
         this.phone = value;
         console.log("Phone  "+this.phone)
     }
     else if(event.target.name == "Email"){
         this.email = value;
         console.log("Email  "+this.email)
     }
     else if(event.target.name == "Company"){
         this.company = value;
     }
   
}


 connectedCallback(){       
      setTimeout(() => {           
           this.HandleSumbit();     
        }, 300); 
    }

 HandleSumbit(){
     debugger;
  leadCreateForm({firstname:this.firstname,lastname:this.lastname,phone: this.phone,email:this.email,company:this.company})
  .then(result =>{
    if(result !=null){
  alert("SUCCESS")
    }

  
  })
 }
}