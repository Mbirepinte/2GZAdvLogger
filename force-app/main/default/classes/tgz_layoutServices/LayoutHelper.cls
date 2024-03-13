@SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
public with sharing class LayoutHelper {
  @AuraEnabled
  public static String getLayoutFullName(String layoutId) {
    String layoutFullName;
    String UserApiVersion = '57.0';
    String query = '/tooling/sobjects/Layout/';

    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      URL.getOrgDomainUrl().toExternalForm() +
        '/services/data/v' +
        UserApiVersion +
        query +
        layoutId +
        ''
    );
    request.setMethod('GET');
    request.setHeader('Authorization', 'Bearer ' + AuthService.getCredential());
    System.debug(LoggingLevel.DEBUG, 'token ' + AuthService.getCredential());
    request.setHeader('Content-Type', 'application/json');

    Http http = new Http();
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      Map<String, Object> layoutInfo = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      layoutFullName = (String) layoutInfo.get('FullName');
    } else {
      System.debug(
        LoggingLevel.DEBUG,
        request.toString() + response.toString() + '   response'
      );
    }
    System.debug(LoggingLevel.DEBUG, 'getLayoutFullName  ' + layoutFullName);
    return layoutFullName;
  }
}
