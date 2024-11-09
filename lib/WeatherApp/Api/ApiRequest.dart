import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weatherapp/WeatherApp/Api/ApiRequestConstants.dart';
import 'package:weatherapp/WeatherApp/ErrorHandler/ErrorHandler.dart';

class ApiRequest {

  Future<dynamic> request(String? params, String lat, String long) async {

    final _params = params ?? '';
    final uri = '${BASE_URL}lat=$lat&lon=$long$_params&units=metric&lang=en&appid=$API_KEY';
    final url = Uri.parse(uri);
    dynamic jsonResponse;

    try {
      final response = await http.get(url);
      print('response:- ${response.body}');
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    } catch (e) {
      throw FetchDataException(e.toString());
    }

    return jsonResponse;

  }

}




dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while communication with server' +
              ' with status code : ${response.statusCode}');
  }
}