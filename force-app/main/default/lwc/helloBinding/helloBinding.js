import { LightningElement,track } from 'lwc';

export default class HelloBinding extends LightningElement {

     @track greeting = '';
     @track fullname = '';
     @track email = 'dineshbaddawar@gmail.com';
     handleChange(event){
          this.greeting = event.target.value;
          console.log("this value----"+this.greeting);
     }

     nameChange(event){
          this.fullname = event.target.value;
     }

     emailChange(event){
          this.email = event.target.value;
     }
}