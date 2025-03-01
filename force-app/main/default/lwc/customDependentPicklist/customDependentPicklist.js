import { LightningElement, wire, track } from 'lwc';
import fetchDependentPicklistValues from '@salesforce/apex/LWCUtilityHelper.fetchDependentPicklistValues';
export default class CustomDependentPicklist extends LightningElement {
    @track typeDependentPicklistWrapperArray;
    @track typeOptions;
    @track ratingOptions;
    @track industryOptions;
    selectedTypeValue;
    selectedRatingValue;
    selectedIndustryValue;
    @wire(fetchDependentPicklistValues, {})
    wiredFetchDependentPicklistValues({ error, data }) {
        if (data) {
            debugger;
            try {
                this.typeDependentPicklistWrapperArray = JSON.parse(data);
                let options = [];
                for (var key in JSON.parse(data)) {
                    options.push({ label: key, value: key });
                }
                this.typeOptions = options;
                this.ratingOptions = undefined;
                this.industryOptions = undefined;
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
    }

    handleTypeChange(event) {
          debugger;
        try {
            this.selectedRatingValue = undefined;
            this.selectedIndustryValue = undefined;
            this.ratingOptions = undefined;
            this.industryOptions = undefined;
            let options = [];
            this.selectedTypeValue = event.detail.value;
            if (this.typeDependentPicklistWrapperArray) {
                for (var key in this.typeDependentPicklistWrapperArray) {
                    if (this.selectedTypeValue === key) {
                        for (var subkey in this.typeDependentPicklistWrapperArray[key]) {
                            for (var childkey in this.typeDependentPicklistWrapperArray[key][subkey]) {
                                options.push({ label: childkey, value: childkey });
                            }
                        }
                        break;
                    }
                }
                options = options.filter((thing, index) => {
                    const _thing = JSON.stringify(thing);
                    return index === options.findIndex(obj => {
                        return JSON.stringify(obj) === _thing;
                    });
                });
                this.ratingOptions = options;
            }
        } catch (error) {
            console.error('check error here', error);
        }

    }

    handleRatingChange(event) {
          debugger;
        try {
            this.selectedIndustryValue = undefined;
            this.industryOptions = undefined;
            let options = [];
            this.selectedRatingValue = event.detail.value;
            if (this.typeDependentPicklistWrapperArray) {
                for (var key in this.typeDependentPicklistWrapperArray) {
                    if (this.selectedTypeValue === key) {
                        for (var subkey in this.typeDependentPicklistWrapperArray[key]) {
                            for (var childkey in this.typeDependentPicklistWrapperArray[key][subkey]) {
                                if (this.selectedRatingValue === childkey) {
                                    for (var grandchildkey in this.typeDependentPicklistWrapperArray[key][subkey][childkey]) {
                                        options.push({ label: this.typeDependentPicklistWrapperArray[key][subkey][childkey][grandchildkey], value: this.typeDependentPicklistWrapperArray[key][subkey][childkey][grandchildkey] });
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                options = options.filter((thing, index) => {
                    const _thing = JSON.stringify(thing);
                    return index === options.findIndex(obj => {
                        return JSON.stringify(obj) === _thing;
                    });
                });
                this.industryOptions = options;
            }
        } catch (error) {
            console.error('check error here', error);
        }

    }

    handleIndustryChange(event) {
          debugger;
        this.selectedIndustryValue = event.detail.value;
    }
}