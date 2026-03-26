@isTest
public with sharing class InterestCalculationBatchTest {
    
    @TestSetup
    static void setupTestData() {
        // 1. Create a parent Account
        Account acc = new Account(Name = 'Test Borrower');
        insert acc;

        // 2. Create Financial Accounts
        List<Financial_Account__c> finAccs = new List<Financial_Account__c>();
        for (Integer i = 0; i < 3; i++) {
            finAccs.add(new Financial_Account__c(
                Account__c = acc.Id, 
                Interest_Rate__c = 5.00, 
                Total_Interest__c = 0
            ));
        }
        insert finAccs;

        // 3. Create "Disburse" Transactions to populate the Roll-up Summary field
        List<Transaction__c> trans = new List<Transaction__c>();
        for (Financial_Account__c fa : finAccs) {
            trans.add(new Transaction__c(
                Financial_Account__c = fa.Id,
                Amount__c = 10000,
                Type__c = 'Disburse'
            ));
        }
        insert trans;
    }

    @isTest
    static void testBatchExecution() {
        
        Test.startTest();
        InterestCalculationBatch.calculateDailyInterest();
        Test.stopTest();

        // 4. Verify the results
        List<Financial_Account__c> updatedAccounts = [SELECT Current_Balance__c, Interest_Rate__c, Total_Interest__c FROM Financial_Account__c];
        for (Financial_Account__c fa : updatedAccounts) {
            Decimal expectedInterest = (fa.Current_Balance__c * (fa.Interest_Rate__c / 100)) / 365;
            System.assertNotEquals(0, fa.Total_Interest__c, 'Interest should have been added to the field.');
            System.assertEquals(expectedInterest.setScale(2), fa.Total_Interest__c.setScale(2), 'The interest calculation math is incorrect.');
        }
    }
}