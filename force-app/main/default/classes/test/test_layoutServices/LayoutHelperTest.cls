@isTest
private class LayoutHelperTest {
  @isTest
  static void testGetLayoutFullName_Success() {
    // Create a mock response for successful layout retrieval
    HttpMock mock = new HttpMock();
    mock.respond('{"FullName": "mock_layout_name"}', 200);

    // Set the mock for the HttpCalloutMock interface
    Test.setMock(HttpCalloutMock.class, mock);

    // Call the method to test
    String layoutId = 'someLayoutId';
    String layoutFullName = LayoutHelper.getLayoutFullName(layoutId);

    // Verify that the layout full name is retrieved correctly
    System.assertEquals('mock_layout_name', layoutFullName);
  }

  // Mock class for simulating HTTP callouts
  private class HttpMock implements HttpCalloutMock {
    private String response;
    private Integer statusCode;

    public HttpMock() {
    }

    public void respond(String responseBody, Integer responseStatus) {
      response = responseBody;
      statusCode = responseStatus;
    }

    public HTTPResponse respond(HTTPRequest request) {
      HTTPResponse res = new HTTPResponse();
      res.setBody(response);
      res.setStatusCode(statusCode);
      return res;
    }
  }
}
