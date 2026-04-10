// Seed the Default Org-Wide Custom Setting for Nexus LME
Loan_Configuration__c orgDefaults = Loan_Configuration__c.getOrgDefaults();

// Check if it already exists to prevent duplicates
if (orgDefaults.Id == null) {
    orgDefaults.Default_Interest_Rate__c = 5.00;
    insert orgDefaults;
    System.debug('✅ Success: Loan Configuration set to 5.00%');
} else {
    System.debug('⚠️ Notice: Loan Configuration already exists.');
}