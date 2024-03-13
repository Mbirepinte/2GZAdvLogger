public with sharing class AuthService {
  public static String getCredential() {
    twogz_credential__c mc = twogz_credential__c.getInstance();
    Map<String, String> request = new Map<String, String>();
    request.put('client_id', mc.client_Id__c);
    request.put('client_secret', mc.client_Secret__c);
    //request.put('username', mc.username__c);
    //request.put('password', mc.password__c + mc.access_token__c);
    request.put('grant_type', 'client_credentials');
    String mapString = String.valueOf(request)
      .replace(',', '&')
      .replace(' ', '')
      .replace('{', '')
      .replace('}', '');

    System.debug(LoggingLevel.DEBUG, 'Request String ' + mapString);

    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.setEndpoint(
      URL.getOrgDomainUrl().toExternalForm() + '/services/oauth2/token'
    );
    /*   if (mc.isProduction__c) {
      req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
    } else {
      req.setEndpoint('https://test.salesforce.com/services/oauth2/token');
    } */
    req.setBody(mapString);

    Http http = new Http();
    HTTPResponse response = http.send(req);
    String accessToken = '';
    if (response.getStatusCode() == 200) {
      Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      accessToken = (String) responseMap.get('access_token');
      System.debug(LoggingLevel.DEBUG, 'get Token ok');
    } else {
      accessToken = response.getBody();
      System.debug(LoggingLevel.DEBUG, 'Error: ' + response.toString());
    }
    return accessToken;
  }
}
