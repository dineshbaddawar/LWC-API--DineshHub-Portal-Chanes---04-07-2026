public class FileExplorerHelper {
    
    // Method to get Opportunity related Documents Category and Its Files.
    @AuraEnabled 
    public static List<Document_Category__c> getDocCateList(String opportunityId){
          List<Document_Category__c> DocCategoryList = new List<Document_Category__c>();
        try{
            if(String.isNotBlank(opportunityId)){
                 DocCategoryList =[SELECT Id, Name,(SELECT Id, Name FROM Document_Files__r) FROM Document_Category__c WHERE Opportunity__c =:opportunityId ORDER BY CreatedDate];
                if(DocCategoryList.size()>0){
                    System.debug('DocCategoryList Record === >'+DocCategoryList);
                    return DocCategoryList;
                }  
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
       return null;
    }
    
    // ============================================================================================================
    // Method for Showing selected documents Preview using Iframe.
    @AuraEnabled
    public static string PreviewPDF(String procDocId){
        try{
            String blobFile;
            Document_File__c appDocAttach = new Document_File__c();
            if(procDocId !=null){
                 appDocAttach = [SELECT id,Name,Attachement_Id__c FROM Document_File__c WHERE id =: procDocId];
                if(appDocAttach != null && appDocAttach.Attachement_Id__c != null){
                    Attachment att = [select id,name,body,contenttype  from attachment where id =: appDocAttach.Attachement_Id__c limit 1];
                    System.debug('att === >'+att);
                    blobFile = EncodingUtil.base64Encode(att.body);
                    System.debug('blobFile == >'+blobFile);
                    return blobFile;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return 'ERROR';
    }

     // ============================================================================================================
    // Method for Uploading File , in selected Folder using Doctemp Name.
    public static string uploadFileInSelectedDocFolder(string folderName,String opportunityId){
        try{
            if(folderName !=null && opportunityId !=null){
                
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
       return null;
    }
}