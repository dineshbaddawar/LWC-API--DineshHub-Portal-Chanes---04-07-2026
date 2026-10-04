import { LightningElement, track, api,wire } from 'lwc';
import profilepic from '@salesforce/resourceUrl/profilepic';
import settingsIcon from '@salesforce/resourceUrl/settingsIcon';
import getContactHashCode from '@salesforce/apex/LoginController.getContactHashCode';
import getLogOut from '@salesforce/apex/LoginController.getLogOut';
import getComponentList from '@salesforce/apex/LoginController.getComponentList';
export default class Dinehsdevhomesitepage extends LightningElement {
    @track activeMenu = 'lwc';
    @api recordId;
    profilepic = profilepic;
    userName = 'John Doe';
    settingsIcon = settingsIcon;
    @track showSettingsMenu = false;
    @track compdata;
    @track lwclistdata = [];
    @track apexlistdata = [];
    @track auralistdata = [];
    @track vfpagelistdata = [];
    @track selectedComp;
    @track snapshotImageUrl;
    @track showDetails = false;
    @track showImagePreview = false;

    connectedCallback() {
        this.recordId = this.recordId;
        this.fetchContactHashCode();
        this.getcompdata();
    }

    fetchContactHashCode() {
        debugger;
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

    getcompdata() {
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
        this.showDetails = false;
        this.selectedComp = undefined;
        this.snapshotImageUrl = undefined;
        this.showImagePreview = false;
    }

    handleNameClick(event) {
        event.preventDefault();
        const recordId = event.currentTarget.dataset.id;
        const allComponents = [
            ...this.lwclistdata,
            ...this.apexlistdata,
            ...this.auralistdata,
            ...this.vfpagelistdata
        ];
        this.selectedComp = allComponents.find(component => component.Id === recordId);
        const snapshot = this.selectedComp?.SanpShot__c || '';
        const imageSource = snapshot.match(/<img[^>]*\bsrc=["']([^"']+)["']/i)?.[1]
            || snapshot.match(/^\s*(https?:\/\/[^\s"']+|\/[^\s"']+)/i)?.[1];

        this.snapshotImageUrl = imageSource
            ? imageSource.replace(/&amp;/g, '&')
            : undefined;
        this.showDetails = true;
    }

    handleBackToList() {
        this.showDetails = false;
        this.selectedComp = undefined;
        this.snapshotImageUrl = undefined;
        this.showImagePreview = false;
    }

    handleOpenImagePreview() {
        this.showImagePreview = true;
    }

    handleCloseImagePreview() {
        this.showImagePreview = false;
    }

    handleImageBackdropClick(event) {
        if (event.target === event.currentTarget) {
            this.handleCloseImagePreview();
        }
    }

    handlePreviewDialogClick(event) {
        event.stopPropagation();
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

    get lwcClass() {
        return this.getActiveClass('lwc');
    }

    get apexClass() {
        return this.getActiveClass('apex');
    }

    get auraClass() {
        return this.getActiveClass('aura');
    }

    get vfClass() {
        return this.getActiveClass('vf');
    }

    get moreClass() {
        return this.getActiveClass('more');
    }

    getActiveClass(menu) {
        return this.activeMenu === menu ? 'active' : '';
    }

    handleSettingsClick() {
        this.showSettingsMenu = !this.showSettingsMenu;
    }

    handleSettingsOptionClick(event) {
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
    async handleLogout() {
        const showLogoutToast = (title, message, backgroundColor) => {
            const toast = document.createElement('div');
            toast.innerHTML = `<strong>${title}</strong><br><span>${message}</span>`;
            Object.assign(toast.style, {
                position: 'fixed',
                top: '24px',
                right: '24px',
                zIndex: '9999',
                padding: '14px 18px',
                color: '#ffffff',
                backgroundColor,
                borderRadius: '8px',
                boxShadow: '0 8px 24px rgba(0, 0, 0, 0.25)',
                fontSize: '13px',
                lineHeight: '1.5'
            });
            this.template.querySelector('.container').appendChild(toast);
        };

        try {
            const result = await getLogOut({ sessionKey: this.recordId });
            if (result === 'success') {
                showLogoutToast('Logout successful', 'You have been logged out successfully.', '#167c68');
                setTimeout(() => {
                    window.location.href = 'https://utilitarianlabs-apiorg-dev-ed.my.salesforce-sites.com/';
                }, 1800);
            } else {
                showLogoutToast('Logout failed', 'Unable to log out. Please try again.', '#a6423e');
            }
        } catch (error) {
            console.error('Logout error:', error);
            showLogoutToast('Logout failed', 'Something went wrong while logging out.', '#a6423e');
        }
    }
}