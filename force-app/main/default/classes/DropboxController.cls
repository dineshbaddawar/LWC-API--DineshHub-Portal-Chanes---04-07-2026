public class DropboxController {
    
    public static void uploadFileByRecord(string recordId){
        try{
            System.debug('recordId == >'+recordId);
            List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:recordId];
            System.debug('links == >'+links);
            Set<Id> ids=new Set<Id>();
            for(ContentDocumentLink link:links){
                ids.add(link.ContentDocumentId);
            }
            System.debug('ids == >'+ids);
            List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
            System.debug('versions == >'+versions);
            for(ContentVersion attach:versions){
                System.debug('attach == >'+attach);
                string fileUrl=DropboxService.upload(attach);
                System.debug('fileUrl == >'+fileUrl);
                if (string.isNotBlank(fileUrl)) {
                    //Store Information in Object
                    //Will be used for retrieving files
                    Attachment fileStore=new Attachment();
                    fileStore.Body=blob.valueof(fileUrl);
                    fileStore.Name=attach.Title+'.'+  attach.FileExtension.toLowerCase();
                    fileStore.parentId=recordId;
                    insert fileStore;
                    System.debug('fileStore == >'+fileStore);
                }
            }
        }
        catch(Exception e){
            System.debug('Error Message ===> '+e.getMessage()+' && Error Line == >'+e.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static List<ContentVersion> getCurrentRecordConverList(string recordId){
        List<ContentDocumentLink> linksList = new List<ContentDocumentLink>();
        Set<Id> ContentDocumentIdSet=new Set<Id>();
        List<ContentVersion> contentversionsList = new List<ContentVersion>();
        List<ContentVersion> GetAllcontentversionsList = new List<ContentVersion>();
        try{
            if(recordId !=null){
                linksList=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:recordId];
                if(!linksList.isEmpty()){
                    for(ContentDocumentLink link:linksList){
                        if(link.ContentDocumentId !=null){
                            ContentDocumentIdSet.add(link.ContentDocumentId);   
                        }
                    }
                    if(ContentDocumentIdSet.size()>0){
                        contentversionsList =[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ContentDocumentIdSet AND IsLatest = true];
                        if(contentversionsList.size()>0){
                            System.debug('Record related Document');
                            return contentversionsList;
                        }else{
                            System.debug('No Record Found');
                            return GetAllcontentversionsList = [SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion];
                        }
                    }
                }
            }            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
}