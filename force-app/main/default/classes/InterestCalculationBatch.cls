public with sharing class InterestCalculationBatch implements Database.Batchable<SObject> {

    @InvocableMethod(label='Run Daily Interest Batch' description='Executes the daily interest calculation batch job')
    public static void calculateDailyInterest() {
        Database.executeBatch(new InterestCalculationBatch());
    }

     public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Current_Balance__c, Interest_Rate__c, Total_Interest__c FROM Financial_Account__c WHERE Current_Balance__c > 0 AND Interest_Rate__c > 0');
    }

     public void execute (Database.BatchableContext BC, List<Financial_Account__c> scope) {
        List<Financial_Account__c> accountsToUpdate = new List<Financial_Account__c>();
        for (Financial_Account__c fa : scope) {
            Decimal currentBalance = fa.Current_Balance__c != null ? fa.Current_Balance__c : 0;
            Decimal interestRate = fa.Interest_Rate__c != null ? fa.Interest_Rate__c : 0;
            fa.Total_Interest__c += calculateDailyInterest(currentBalance, interestRate);
            accountsToUpdate.add(fa);
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    private Decimal calculateDailyInterest(Decimal balance, Decimal rate) {
        return balance * (rate / 100) / 365;
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Interest calculation batch job completed.');
    }
}