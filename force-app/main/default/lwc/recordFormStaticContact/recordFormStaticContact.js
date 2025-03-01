import { LightningElement,api } from 'lwc';
import AccountId_Field from '@salesforce/schema/Contact.AccountId';
import Name_Field from  '@salesforce/schema/Contact.Name';
import Tile_Field from '@salesforce/schema/Contact.Title';
import Email_Field from '@salesforce/schema/Contact.Email';
import Phone_Field from '@salesforce/schema/Contact.Phone';

export default class RecordFormStaticContact extends LightningElement {
     // Flexipage provides RecordId & ObjectApi Name
     @api recordId;
     @api objectApiName;

     fieldSet = [AccountId_Field,Name_Field,Tile_Field,Email_Field,Phone_Field];
}