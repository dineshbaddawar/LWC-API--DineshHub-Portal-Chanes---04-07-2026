import { LightningElement } from 'lwc';
import getAddress from '@salesforce/apex/SearchApiAddressController.getAddress';
import getAddressDetailsByPlaceId from '@salesforce/apex/SearchApiAddressController.getPlaceDetails';

export default class SearchGoogleMapAPIAddress extends LightningElement {
     addressRecommendations = [];
     selectedAddress = '';
     addressDetail = {};
     city;
     country;
     pincode;
     state;

     get hasRecommendations() {
          return (this.addressRecommendations !== null && this.addressRecommendations.length);
     }

     handleChange(event) {
          debugger;
          event.preventDefault();
          let searchText = event.target.value;
          if (searchText) this.getAddressRecommendations(searchText);
          else this.addressRecommendations = [];
      }
     
     getAddressRecommendations(searchText) {
          debugger;
          getAddress({ searchString: searchText })
              .then(response => {
                  let addressRecommendations = [];
                  response.forEach(prediction => {
                      addressRecommendations.push({
                          main_text: prediction.AddComplete,
                          secondary_text: prediction.AddComplete,
                          place_id: prediction.placeId,
                      });
                  });
                  this.addressRecommendations = addressRecommendations;
              }).catch(error => {
                  console.log('error : ' + JSON.stringify(error));
              });
     }
     
     resetAddress() {
          debugger;
          this.city = '';
          this.country = '';
          this.pincode = '';
          this.state = '';
     }
     
     handleAddressRecommendationSelect(event) {
          debugger;
          event.preventDefault();
          let placeId = event.currentTarget.dataset.value;
          this.addressRecommendations = [];
          this.selectedAddress = '';
          this.resetAddress();
           
   
          getAddressDetailsByPlaceId({ placeId: placeId })
              .then(response => {
                  response = JSON.parse(response);
                  response.result.address_components.forEach(address => {
                      let type = address.types[0];
                      switch (type) {
                          case 'locality':
                              this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                              this.city = address.long_name;
                              break;
                          case 'country':
                              this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                              this.country = address.long_name;
                              break;
                          case 'administrative_area_level_1':
                              this.selectedAddress = this.selectedAddress + ' ' + address.short_name;
                              this.state = address.short_name;
                              break;
                          case 'postal_code':
                              this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                              this.pincode = address.long_name;
                              break;
                          case 'sublocality_level_2':
                              this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                              this.addressDetail.subLocal2 = address.long_name;
                              break;
                          case 'sublocality_level_1':
                              this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                              this.addressDetail.subLocal1 = address.long_name;
                              break;
                          case 'street_number':
                              this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                              this.addressDetail.streetNumber = address.long_name;
                              break;
                          case 'route':
                              this.selectedAddress = this.selectedAddress + ' ' + address.short_name;
                              this.addressDetail.route = address.short_name;
                              break;
                          default:
                              break;
                      }
                  });
              })
              .catch(error => {
                  console.log('error : ' + JSON.stringify(error));
              });
      }
}