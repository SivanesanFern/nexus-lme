public with sharing class FinancialReportController {
    public Application__c app { get; set; }
    
    // Aggregate Totals
    public Decimal totalMonthlyIncome { get; set; }
    public Decimal totalEstimatedAssets { get; set; }
    public Decimal totalMonthlyLiabilities { get; set; }
    public Decimal totalOutstandingDebt { get; set; }
    
    // Record Lists for the Detailed Tables
    public List<Income__c> incomes { get; set; }
    public List<Asset__c> assets { get; set; }
    public List<Liability__c> liabilities { get; set; }
    
    // Ratios
    public Decimal dtiRatio { get; set; }
    public Decimal assetLiabilityRatio { get; set; }

    public FinancialReportController() {
        totalMonthlyIncome = 0.00;
        totalEstimatedAssets = 0.00;
        totalMonthlyLiabilities = 0.00;
        totalOutstandingDebt = 0.00;
        dtiRatio = 0.00;
        assetLiabilityRatio = 0.00;

        Id appId = ApexPages.currentPage().getParameters().get('id');
        
        if (appId != null) {
            app = [SELECT Id, Name, Account__r.Name, Loan_Amount_Requested__c, Purpose__c, Status__c 
                   FROM Application__c WHERE Id = :appId LIMIT 1];

            calculateTotals(appId);
            calculateRatios();
        }
    }

    private void calculateTotals(Id appId) {
        // Fetch and Sum Incomes
        incomes = [SELECT Income_Source__c, Monthly_Amount__c FROM Income__c WHERE Application__c = :appId];
        for (Income__c inc : incomes) {
            if (inc.Monthly_Amount__c != null) totalMonthlyIncome += inc.Monthly_Amount__c;
        }

        // Fetch and Sum Assets
        assets = [SELECT Asset_Type__c, Estimated_Value__c FROM Asset__c WHERE Application__c = :appId];
        for (Asset__c ast : assets) {
            if (ast.Estimated_Value__c != null) totalEstimatedAssets += ast.Estimated_Value__c;
        }

        // Fetch and Sum Liabilities
        liabilities = [SELECT Liability_Type__c, Monthly_Payment__c, Amount_Owed__c FROM Liability__c WHERE Application__c = :appId];
        for (Liability__c liab : liabilities) {
            if (liab.Monthly_Payment__c != null) totalMonthlyLiabilities += liab.Monthly_Payment__c;
            if (liab.Amount_Owed__c != null) totalOutstandingDebt += liab.Amount_Owed__c;
        }
    }

    private void calculateRatios() {
        if (totalMonthlyIncome > 0) {
            dtiRatio = (totalMonthlyLiabilities / totalMonthlyIncome) * 100;
            dtiRatio = dtiRatio.setScale(2);
        } else {
            dtiRatio = null;
        }

        if (totalMonthlyLiabilities > 0) {
            assetLiabilityRatio = totalEstimatedAssets / totalMonthlyLiabilities;
            assetLiabilityRatio = assetLiabilityRatio.setScale(2);
        } else {
            assetLiabilityRatio = null;
        }
    }
}