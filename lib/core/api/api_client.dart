import 'dart:io';

import 'package:dio/dio.dart';

import 'api_response.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();

  var _client;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal();

  Future<Dio> getApiClient() async {
    if (_client == null) {
      print("___________________should be called only once___________________");
      _client = Dio();

      _client.interceptors.clear();
      _client.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        request: true,
        error: true,
        requestHeader: true,
        responseHeader: true,
      ));
    }
    return _client;
  }

}
