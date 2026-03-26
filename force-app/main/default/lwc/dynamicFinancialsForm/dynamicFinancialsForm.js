import { LightningElement, api } from 'lwc';

export default class DynamicFinancialsForm extends LightningElement {
    @api incomeRecords = [];
    @api assetRecords = [];
    @api liabilityRecords = [];

    activeSections = ['Income', 'Assets', 'Liabilities'];

    // Add logics
    addIncome() {
        const newIncome = { sobjectType: 'Income__c', Income_Source__c: '', Monthly_Amount__c: null };
        this.incomeRecords = [...this.incomeRecords, newIncome];
    }

    addAsset() {
        const newAsset = { sobjectType: 'Assets__c', Asset_Type__c: '', Estimated_Value__c: null, Description__c: '' };
        this.assetRecords = [...this.assetRecords, newAsset];
    }

    addLiability() {
        const newLiability = { sobjectType: 'Liabilities__c', Liability_Type__c: '', Amount_Owed: null, Monthly_Payment__c: null };
        this.liabilityRecords = [...this.liabilityRecords, newLiability];
    }

    // Remove logics
    removeIncome(event) {
        let index = event.currentTarget.dataset.index;
        this.incomeRecords.splice(index, 1);
        this.incomeRecords = [...this.incomeRecords];
    }

    removeAsset(event) {
        let index = event.currentTarget.dataset.index;
        this.assetRecords.splice(index, 1);
        this.assetRecords = [...this.assetRecords];
    }

    removeLiability(event) {
        let index = event.currentTarget.dataset.index;
        this.liabilityRecords.splice(index, 1);
        this.liabilityRecords = [...this.liabilityRecords];
    }

    //Dynamic inputs
    handleIncomeChange(event) {
        let index = event.currentTarget.dataset.index;
        let field = event.currentTarget.dataset.field;
        this.incomeRecords[index][field] = event.currentTarget.value;
    }

    handleAssetChange(event) {
        let index = event.currentTarget.dataset.index;
        let field = event.currentTarget.dataset.field;
        this.assetRecords[index][field] = event.currentTarget.value;
    }

    handleLiabilityChange(event) {
        let index = event.currentTarget.dataset.index;
        let field = event.currentTarget.dataset.field;
        this.liabilityRecords[index][field] = event.currentTarget.value;
    }

    //Picklist
    get assetTypeOptions() {
        return [
            { label: 'Real Estate', value: 'Real Estate' },
            { label: 'Vehicle', value: 'Vehicle' },
            { label: 'Savings', value: 'Savings' },
            { label: 'Investments', value: 'Investments' }
        ];
    }

    get liabilityTypeOptions() {
        return [
            { label: 'Mortgage', value: 'Mortgage' },
            { label: 'Auto Loan', value: 'Auto Loan' },
            { label: 'Credit Card', value: 'Credit Card' },
            { label: 'Personal Loan', value: 'Personal Loan' }
        ];
    }

}