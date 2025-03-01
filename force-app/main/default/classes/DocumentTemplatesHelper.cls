global class DocumentTemplatesHelper {
    
    public String blobData {
        get {
            try{
                return EncodingUtil.Base64Encode(docWrapperInstance.blobFile);
            }catch(Exception e){
                return '';
            }
        }
    }
    public docWrapper docWrapperInstance{get;set;}
    public DocumentTemplatesHelper() {
        viewPDF();
    }
    
    @RemoteAction
    global static List<DocumentTreeWrapper> getDocuments(String oppId) {
        if(String.isBlank(oppId))
            return null;
        Map<Id,DocumentTreeWrapper> uiWrapper = new Map<Id,DocumentTreeWrapper>();
        List<Document_Template__c> docList=  [Select id,Name from Document_Template__c where Opportunity__c =:oppId];
        System.debug('docList size === >'+docList.size());
        String Obj = '';
        if(docList.size() > 0){
            for(Document_Template__c appDoc : [SELECT Id, Name,(SELECT Id, Name FROM Documents_Attachment__r) FROM Document_Template__c WHERE Opportunity__c =:oppId ORDER BY CreatedDate]) {
                DocumentTreeWrapper appDocWrapper;
                appDocWrapper = new DocumentTreeWrapper(appDoc.Id, appDoc.Name); 
                if(!appDoc.Documents_Attachment__r.isEmpty()){
                    for(Documents_Attachment__c appAttachment : appDoc.Documents_Attachment__r) {
                        appDocWrapper.childNodes.add(new DocumentTreeWrapper(appAttachment.Id, appAttachment.Name));
                    }
                }
                uiWrapper.put(appDoc.Id, appDocWrapper);
            }
        }
        system.debug('uiWrapper'+uiWrapper);
        return uiWrapper.values();
    }
    
    public void viewPDF(){
        String appDocId = Apexpages.currentPage().getParameters().get('attachId');
        system.debug('appDocId ==>'+appDocId);
        docWrapperInstance = new docWrapper();
        Documents_Attachment__c appDocAttach = new Documents_Attachment__c();
        if(appDocId != null){
            appDocAttach = [SELECT id,Name,Attachement_Id__c FROM Documents_Attachment__c WHERE id =: appDocId];
            system.debug('appDocAttach ==>'+appDocAttach);
            if(appDocAttach != null && appDocAttach.Attachement_Id__c != null){
                try{
                    if(!String.isBlank(appDocAttach.Attachement_Id__c)){
                        System.debug('Attachement ID ==>'+appDocAttach.Attachement_Id__c);
                        Attachment att = [select id,name,body,contenttype  from attachment where id =: appDocAttach.Attachement_Id__c limit 1];
                        docWrapperInstance.contentType = att.contenttype;
                        docWrapperInstance.blobFile = att.body;
                    }
                }catch(Exception e){
                    System.debug('Error ==>'+e.getMessage() + ' && Error Line ==>'+e.getLineNumber());
                }
            }
        }else{
            docWrapperInstance = new docWrapper();
            docWrapperInstance.contentType = 'application/';
            docWrapperInstance.blobFile = blob.valueOf('');
        }
    }
    
    global class DocumentTreeWrapper {
        public String documentID;
        public String documentName;
        public List<DocumentTreeWrapper> childNodes = new List<DocumentTreeWrapper>();
        
        public DocumentTreeWrapper(String documentID, String documentName) {
            this.documentID = documentID;
            this.documentName = documentName;
        }
    }
    
    global class docWrapper{
        public String contentType{get;set;}
        public blob blobFile{get;set;}
    }
    
    @RemoteAction
    public static string deleteSelectedDocFile(String docAttRecordId){
        System.debug('docAttRecordId === >'+docAttRecordId);
        Documents_Attachment__c DocAttToDelete = new Documents_Attachment__c();
        try{
            if(String.isNotBlank(docAttRecordId)){
                DocAttToDelete = [SELECT Id,Name,Attachement_Id__c FROM Documents_Attachment__c WHERE ID=:docAttRecordId];
                if(String.isNotBlank(DocAttToDelete.Attachement_Id__c)){
                    delete DocAttToDelete;
                    System.debug('DocAttToDelete == >'+DocAttToDelete); 
                    return 'SUCCESS'; 
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    @RemoteAction
    global static string uploadDocumentAttchement(String doctempId,String conVerionId){
         System.debug('doctempId == >'+doctempId+' && conVerionId == >'+conVerionId);
        ContentVersion conVerRec = new ContentVersion();
        Documents_Attachment__c docAttInsert = new Documents_Attachment__c();
        try{
            if(doctempId !=null && conVerionId !=null){
                conVerRec = [SELECT ContentBodyId,ContentDocumentId,FileExtension,FileType,Id,Title FROM ContentVersion WHERE Id=:conVerionId LIMIT 1];
                System.debug('conVerRec == >'+conVerRec); 
                if(conVerRec !=null){
                    Attachment att=new Attachment();
                    att.Body=conVerRec.VersionData;
                    att.Name=conVerRec.Title;
                    att.ContentType =conVerRec.FileType;
                    att.parentId=doctempId;
                    insert att;
                    System.debug('att == >'+att);
                    if(att !=null){
                        docAttInsert.Name = att.Name;
                        docAttInsert.Attachement_Id__c = att.Id;
                        docAttInsert.Document_Template__c = doctempId;
                        insert docAttInsert;
                        System.debug('docAttInsert == >'+docAttInsert);
                        if(docAttInsert !=null){
                            return String.valueOf(docAttInsert);
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