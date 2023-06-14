public class SaveRedditData {

    public static final String ENDPOINT = 'https://www.reddit.com/r/subreddit/new.json?sort=new';

    public Boolean startProcess(){
        String redditJSON = sendRequest();
        Boolean recordsSaved = saveRecords(redditJSON);
        return recordsSaved;
    }

    public String sendRequest(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }

    public Boolean saveRecords(String redditJSON){
        
        List<Reddit_Item__c> items = new List<Reddit_Item__c>();
        Boolean gotNewItems = false;

        Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(redditJSON);
        Map<String,Object> obj2 = (Map<String,Object>) obj.get('data');
        List<Object> obj3 = (List<Object>) obj2.get('children');

        for (Object o : obj3){
            Map<String,Object> obj4 = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(o));
            Map<String,Object> obj5 = (Map<String,Object>) obj4.get('data');
            
            Reddit_Item__c newItem = new Reddit_Item__c (
                Title__c = (String)obj5.get('title'),
                Author__c = (String)obj5.get('author_fullname'),
                Thumbnail__c = (String)obj5.get('thumbnail'),
                Selftext__c = (String)obj5.get('selftext')
            );
            
            items.add(newItem);
        }
      	
        if (items.size() > 0) {
            gotNewItems = true;
        }
        
        insert items;

        return gotNewItems;
    }

}