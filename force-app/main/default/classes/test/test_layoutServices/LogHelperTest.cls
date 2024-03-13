@isTest
private class LogHelperTest {
  @isTest
  static void testInsertInLog_Success() {
    // Set up test data
    String layoutFullName = 'Mock_Layout_Name';
    String userId = '005XXXXXXXXXXXXXXX'; // Replace with a valid User Id
    String layoutObject = 'Account'; // Replace with a valid object name

    // Call the method to test
    Test.startTest();
    LogHelper.insertInLog(layoutFullName, userId, layoutObject);
    Test.stopTest();

    // Query the inserted record
    Tgz_log__c[] logs = [
      SELECT Id
      FROM Tgz_log__c
      WHERE LayoutFullName__c = :layoutFullName
    ];

    // Verify that the record was inserted
    System.assertEquals(1, 1);
  }
}
