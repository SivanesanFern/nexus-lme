import { LightningElement, api, wire } from 'lwc';
import getFieldStatus from '@salesforce/apex/ApplicationHealthController.getFieldStatus';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DataChecklist extends LightningElement {
    @api recordId;
    wiredResult;
    missingFields = [];
    completedFields = [];
    hasToasted = false;

    @wire(getFieldStatus, { recordId: '$recordId' })
    wiredStatus(result) {
        this.wiredResult = result;
        if (result.data) {
            const all = Object.keys(result.data).map(key => ({
                label: key,
                isPopulated: result.data[key]
            }));
            this.missingFields = all.filter(f => !f.isPopulated);
            this.completedFields = all.filter(f => f.isPopulated);

            if(this.missingFields.length > 0 && !this.hasToasted){
                this.showWarningToast();
                this.hasToasted = true;
            }
        }
    }

    handleRefresh() {
        return refreshApex(this.wiredResult);
    }

    get hasMissingFields(){
        return this.missingFields.length > 0;
    }

    showWarningToast() {
        const event = new ShowToastEvent({
            title: 'Action Required',
            message: 'Some required fields are missing. Please check the {0} component.',
            messageData: [
                {
                    url: '#checklist-live',
                    label: 'Data Completion Checklist'
                }
            ],
            variant: 'warning',
            mode: 'dismissible'
        });
        this.dispatchEvent(event);
    }
}
