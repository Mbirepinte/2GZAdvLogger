public with sharing class LogHelper {
  @SuppressWarnings
  @AuraEnabled
  public static String insertInLog(
    String layoutFullName,
    String userId,
    String layoutObject
  ) {
    if (layoutFullName == null || userId == null || layoutObject == null) {
      return 'error';
    }
    System.debug(
      LoggingLevel.DEBUG,
      'layoutFullName in loghelper: ' + layoutFullName
    );
    System.debug(LoggingLevel.DEBUG, 'userId in loghelper: ' + userId);
    System.debug(
      LoggingLevel.DEBUG,
      'layoutObject in loghelper: ' + layoutObject
    );
    try {
      Tgz_log__c log = new Tgz_log__c();
      if (
        !Schema.sObjectType.Tgz_log__c.fields.LayoutFullName__c.isUpdateable() ||
        !Schema.sObjectType.Tgz_log__c.fields.User_Id__c.isUpdateable() ||
        !Schema.sObjectType.Tgz_log__c.fields.LayoutObject__c.isUpdateable() ||
        !Schema.sObjectType.Tgz_log__c.fields.LayoutFullName__c.isCreateable() ||
        !Schema.sObjectType.Tgz_log__c.fields.User_Id__c.isCreateable() ||
        !Schema.sObjectType.Tgz_log__c.fields.LayoutObject__c.isCreateable()
      ) {
        System.debug(LoggingLevel.DEBUG, 'Error: fields not updateable');
        return null;
      }
      log.LayoutFullName__c = layoutFullName;
      log.User_Id__c = userId;
      log.LayoutObject__c = layoutObject;
      insert log;
    } catch (DMLException e) {
      System.debug(LoggingLevel.DEBUG, 'Error: ' + e.getMessage());
    }
    return 'success';
  }
}
