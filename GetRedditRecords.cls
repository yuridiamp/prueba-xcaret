public with sharing class GetRedditRecords {
    
    @AuraEnabled(cacheable=true)
    public static List<Reddit_Item__c> getRedditItems() {
        return [SELECT Title__c, Author__c, Thumbnail__c, Selftext__c FROM Reddit_Item__c];
    }

}