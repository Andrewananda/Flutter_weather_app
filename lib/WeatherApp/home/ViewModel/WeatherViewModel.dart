import 'package:flutter/cupertino.dart';
import 'package:weatherapp/WeatherApp/Api/WeatherAppState.dart';
import 'package:weatherapp/WeatherApp/home/Model/WeatherResponse.dart';
import 'package:weatherapp/WeatherApp/home/WeatherRepository/WeatherRepository.dart';


class WeatherViewModel with ChangeNotifier {

  late WeatherAppState _weatherAppState = WeatherAppState.initial('Initialized from viewModel');

  WeatherAppState get weatherAppState {
    return _weatherAppState;
  }


  Future<void> fetchWeather(String lat, String lon, String params) async {

    _weatherAppState = WeatherAppState.loading('Fetching current weather');
    notifyListeners();

    try {
      WeatherResponse weatherResponse = await WeatherRepository().fetchCurrentWeather(lat, lon, params);
      _weatherAppState = WeatherAppState.completed(weatherResponse);
    } catch(e) {
      _weatherAppState = WeatherAppState.error(e.toString());
    }

    notifyListeners();


  }


}