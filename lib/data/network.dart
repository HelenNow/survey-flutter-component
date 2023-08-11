import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<NetworkResponseData> getRequest({
    required String url,
    required String apiFailureMessage,
    Map<String, String>? customHeaders,
  }) async {
    final Uri requestUrl = Uri.parse(
      url,
    );

    try {
      http.Response response = await http.get(
        requestUrl,
        headers: customHeaders,
      );

      Map<String, dynamic> responseMap = _parseResponse(
        response: response,
        apiFailureMessage: apiFailureMessage,
        url: url,
        type: 'GET',
      );

      if (responseMap.isEmpty ||
          responseMap['error'].toString().isNotEmpty ||
          responseMap['status'] == 'failure') {
        return NetworkResponseData(
          hasError: true,
          error: responseMap['error'],
          status: responseMap['status'],
        );
      }
      return NetworkResponseData(
        hasError: responseMap['error'].toString().isNotEmpty,
        error: responseMap['error'] ?? '',
        status: responseMap['status'] ?? '',
        speech: responseMap['speech'] ?? '',
        data: responseMap['result'] ?? '',
      );
    } catch (error) {
      debugPrint(
        error.toString(),
      );

      return NetworkResponseData(
        hasError: true,
        error: error.toString(),
      );
    }
  }

  static Future<NetworkResponseData> postRequest({
    required String url,
    required String apiFailureMessage,
    Map<String, String>? customHeaders,
    Object? body,
  }) async {
    final Uri requestUrl = Uri.parse(
      url,
    );

    try {
      http.Response response = await http.post(
        requestUrl,
        headers: customHeaders,
        body: jsonEncode(
          body,
        ),
      );

      Map<String, dynamic> responseMap = _parseResponse(
        response: response,
        apiFailureMessage: apiFailureMessage,
        url: url,
        type: 'POST',
        body: body,
      );

      if (responseMap.isEmpty ||
          responseMap['error'].toString().isNotEmpty ||
          responseMap['status'] == 'failure') {
        return NetworkResponseData(
          hasError: true,
          error: responseMap['error'],
          status: responseMap['status'],
        );
      }

      return NetworkResponseData(
        hasError: responseMap['error'].toString().isNotEmpty,
        error: responseMap['error'] ?? '',
        status: responseMap['status'],
        speech: responseMap['speech'],
        data: responseMap['result'],
      );
    } catch (error) {
      return NetworkResponseData(
        hasError: true,
        error: error.toString(),
      );
    }
  }

  static Map<String, dynamic> _parseResponse({
    required http.Response response,
    required String apiFailureMessage,
    required String url,
    required String type,
    Object? body,
  }) {
    if (response.statusCode != 200) {
      debugPrint(
        'ERROR $url\n ${response.reasonPhrase}; ${response.body}',
      );
      return <String, dynamic>{};
    }

    Map<String, dynamic> responseMap = jsonDecode(
      response.body,
    );

    if (responseMap['status'] != 'ok') {
      debugPrint(
        'ERROR $url: ${responseMap['error'].toString()}',
      );
      return responseMap;
    }

    debugPrint(
      '${response.statusCode.toString()}:$type ${url.toString()}',
    );

    return responseMap;
  }
}

class NetworkResponseData {
  final bool hasError;
  final String error;
  final String? status;
  final String? speech;
  final dynamic data;

  const NetworkResponseData({
    required this.hasError,
    required this.error,
    this.status,
    this.data,
    this.speech,
  });
}
