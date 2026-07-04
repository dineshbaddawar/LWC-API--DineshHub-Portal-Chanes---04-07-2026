import { LightningElement, track, api,wire } from 'lwc';
import userIcon from '@salesforce/resourceUrl/UserIcon';
import settingsIcon from '@salesforce/resourceUrl/settingsIcon';
import getContactHashCode from '@salesforce/apex/LoginController.getContactHashCode';
import getLogOut from '@salesforce/apex/LoginController.getLogOut';
import getComponentList from '@salesforce/apex/LoginController.getComponentList';
export default class Dinehsdevhomesitepage extends LightningElement {
    @track activeMenu = 'lwc';
    @api recordId;
    userIcon = userIcon;
    userName = 'John Doe';
    settingsIcon = settingsIcon;
    @track showSettingsMenu = false;
    @track compdata;
    @track lwclistdata = [];
    @track apexlistdata = [];
    @track auralistdata = [];
    @track vfpagelistdata = [];

    connectedCallback() {
        debugger;
        console.log('record ==== >'+this.recordId);
        this.recordId = this.recordId;
        this.fetchContactHashCode();
        this.getcompdata();
    }

    fetchContactHashCode() {
        debugger;
         console.log('record 1 ==== >'+this.recordId);
        getContactHashCode({ hashcode: this.recordId })
            .then(result => {
                 console.log('result ==== >'+result);
                this.hashCode = result;
                console.log('Hash Code:', this.hashCode);
            })
            .catch(error => {
                console.error('Error fetching hash code:', error);
            });
    }

    getSrNo(index) {
        return index + 1;
    }

    // getcompdata(){
    //     debugger;
    //     getComponentList()
    //         .then(result => {
    //             this.compdata = result;

    //             if(this.compdata.lwcList.length>0){
    //                 this.lwclistdata = this.compdata.lwcList;
    //             }

    //             if(this.compdata.apexList.length>0){
    //                 this.apexlistdata = this.compdata.apexList;
    //             }

    //             if(this.compdata.auraList.length>0){
    //                 this.auralistdata = this.compdata.auraList;
    //             }

    //             if(this.compdata.vfList.length>0){
    //                 this.vfpagelistdata = this.compdata.vfList;
    //             }

    //             console.log('compdata ==== >'+this.compdata);
    //         })
    //         .catch(error => {
    //             console.error('Error fetching component list:', error);
    //         });
    // }

    getcompdata() {
        debugger;
        getComponentList()
            .then(result => {
                this.compdata = result;
    
                if (this.compdata.lwcList.length > 0) {
                    this.lwclistdata = this.compdata.lwcList.map((item, index) => ({
                        ...item,
                        srNo: index + 1
                    }));
                }
    
                if (this.compdata.apexList.length > 0) {
                    this.apexlistdata = this.compdata.apexList.map((item, index) => ({
                        ...item,
                        srNo: index + 1
                    }));
                }
    
                if (this.compdata.auraList.length > 0) {
                    this.auralistdata = this.compdata.auraList.map((item, index) => ({
                        ...item,
                        srNo: index + 1
                    }));
                }
    
                if (this.compdata.vfList.length > 0) {
                    this.vfpagelistdata = this.compdata.vfList.map((item, index) => ({
                        ...item,
                        srNo: index + 1
                    }));
                }
    
                console.log('compdata ==== >', this.compdata);
            })
            .catch(error => {
                console.error('Error fetching component list:', error);
            });
    }
    

    handleMenuClick(event) {
        this.activeMenu = event.currentTarget.dataset.type;
    }

    get isLwcActive() {
        return this.activeMenu === 'lwc';
    }

    get isApexActive() {
        return this.activeMenu === 'apex';
    }

    get isAuraActive() {
        return this.activeMenu === 'aura';
    }

    get isVfActive() {
        return this.activeMenu === 'vf';
    }

    get isMoreActive() {
        return this.activeMenu === 'more';
    }

    getActiveClass(menu) {
        return this.activeMenu === menu ? 'active' : '';
    }

    handleSettingsClick() {
        this.showSettingsMenu = !this.showSettingsMenu;
    }
    handleSettingsOptionClick(event) {
        debugger;
       const selectedOption = event.target.dataset.option.trim(); // Trim spaces
       console.log('Selected Option:', `"${selectedOption}"`); // Logs exact value

        switch (selectedOption) {
            case 'profile':
                this.handleProfileDetails();
                break;
            case 'personal':
                this.handlePersonalDetails();
                break;
            case 'upload':
                this.handleUploadPhoto();
                break;
            case 'logout':
                this.handleLogout();
                break;
            default:
                console.log('Invalid option selected');
        }
    }

    handleProfileDetails() {
        console.log('Profile Details clicked');
        // Add your logic here
    }

    handlePersonalDetails() {
        console.log('Personal Details clicked');
        // Add your logic here
    } 

    handleUploadPhoto() {
        console.log('Upload Photo clicked');
        // Add your logic here
    }
    handleLogout() {
        debugger;
        console.log('Logout Successful');
        window.location.href = 'https://utilitarianlabs-apiorg-dev-ed.my.salesforce-sites.com/';
        // getLogOut({hashcode : this.recordId})
        //     .then(result => {
        //         console.log('Logout successful:', result);
        //         if (result === 'success') {
        //             window.location.href = 'https://utilitarianlabs-apiorg-dev-ed.my.salesforce-sites.com/';
        //         }
        //     })
        //     .catch(error => {       
        //         console.error('Error during logout:', error);
        //     });
    }
}