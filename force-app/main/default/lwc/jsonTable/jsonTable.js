import { LightningElement,api } from 'lwc';

export default class JsonTable extends LightningElement {
    @api jsonData;
    @api docTempName;
    Namedoc;
    hidePindCodeSeriveValue = true;
    hideOutOfStock = true;
    hidecourierDeliveryIssue = true;
    hidelostinTransit = true;
    hideRTOOrder = true;
    showRefundTable = false;
}