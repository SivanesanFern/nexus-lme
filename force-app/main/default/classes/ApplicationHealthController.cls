public with sharing class ApplicationHealthController {
    @AuraEnabled(cacheable = true)
    public static Map<String, Boolean> getFieldStatus(Id recordId) {
        Map<String, Boolean> statusMap = new Map<String, Boolean>();

        List<Schema.FieldSetMember> fieldSetMembers = SObjectType.Application__c.FieldSets.JSON_Required_Fields.getFields();

        String query = 'SELECT Id';
        for(Schema.FieldSetMember f : fieldSetMembers){
            query += ', ' + f.getFieldPath();
        }
        query += ' FROM Application__c WHERE Id = :recordId LIMIT 1';

        Application__c app = Database.query(query);

        for(Schema.FieldSetMember f : fieldSetMembers){
            String apiName = f.getFieldPath();
            String label = f.getLabel();

            Object value = app.get(apiName);
            Boolean isPopulated = (value != null & String.valueOf(value) != '');

            statusMap.put(label, isPopulated);
        }

        return statusMap;
    }
}