import { LightningElement, api, track } from 'lwc';

export default class DynamicFinancialsForm extends LightningElement {
    @track _incomeRecords = [];
    @track _assetRecords = [];
    @track _liabilityRecords = [];

    @api get incomeRecords() {
        return this._incomeRecords.filter(rec => rec.Income_Source__c || rec.Monthly_Amount__c);
    }
    set incomeRecords(value) { this._incomeRecords = value ? [...value] : []; }

    @api get assetRecords() {
        return this._assetRecords.filter(rec => rec.Asset_Type__c || rec.Estimated_Value__c || rec.Description__c);
    }
    set assetRecords(value) { this._assetRecords = value ? [...value] : []; }

    @api get liabilityRecords() {
        return this._liabilityRecords.filter(rec => rec.Liability_Type__c || rec.Amount_Owed__c || rec.Monthly_Payment__c);
    }
    set liabilityRecords(value) { this._liabilityRecords = value ? [...value] : []; }

    activeSections = ['Income', 'Assets', 'Liabilities'];

    
    connectedCallback() {
        if (this._incomeRecords.length === 0) this.addIncome();
        if (this._assetRecords.length === 0) this.addAsset();
        if (this._liabilityRecords.length === 0) this.addLiability();
    }

    // --- ADD METHODS ---
    addIncome() {
        const newRow = { uid: Math.random().toString(36), sobjectType: 'Income__c', Income_Source__c: '', Monthly_Amount__c: null };
        this._incomeRecords = [...this._incomeRecords, newRow];
    }

    addAsset() {
        const newRow = { uid: Math.random().toString(36), sobjectType: 'Asset__c', Asset_Type__c: '', Estimated_Value__c: null, Description__c: '' };
        this._assetRecords = [...this._assetRecords, newRow];
    }

    addLiability() {
        const newRow = { uid: Math.random().toString(36), sobjectType: 'Liability__c', Liability_Type__c: '', Amount_Owed__c: null, Monthly_Payment__c: null };
        this._liabilityRecords = [...this._liabilityRecords, newRow];
    }

    // --- REMOVE METHODS ---
    removeIncome(event) {
        this._incomeRecords = this._incomeRecords.filter((_, i) => i !== Number(event.currentTarget.dataset.index));
    }
    removeAsset(event) {
        this._assetRecords = this._assetRecords.filter((_, i) => i !== Number(event.currentTarget.dataset.index));
    }
    removeLiability(event) {
        this._liabilityRecords = this._liabilityRecords.filter((_, i) => i !== Number(event.currentTarget.dataset.index));
    }

    // --- CHANGE HANDLERS ---
    handleIncomeChange(event) {
        let index = event.currentTarget.dataset.index;
        let field = event.currentTarget.dataset.field;
        this._incomeRecords[index][field] = event.target.value;
    }

    handleAssetChange(event) {
        let index = event.currentTarget.dataset.index;
        let field = event.currentTarget.dataset.field;
        this._assetRecords[index][field] = event.target.value;
    }

    handleLiabilityChange(event) {
        let index = event.currentTarget.dataset.index;
        let field = event.currentTarget.dataset.field;
        this._liabilityRecords[index][field] = event.target.value;
    }

    // --- PICKLIST OPTIONS ---
    get assetTypeOptions() {
        return [
            { label: 'Real Estate', value: 'Real Estate' }, { label: 'Vehicle', value: 'Vehicle' },
            { label: 'Savings', value: 'Savings' }, { label: 'Investments', value: 'Investments' }
        ];
    }

    get liabilityTypeOptions() {
        return [
            { label: 'Mortgage', value: 'Mortgage' }, { label: 'Auto Loan', value: 'Auto Loan' },
            { label: 'Credit Card', value: 'Credit Card' }, { label: 'Personal Loan', value: 'Personal Loan' }
        ];
    }
}