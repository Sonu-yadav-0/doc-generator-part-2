public class FilteredSections {

    public static List<Section__c> getsectionRecords(Id quoteTemplateId, Id quoteId, User u){

        return [SELECT
    Id,
    Name,
    Type__c,
    Quote_Template__c,
    Annexure__c,
    Section_Alignment__c,
    Display_Order__c,
    Page_Break__c,
    Show_Header__c,
    Content__c,
    Content_Line_Spacing__c,
    Image_Name__c,
    Image_Width__c,
    Image_Height__c,
    QRCode_Image_Name__c,
    Product_Specification_Row_Spacing__c,
    Sort_By_Parameter__c,
    Table_Object__c,
    QuoteLineItem_Filter__c,
    Section_Related_Base_Product__c,
    Section_Related_Base_Product__r.Component_Type__c
FROM Section__c
WHERE Quote_Template__c = :quoteTemplateId
ORDER BY Display_Order__c ASC
        ];
    }
}