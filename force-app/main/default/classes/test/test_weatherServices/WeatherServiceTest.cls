@isTest
public class WeatherServiceTest {
  @isTest
  static void testGetWeatherData() {
    // Define your test data (replace with actual data)
    String latitude = '123.456';
    String longitude = '789.012';

    // Create a mock HTTP response
    HttpCalloutMock mock = new WeatherServiceMock();
    Test.setMock(HttpCalloutMock.class, mock);

    // Call the WeatherService method
    Map<String, String> result = WeatherService.getWeatherData(
      latitude,
      longitude
    );

    // Assert the expected values in the result map
    System.assertEquals('San Francisco', result.get('city'));
    System.assertEquals('72.5', result.get('todayTemp'));
    System.assertEquals('Partly Cloudy', result.get('today_condition_text'));
    System.assertEquals(
      'https://example.com/icons/cloudy.png',
      result.get('today_condition_icon')
    );
    System.assertEquals('80.5', result.get('tomorrowMaxTemp'));
    System.assertEquals('65.0', result.get('tomorrowMinTemp'));
    System.assertEquals(
      'https://example.com/icons/rainy.png',
      result.get('tomorrow_condition_icon')
    );
    System.assertEquals('78.0', result.get('afterTomorrowMaxTemp'));
    System.assertEquals('62.5', result.get('afterTomorrowMinTemp'));
    System.assertEquals(
      'https://example.com/icons/sunny.png',
      result.get('afterTomorrow_condition_icon')
    );
  }

  public class WeatherServiceMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      HTTPResponse res = new HTTPResponse();
      res.setStatusCode(200);
      res.setBody(
        '{"location": {"name": "San Francisco"}, "current": {"temp_c": 72.5, "condition": {"text": "Partly Cloudy", "icon": "https://example.com/icons/cloudy.png"}}, "forecast": {"forecastday": [{"day": {"maxtemp_c": 78.0, "mintemp_c": 62.5, "condition": {"icon": "https://example.com/icons/sunny.png"}}}, {"day": {"maxtemp_c": 80.5, "mintemp_c": 65.0, "condition": {"icon": "https://example.com/icons/rainy.png"}}},{"day": {"maxtemp_c": 78.0, "mintemp_c": 62.5, "condition": {"icon": "https://example.com/icons/sunny.png"}}}]}}'
      );
      return res;
    }
  }
  @isTest
  static void testGetTodayWeatherData() {
    // Create a sample response map to simulate the external API's response
    Map<String, Object> responseMap = new Map<String, Object>();
    Map<String, Object> locationData = new Map<String, Object>();
    locationData.put('name', 'San Francisco');
    responseMap.put('location', locationData);

    Map<String, Object> current = new Map<String, Object>();
    current.put('temp_c', 72.5);

    Map<String, Object> conditionData = new Map<String, Object>();
    conditionData.put('text', 'Partly Cloudy');
    conditionData.put('icon', 'https://example.com/icons/cloudy.png');
    current.put('condition', conditionData);

    responseMap.put('current', current);

    // Call the getTodayWeatherData method
    Map<String, String> result = WeatherService.getTodayWeatherData(
      responseMap
    );

    // Assert the expected values in the result map
    System.assertEquals('San Francisco', result.get('city'));
    System.assertEquals('72.5', result.get('todayTemp'));
    System.assertEquals('Partly Cloudy', result.get('today_condition_text'));
    System.assertEquals(
      'https://example.com/icons/cloudy.png',
      result.get('today_condition_icon')
    );
  }
  @isTest
  static void testGetTomorrowWeatherData() {
    // Create a sample tomorrow map to simulate the external API's response
    Map<String, Object> tomorrow = new Map<String, Object>();
    Map<String, Object> day = new Map<String, Object>();
    day.put('maxtemp_c', 78.0);
    day.put('mintemp_c', 62.5);

    Map<String, Object> conditionData = new Map<String, Object>();
    conditionData.put('icon', 'https://example.com/icons/sunny.png');

    day.put('condition', conditionData);

    tomorrow.put('day', day);

    // Call the getTomorrowWeatherData method
    Map<String, String> result = WeatherService.getTomorrowWeatherData(
      tomorrow
    );

    // Assert the expected values in the result map
    System.assertEquals('78.0', result.get('tomorrowMaxTemp'));
    System.assertEquals('62.5', result.get('tomorrowMinTemp'));
    System.assertEquals(
      'https://example.com/icons/sunny.png',
      result.get('tomorrow_condition_icon')
    );
  }
  @isTest
  static void testGetAfterTomorrowWeatherData() {
    // Create a sample day2 map to simulate the external API's response
    Map<String, Object> day2 = new Map<String, Object>();
    Map<String, Object> day = new Map<String, Object>();
    day.put('maxtemp_c', 80.5);
    day.put('mintemp_c', 65.0);

    Map<String, Object> conditionData = new Map<String, Object>();
    conditionData.put('icon', 'https://example.com/icons/rainy.png');

    day.put('condition', conditionData);

    day2.put('day', day);

    // Call the getAfterTomorrowWeatherData method
    Map<String, String> result = WeatherService.getAfterTomorrowWeatherData(
      day2
    );

    // Assert the expected values in the result map
    System.assertEquals('80.5', result.get('afterTomorrowMaxTemp'));
    System.assertEquals('65.0', result.get('afterTomorrowMinTemp'));
    System.assertEquals(
      'https://example.com/icons/rainy.png',
      result.get('afterTomorrow_condition_icon')
    );
  }
}
