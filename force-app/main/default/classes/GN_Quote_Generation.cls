public with sharing class GN_Quote_Generation {

    @AuraEnabled
    public static String generateAndAttachQuotePdf(Id quoteId) {
        if (quoteId == null) {
            throw new AuraHandledException('Quote Id is required.');
        }

        try {
            PageReference pdfPage = Page.GN_QuoteTemplateVf;
            pdfPage.getParameters().put('id', quoteId);

            Blob pdfBody = Test.isRunningTest()
                ? Blob.valueOf('Test PDF')
                : pdfPage.getContentAsPDF();

            return createQuotePdfAttachment(quoteId, pdfBody);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static String createQuotePdfAttachment(Id quoteId, Blob pdfBody) {
        Quote quoteRecord = [
            SELECT Id, Name
            FROM Quote
            WHERE Id = :quoteId
            LIMIT 1
        ];

        String safeName = String.isBlank(quoteRecord.Name)
            ? 'Quote'
            : quoteRecord.Name.replaceAll('[^a-zA-Z0-9 _-]', '');

        String fileName = safeName + '_Quote.pdf';

        ContentVersion newVersion = new ContentVersion(
            Title = safeName,
            PathOnClient = fileName,
            VersionData = pdfBody,
            FirstPublishLocationId = quoteRecord.Id
        );

        insert newVersion;
        return newVersion.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> getQuoteLines(Id quoteId) {
        if (quoteId == null) {
            return new List<QuoteLineItem>();
        }

        return [
            SELECT
                Id,
                QuoteId,
                Product2.Name,
                Quantity,
                UnitPrice,
                ListPrice,
                Discount,
                TotalPrice
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId
            ORDER BY CreatedDate
        ];
    }
}