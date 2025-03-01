import { LightningElement,wire } from 'lwc';
import getProfileUserMap from '@salesforce/apex/ProfileUserController.getProfileUserMap';

export default class ProfileUserComponent extends LightningElement {
  selectedProfile = '';
    selectedUser = '';
    profileOptions = [];
    userOptions = [];
    userOptionsNew = [];
    jsondata;

    @wire(getProfileUserMap)
    wiredProfileUserMap({ data, error }) {
        if (data) {
            this.jsondata = data;
            var options = [];
             for (var key in data) {
                options.push({ label: key, value: key });
            }
           this.profileOptions = options;
            this.userOptions = [];
        } else if (error) {
            console.error('Error fetching profile user map', error);
        }
    }

    handleProfileChange(event) {
      //  debugger;
        this.selectedProfile = event ? event.detail.value : this.selectedProfile;
        this.getRecordsByKey(this.selectedProfile);
    }
    handleUserNameChange(event){
        debugger;
        this.selectedUser = event ? event.detail.value : this.selectedUser;
    }

    getRecordsByKey(key){
        debugger;
        this.userOptions = this.jsondata[key] || [];
        var options1 = [];
             for (var key in this.userOptions) {
                options1.push({ label: this.userOptions[key].Name, value: this.userOptions[key].Id });
            }
            this.userOptionsNew = options1;
    }
}