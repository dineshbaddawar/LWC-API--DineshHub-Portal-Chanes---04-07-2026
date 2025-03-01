import { LightningElement,wire,api,track } from 'lwc';
import fetchLead from '@salesforce/apex/AuraCompUtilityClas.fetchLead';
import getContactsByEmail from '@salesforce/apex/AuraCompUtilityClas.getContactsByEmail';
import getOpportunityBEmail from '@salesforce/apex/AuraCompUtilityClas.getOpportunityBEmail';
import getAccountByEmail from '@salesforce/apex/AuraCompUtilityClas.getAccountByEmail';

export default class GetDataDisplayData  extends LightningElement {
     @api recordId;
     @track LeadRecord;
     @track leadEmailRec;
     @track leadPhoneRec;
     ContactRecordData = [];
     OpportunityRecordData = [];
     AccountRecordData = [];

     @wire(fetchLead,{recId:'$recordId'})
     wiredResult({data,error}){
          
          console.log("Data Lead Record: ",data);
          console.log("Error",error);

          if(data){
               this.LeadRecord= data;
               debugger;
               var leadEmailRec = this.LeadRecord.Email;

               var leadPhoneRec = this.LeadRecord.Phone;
               this.getContact(leadEmailRec,leadPhoneRec);
               console.log("leadEmail---->",leadEmailRec);
               console.log("leadPhone---->",leadPhoneRec);
          }else if(error){
               console.log("Error");
          }
     }    
     
     // Get Contact Record
  getContact(leadEmailRec,leadPhoneRec){
     getContactsByEmail({emailId: leadEmailRec,conPhone:leadPhoneRec}).
     then(result=>{
          console.log("result--- Contact List:",result);
          this.getOpportunity(leadEmailRec,leadPhoneRec);

 result.forEach(function(contact){
     debugger;
     console.log("contact",contact);
     contact.Url = '/lightning/r/Contact/' + contact.Id+'/view';
     console.log("URL :", contact.Url);
 }

 );
 this.ContactRecordData = result;
     }).catch(error =>{
     console.log("Error in Contact");
     })
  }

  // Get Opportunity Record

getOpportunity(leadEmailRec,leadPhoneRec){
     getOpportunityBEmail({emailId: leadEmailRec, oppPhone: leadPhoneRec}).
     then(result =>{
          console.log("result opp Record :",result);
          this.getAccounts(leadEmailRec,leadPhoneRec);
          result.forEach(function(opp){
               debugger;
               opp.Url= '/lightning/r/Opportunity/' + opp.Id+'/view';
          });
          this.OpportunityRecordData = result;
     }).catch(error =>{
          console.log("Error in Opportunity");
     })
}

// Get Account Record

getAccounts(leadEmailRec,leadPhoneRec){
     getAccountByEmail({emailId : leadEmailRec,accPhone : leadPhoneRec})
     .then(result =>{
          console.log("Account Data---:",result);
          result.forEach(function(acc){
               debugger;
               acc.Url = '/lightning/r/Account/' + acc.Id+'/view';
          });
      this.AccountRecordData = result;
     }).catch(error =>{
          console.log("Error in Account");
     })
}

}