import 'package:weatherapp/WeatherApp/Api/ApiRequest.dart';
import '../Model/WeatherResponse.dart';

class WeatherRepository {

  final ApiRequest _apiRequest = ApiRequest();


  Future<WeatherResponse> fetchCurrentWeather(String lat, String lon, String params) async {
    dynamic response = await _apiRequest.request(params, lat, lon);
    return WeatherResponse.fromJson(response);
  }

}