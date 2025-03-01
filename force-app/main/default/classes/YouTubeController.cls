public with sharing class YouTubeController {
    private static final String SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search';
    private static final String API_KEY = 'AIzaSyAPWOnnHpA4OEwle5ens5UEZDMfDnQ-nBM'; 
    
    // Method for Getting Videos based on Search Text
    @AuraEnabled(cacheable=true)
    public static list<mywrapper> getYTVideos(string searchKey){
        searchKey = searchKey == null ? 'salesforce' : searchKey;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Httpresponse res = null;
        String endpoint  = SEARCH_URL +'?part=snippet' +'&maxResults=20' +'&type=video' +'&q=' + EncodingUtil.urlEncode(searchKey, 'UTF-8') +'&key=' + API_KEY;
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        res = http.send(req);
        
        YouTubeResult.Response response = (YouTubeResult.Response)JSON.deserialize(res.getBody(), YouTubeResult.Response.class);
        System.debug('response === >'+response);
        List<YouTubeResult.Item> items  =  response.items;
        System.debug('items response === >'+items[0]);
        //Filling Wrapper Data for lightning component
        List<mywrapper> wrp  = new List<mywrapper>();
        for (YouTubeResult.Item itemObj : items) {
            mywrapper YTWrap = new mywrapper();
            YTWrap.videoId = itemObj.id.videoId;
            YTWrap.description = itemObj.Snippet.description;
            YTWrap.thumbnails = itemObj.Snippet.thumbnails.medium.url;
            YTWrap.title = itemObj.Snippet.title;
            YTWrap.channelTitle = itemObj.Snippet.channelTitle;
            wrp.add(YTWrap);
        }
        return wrp;
    }
    
    // Method for getting Vidos Comments by Passing VideoId
    public static String getVideoComments(String videoId) {
        String EndPoint =  'https://youtube.googleapis.com/youtube/v3/commentThreads?part=snippet,replies&videoId='+videoId+'&key='+API_KEY;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(EndPoint);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            System.debug('Response === >'+response.getBody());
            Map<String,Map<String,String>> mapOfChannelIdVideoIdDisplayComment = new Map<String,Map<String,String>>();
            Map<String,String> mapOfVieoIdtextOriginal = new Map<String,String>();
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Integer> mapOfVideoIdVideoLikecount = new Map<String,Integer>();
            List<Object> items = (List<Object>) jsonMap.get('items'); 
            for (Object item : items) {
                Map<String, Object> itemMap = (Map<String, Object>) item;
                Map<String, Object> snippet = (Map<String, Object>) itemMap.get('snippet');
                Map<String, Object> topLevelComment = (Map<String, Object>) snippet.get('topLevelComment');
                
                System.debug('topLevelComment === >'+topLevelComment);
                
                Map<String, Object> commentSnippet = (Map<String, Object>) topLevelComment.get('snippet');
                mapOfVieoIdtextOriginal = new Map<String,String>();
                mapOfVideoIdVideoLikecount = new Map<String,Integer>();
                mapOfVideoIdVideoLikecount.put((String) commentSnippet.get('videoId'),(Integer) commentSnippet.get('likeCount'));
                mapOfVieoIdtextOriginal.put((String) commentSnippet.get('videoId'),(String) commentSnippet.get('textOriginal'));
                mapOfChannelIdVideoIdDisplayComment.put((String) topLevelComment.get('id'),mapOfVieoIdtextOriginal);
            }
            system.debug('mapOfVieoIdtextOriginal 1 === >'+mapOfVieoIdtextOriginal);
            system.debug('mapOfVideoIdVideoLikecount 3 === >'+mapOfVideoIdVideoLikecount);
            system.debug('mapOfChannelIdVideoIdDisplayComment 2 === >'+mapOfChannelIdVideoIdDisplayComment);
            return response.getBody();
        } else if(response.getStatusCode() == 400){
            System.debug('Status code === >'+response.getStatus()); 
        }
        return 'Error: ' + response.getStatusCode() + ' - ' + response.getStatus();
    }
    
    /* JSON BODY FOR -getVideoComments
     {
  "kind": "youtube#commentThreadListResponse",
  "etag": "W19ifghcJ-EhkhJGhflcrJjrzDk",
  "pageInfo": {
    "totalResults": 2,
    "resultsPerPage": 20
  },
  "items": [
    {
      "kind": "youtube#commentThread",
      "etag": "pQVxzY_9e_YuQrz9gA3aqv_YGdM",
      "id": "UgyPvohG06-BynSYIyB4AaABAg",
      "snippet": {
        "channelId": "UCTRNZ6a2_arSrBvoStNK7OA",
        "videoId": "M1ZzUuveVIM",
        "topLevelComment": {
          "kind": "youtube#comment",
          "etag": "l6lH6XdqOxwHKpbf1FmVjkxayuI",
          "id": "UgyPvohG06-BynSYIyB4AaABAg",
          "snippet": {
            "channelId": "UCTRNZ6a2_arSrBvoStNK7OA",
            "videoId": "M1ZzUuveVIM",
            "textDisplay": "Awsome Video",
            "textOriginal": "Awsome Video",
            "authorDisplayName": "@dineshbaddawar8151",
            "authorProfileImageUrl": "https://yt3.ggpht.com/ydVGmm3srUHEtny1HmA0tg_rzURgZdywc_inQHhFthUFBAaksqkv4o9W47tH3cBF0HhtYt3N=s48-c-k-c0x00ffffff-no-rj",
            "authorChannelUrl": "http://www.youtube.com/channel/UCTRNZ6a2_arSrBvoStNK7OA",
            "authorChannelId": {
              "value": "UCTRNZ6a2_arSrBvoStNK7OA"
            },
            "canRate": true,
            "viewerRating": "none",
            "likeCount": 0,
            "publishedAt": "2023-12-29T10:15:44Z",
            "updatedAt": "2023-12-29T10:15:44Z"
          }
        },
        "canReply": true,
        "totalReplyCount": 0,
        "isPublic": true
      }
    },
    {
      "kind": "youtube#commentThread",
      "etag": "QaxD3DaeHkfG2P414Pon4pFDFJE",
      "id": "Ugw7w6vw1nXgVD-cXt94AaABAg",
      "snippet": {
        "channelId": "UCTRNZ6a2_arSrBvoStNK7OA",
        "videoId": "M1ZzUuveVIM",
        "topLevelComment": {
          "kind": "youtube#comment",
          "etag": "2wUkRHd1_Px3XOuIkJNqOj0ZDDQ",
          "id": "Ugw7w6vw1nXgVD-cXt94AaABAg",
          "snippet": {
            "channelId": "UCTRNZ6a2_arSrBvoStNK7OA",
            "videoId": "M1ZzUuveVIM",
            "textDisplay": "nice",
            "textOriginal": "nice",
            "authorDisplayName": "@dineshbaddawar8151",
            "authorProfileImageUrl": "https://yt3.ggpht.com/ydVGmm3srUHEtny1HmA0tg_rzURgZdywc_inQHhFthUFBAaksqkv4o9W47tH3cBF0HhtYt3N=s48-c-k-c0x00ffffff-no-rj",
            "authorChannelUrl": "http://www.youtube.com/channel/UCTRNZ6a2_arSrBvoStNK7OA",
            "authorChannelId": {
              "value": "UCTRNZ6a2_arSrBvoStNK7OA"
            },
            "canRate": true,
            "viewerRating": "none",
            "likeCount": 0,
            "publishedAt": "2022-03-31T17:50:30Z",
            "updatedAt": "2022-03-31T17:50:30Z"
          }
        },
        "canReply": true,
        "totalReplyCount": 0,
        "isPublic": true
      }
    }
  ]
}
     */ 
    
    // Method for getting Videos like count by passing videoId
    public static String getVideoLikeDisLikeCount(String videoId) {
        String EndPoint =  'https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id='+videoId+'&key='+API_KEY;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(EndPoint);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) { 
            System.debug('Response === >'+response.getBody()); 
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Map<String,String>> mapOfVideoIdLike_DisLikeCount = new Map<String,Map<String,String>>();
            Map<String,String> mapOfLikeCountDislikeCount = new Map<String,String>();
            List<Object> items = (List<Object>) jsonMap.get('items'); 
            System.debug('items == >'+items);
            for (Object item : items) { 
                mapOfLikeCountDislikeCount = new Map<String,String>();
                Map<String, Object> itemMap = (Map<String, Object>) item;
                Map<String, Object> statistics = (Map<String, Object>) itemMap.get('statistics');
                String dislikeCount =  (String) statistics.get('dislikeCount') != null ? (String) statistics.get('dislikeCount') : '0';

                mapOfLikeCountDislikeCount.put((String) statistics.get('likeCount'),dislikeCount);
                mapOfVideoIdLike_DisLikeCount.put((String) itemMap.get('id'),mapOfLikeCountDislikeCount);
            }
            System.debug('mapOfLikeCountDislikeCount == >'+mapOfLikeCountDislikeCount);
            System.debug('mapOfVideoIdLike_DisLikeCount == >'+mapOfVideoIdLike_DisLikeCount);
            return response.getBody();
        }else{
            System.debug('Status code === >'+response.getStatus()+' && Error == >'+response.getStatusCode());
        }
        return null; 
    }
    
    /* JSON BODY FOR - getVideoLikeDisLikeCount
     {
  "kind": "youtube#videoListResponse",
  "etag": "KqwqM4k2w0xgWPaZibyqMs1kKqE",
  "items": [
    {
      "kind": "youtube#video",
      "etag": "du5hK7_n4zdn6dm5UKJ2VzWjNSk",
      "id": "M1ZzUuveVIM",
      "statistics": {
        "viewCount": "97",
        "likeCount": "14",
        "dislikeCount": "0",
        "favoriteCount": "0",
        "commentCount": "2"
      }
    }
  ],
  "pageInfo": {
    "totalResults": 1,
    "resultsPerPage": 1
  }
}
     */ 
    
    public class mywrapper{
        @AuraEnabled public string videoId {get;set;}
        @AuraEnabled public string description {get;set;}
        @AuraEnabled public String thumbnails {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public String channelTitle {get;set;}
        @AuraEnabled public String publishedAt  {get;set;}
    }
}