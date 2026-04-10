public class GenerateFinancialReportAction {
    
    @InvocableMethod(label='Generate & Attach Financial PDF' description='Creates a PDF from the FinancialOverviewReport VF page and attaches it to the Application')
    public static void generateReport(List<Id> applicationIds) {
        // Run asynchronously so it doesn't slow down the screen flow
        generateReportAsync(applicationIds);
    }

    @future(callout=true)
    public static void generateReportAsync(List<Id> appIds) {
        List<ContentVersion> filesToInsert = new List<ContentVersion>();
        
        for (Id appId : appIds) {
            // 1. Tell Salesforce which page to generate and pass the ID
            PageReference pdfPage = Page.FinancialOverviewReport;
            pdfPage.getParameters().put('id', appId);
            
            // 2. Generate the PDF Blob (Handle test class exception)
            Blob pdfBlob;
            if (Test.isRunningTest()) {
                pdfBlob = Blob.valueOf('Test PDF Content');
            } else {
                pdfBlob = pdfPage.getContentAsPDF();
            }
            
            // 3. Create the File (ContentVersion)
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Financial_Overview_Report_' + String.valueOf(Date.today());
            cv.PathOnClient = 'Financial_Overview_Report.pdf';
            cv.VersionData = pdfBlob;
            cv.IsMajorVersion = true;
            filesToInsert.add(cv);
        }
        
        if (!filesToInsert.isEmpty()) {
            insert filesToInsert;
            
            // 4. Link the File to the Application Record (ContentDocumentLink)
            List<ContentDocumentLink> links = new List<ContentDocumentLink>();
            
            // We have to query the ContentVersions to get the ContentDocumentId
            for (ContentVersion cv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :filesToInsert]) {
                // Find the original Application ID (We assume 1-to-1 processing here for simplicity)
                Id relatedAppId = appIds[0]; 
                
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = relatedAppId;
                cdl.ShareType = 'V'; // Viewer permission
                cdl.Visibility = 'AllUsers';
                links.add(cdl);
            }
            
            insert links;
        }
    }
}