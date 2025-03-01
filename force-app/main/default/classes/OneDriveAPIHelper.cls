/**
* @author Dinesh Baddawar
* @email dinesh.butilitarianlab@gmail.com
* @create date 2024-11-28 18:46:04
* @modify date 2024-11-28 18:46:04
*  @desc [OneDrive Helper Class for Creating Folder,Uploading File & Deleting File]
*/

public without sharing class OneDriveAPIHelper {
    
    // Method for get Access Token
    public static String getAccessToken() {
        String accessToken;
        try {
            String endpoint = 'https://login.microsoftonline.com/common/oauth2/token';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            String body = 'grant_type=password'
                + '&client_id=' + EncodingUtil.urlEncode('c397f4c2-c3ce-4526-a36e-fbbf7a8e566a', 'UTF-8')
                + '&client_secret=' + EncodingUtil.urlEncode(System.Label.client_secretOneDrive, 'UTF-8')
                + '&resource=' + EncodingUtil.urlEncode('https://graph.microsoft.com', 'UTF-8')
                + '&username=' + EncodingUtil.urlEncode(System.Label.OneDriveUsername, 'UTF-8')
                + '&password=' + EncodingUtil.urlEncode(System.Label.OneDrivePassword, 'UTF-8');
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                accessToken = (String) resultMap.get('access_token');
            } else {
                String errorMsg = 'Error: ' + res.getStatusCode() + ' ' + res.getStatus() + ' Response: ' + res.getBody();
                System.debug('Error Details === >'+errorMsg);
            }
        } catch (Exception e) {
            // ExceptionHelper.createExceptionLog(e);
        }
        return accessToken;
    }
    
    public static Map<String, Map<String, String>> AllFolderWithNameId(String responseBody) {
        Map<String, Map<String, String>> folderMap = new Map<String, Map<String, String>>();
        try {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            List<Object> items = (List<Object>) resultMap.get('value');
            for (Object item : items) {
                Map<String, Object> itemMap = (Map<String, Object>) item;
                String id = (String) itemMap.get('id');
                String name = (String) itemMap.get('name');
                 String createdDate = (String) itemMap.get('createdDateTime');

                  Map<String, String> folderDetails = new Map<String, String>();
                   folderDetails.put('id', id);
                    folderDetails.put('createdDateTime', createdDate);

               folderMap.put(name, folderDetails);
            }
        } catch (Exception e) {
            System.debug('Error parsing response: ' + e.getMessage());
            // ExceptionHelper.createExceptionLog(e);
        }
        return folderMap;
    }
    
    // Method for getting All the Folder name with their id
    @AuraEnabled
    public static Map<String, Map<String, String>> getAllFolderDetails() {
        try{
            String endpoint = 'https://graph.microsoft.com/v1.0/me/drive/root/children?$select=id,name,createdDateTime';
            String accessToken=getAccessToken();
            accessToken='Bearer '+accessToken;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', accessToken);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            Http http = new Http();

            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                String responseBody = res.getBody();
                Map<String, Map<String, String>> folderMap = AllFolderWithNameId(responseBody);
                System.debug('folderMap == > ' + folderMap);
                return folderMap;
            } else {
                String errorMsg = 'Error: ' + res.getStatusCode() + ' ' + res.getStatus() + ' Response: ' + res.getBody();
                System.debug(errorMsg);
            }
        }catch(Exception e){
            System.debug('Get Folder Repositories==>'+e);
            // ExceptionHelper.createExceptionLog(e);
        }
        return null;
    }
    
    // Method for Creating Folder
    @AuraEnabled
    public static String CreateFolder(String folderName){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'https://graph.microsoft.com/v1.0/me/drive/root/children';
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + getAccessToken());
            String body = '{"name": "' + folderName + '", "folder": {}, "@microsoft.graph.conflictBehavior": "rename"}';
            request.setBody(body);
            HttpResponse response = http.send(request); 
            System.debug('Response details == >'+response);
            if (response.getStatusCode() == 201 && response.getStatus() == 'Created') {
                return 'SUCCESS';
            } else {
                return 'Error == > ' + response.getStatusCode() + ' - ' + response.getBody();
            }
        }catch(Exception e){
            System.debug('Error Message ==>'+e.getMessage()+' && Error Line == >'+e.getLineNumber());
            // ExceptionHelper.createExceptionLog(e);
        }
        return null;
    } 
    
    // Method for Deleting Folder
    @AuraEnabled
    public static String DeleteFolder(String folderId){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'https://graph.microsoft.com/v1.0/me/drive/items/'+folderId;
            request.setEndpoint(endpoint);
            request.setMethod('DELETE');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + getAccessToken());
            request.setBody('{}');
            HttpResponse response = http.send(request); 
            System.debug('Response details == >'+response);
            if (response.getStatusCode() == 204) {  
                return 'SUCCESS';
            } else {
                return 'Error == > ' + response.getStatusCode() + ' - ' + response.getBody();
            }
        }catch(Exception e){
            System.debug('Error Message ==>'+e.getMessage()+' && Error Line == >'+e.getLineNumber());
            // ExceptionHelper.createExceptionLog(e);
        }
        return null;
    } 

    // Method for Uploading File in Folder
    @AuraEnabled
    public static String uploadFileToOneDrive(String folderPathParam, String fileNameParam, Blob fileBody) {
        try {
            String folderPath = EncodingUtil.urlEncode(folderPathParam, 'UTF-8');
            String fileName = EncodingUtil.urlEncode(fileNameParam, 'UTF-8');
            String endpoint = 'https://graph.microsoft.com/v1.0/me/drive/root:/' + folderPath + '/' + fileName + ':/content';        
            System.debug('endpoint URL == >'+endpoint);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/octet-stream');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + getAccessToken());
            request.setBodyAsBlob(fileBody);
            HttpResponse response = http.send(request);
            System.debug('Response == > ' + response);
            if (response.getStatusCode() == 201 || response.getStatusCode() == 200) {
                return 'File uploaded successfully Response === > ' + response.getBody();
            } else {
                return 'Error == ' + response.getStatusCode() + ' - ' + response.getBody();
            }
        } catch (Exception e) {
            System.debug('Error Message ==>' + e.getMessage() + ' && Error Line == >' + e.getLineNumber());
            //  ExceptionHelper.createExceptionLog(e);
        }
        return null;
    }
    
    // Method for getting Drive Details
    public static String getDriveDetails(){
        try{
            String endPoint = 'https://graph.microsoft.com/v1.0/me/drives';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + getAccessToken());
            HttpResponse response = http.send(request);
            System.debug('Response == >'+response);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('jsonMap == >'+jsonMap);
                List<Map<String, Object>> valueList = (List<Map<String, Object>>) jsonMap.get('value');
                if (!valueList.isEmpty()) {
                    String driveId = (String) valueList[0].get('id');
                    System.debug('driveId == > ' + driveId);
                    return driveId;
                }
            }
        }catch(Exception e){
            System.debug('Error Message =>'+e+' && Error Line = >'+e.getLineNumber());
        }
        return null;
    }
    
    // Method for Deleting File or Folder by Passing Folder or File Id
    @AuraEnabled 
    public static string deleteFileOrFolder(String driveId, String itemId){
        try{
            
        }catch(Exception e){
            System.debug('Error Message =>'+e+' && Error Line = >'+e.getLineNumber());
            // ExceptionHelper.createExceptionLog(e);
        }
        return null;
    }
    
    // Method to get All Files From Folder by Passing the Folder Id
    @AuraEnabled
    public static String getAllFilesFromFolder(String folderId){
        try{
            String endPoint = 'https://graph.microsoft.com/v1.0/me/drive/items/'+ folderId +'/children';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + getAccessToken());
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('parsedJson == >'+parsedJson);
                List<Object> files = (List<Object>) parsedJson.get('value');
                List<Map<String, String>> fileDetailsList = new List<Map<String, String>>();
                for (Object fileObj : files) {
                    Map<String, Object> fileMap = (Map<String, Object>) fileObj;
                System.debug('fileMap #1 == >'+fileMap);

                    String downloadUrl = (String) fileMap.get('@microsoft.graph.downloadUrl');
                    String fileName = (String) fileMap.get('name');
                    String fileId = (String) fileMap.get('id');
                    System.debug('fileName == >'+fileName+' && Id = >'+fileId);

                    Map<String, String> fileDetails = new Map<String, String>();
                    fileDetails.put('fileurl', downloadUrl);
                    fileDetails.put('filename', fileName);
                    fileDetails.put('fileid', fileId);

                    String createdDate = (String) fileMap.get('createdDateTime');
                    Long fileSize = (Long) fileMap.get('size');
                 //   String mimeType = (String) fileMap.get('file') != null ? (String) ((Map<String, Object>) fileMap.get('file')).get('mimeType') : '';
                    fileDetails.put('createdDateTime', createdDate);
                    fileDetails.put('size', String.valueOf(fileSize));
                  //  fileDetails.put('mimeType', mimeType);
                    fileDetailsList.add(fileDetails);
                }
                String jsonOutput = JSON.serialize(fileDetailsList);
                System.debug('JSON Output === >'+jsonOutput);
                if(jsonOutput !=null){
                    System.debug('Result == > '+jsonOutput);
                    return jsonOutput;
                } else{
                    System.debug('Result: '+'No Files Found' );
                    return null;
                }
            }
        }catch(Exception e){
            System.debug('Error Message =>'+e+' && Error Line = >'+e.getLineNumber());
        }
        return null;
    }
    
}