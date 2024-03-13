public with sharing class WeatherService {
  @AuraEnabled(cacheable=true)
  public static Map<String, String> getWeatherData(
    String latitude,
    String longitude
  ) {
    System.debug(
      LoggingLevel.DEBUG,
      '***COORDS***' + latitude + ' ' + longitude
    );
    HttpRequest req = new HttpRequest();
    twogz_credential__c mc = twogz_credential__c.getInstance();
    String API_KEY;
    if (mc.weather_api_key__c == null) {
      System.debug(LoggingLevel.DEBUG, '***NO CREDENTIALS***');
      API_KEY = '3bb01e00b05e4c1aba584110230609';
    } else {
      API_KEY = mc.weather_api_key__c;
    }
    if (latitude == null) {
      latitude = mc.latitude__c;
    }
    if (longitude == null) {
      longitude = mc.longitude__c;
    }
    String endpoint =
      '/forecast.json?q=' +
      latitude +
      ',' +
      longitude +
      '&days=4&key=' +
      API_KEY;
    req.setEndpoint('https://api.weatherapi.com/v1' + endpoint);
    req.setMethod('GET');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    JSONParser parser = JSON.createParser(res.getBody());
    //WeatherData weather = new WeatherData();
    Map<String, String> weather = new Map<String, String>();
    if (res.getStatusCode() == 200) {
      Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      Map<String, Object> forecast = (Map<String, Object>) responseMap.get(
        'forecast'
      );
      List<Object> forecastdayList = (List<Object>) forecast.get('forecastday');
      Map<String, Object> tomorrow = (Map<String, Object>) forecastdayList[1];
      Map<String, Object> day2 = (Map<String, Object>) forecastdayList[2];
      weather.putAll(WeatherService.getTodayWeatherData(responseMap));
      weather.putAll(WeatherService.getTomorrowWeatherData(tomorrow));
      weather.putAll(WeatherService.getAfterTomorrowWeatherData(day2));
      System.debug(LoggingLevel.DEBUG, '***TOMORROW***' + tomorrow);
      System.debug(LoggingLevel.DEBUG, '***DAY2***' + day2);
    } else {
      System.debug(LoggingLevel.DEBUG, 'Error: ' + res.getBody());
    }
    System.debug(LoggingLevel.DEBUG, '***WEATHER***' + weather);
    return weather;
  }

  public static Map<String, String> getTodayWeatherData(
    Map<String, Object> responseMap
  ) {
    Map<String, String> todayWeather = new Map<String, String>();
    Map<String, Object> locationData = (Map<String, Object>) responseMap.get(
      'location'
    );
    todayWeather.put('city', (String) locationData.get('name'));

    Map<String, Object> current = (Map<String, Object>) responseMap.get(
      'current'
    );
    if (current != null) {
      todayWeather.put(
        'todayTemp',
        String.valueOf((Decimal) current.get('temp_c'))
      );
      Map<String, Object> conditionData = (Map<String, Object>) current.get(
        'condition'
      );
      System.debug(LoggingLevel.DEBUG, '***TODAY CONDITION***' + conditionData);
      if (conditionData != null) {
        todayWeather.put(
          'today_condition_text',
          (String) conditionData.get('text')
        );
        todayWeather.put(
          'today_condition_text',
          (String) conditionData.get('text')
        );
        todayWeather.put(
          'today_condition_icon',
          (String) conditionData.get('icon')
        );
      }
    }
    System.debug(LoggingLevel.DEBUG, '***todayWeather***' + todayWeather);
    return todayWeather;
  }

  public static Map<String, String> getTomorrowWeatherData(
    Map<String, Object> tomorrow
  ) {
    Map<String, String> tomorrowWeather = new Map<String, String>();

    Map<String, Object> day = (Map<String, Object>) tomorrow.get('day');
    System.debug(LoggingLevel.DEBUG, '***TOMORROW***' + day);

    tomorrowWeather.put(
      'tomorrowMaxTemp',
      String.valueOf((Decimal) day.get('maxtemp_c'))
    );
    tomorrowWeather.put(
      'tomorrowMinTemp',
      String.valueOf((Decimal) day.get('mintemp_c'))
    );
    Map<String, Object> conditionData = (Map<String, Object>) day.get(
      'condition'
    );
    System.debug(LoggingLevel.DEBUG, '***TOMORROWCONDITION***' + conditionData);
    if (conditionData != null) {
      tomorrowWeather.put(
        'tomorrow_condition_icon',
        (String) conditionData.get('icon')
      );
    }
    System.debug(LoggingLevel.DEBUG, '***tomorrowWeather***' + tomorrowWeather);
    return tomorrowWeather;
  }

  public static Map<String, String> getAfterTomorrowWeatherData(
    Map<String, Object> day2
  ) {
    Map<String, String> afterTomorrowWeather = new Map<String, String>();
    Map<String, Object> day = (Map<String, Object>) day2.get('day');
    System.debug(LoggingLevel.DEBUG, '***afterTomorrow***' + day);

    afterTomorrowWeather.put(
      'afterTomorrowMaxTemp',
      String.valueOf((Decimal) day.get('maxtemp_c'))
    );
    afterTomorrowWeather.put(
      'afterTomorrowMinTemp',
      String.valueOf((Decimal) day.get('mintemp_c'))
    );
    Map<String, Object> conditionData = (Map<String, Object>) day.get(
      'condition'
    );
    System.debug(
      LoggingLevel.DEBUG,
      '***afterTomorrowCONDITION***' + conditionData
    );
    if (conditionData != null) {
      afterTomorrowWeather.put(
        'afterTomorrow_condition_icon',
        (String) conditionData.get('icon')
      );
    }
    System.debug(
      LoggingLevel.DEBUG,
      '***afterTomorrowWeather***' + afterTomorrowWeather
    );
    return afterTomorrowWeather;
  }
}
