import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:survey/network.dart';
import 'package:survey/toast.dart';

class APIRequestSurvey {
  static Future<dynamic> getSurveyQuestions(
      dynamic scrg, String url, Map<String, String> urlHeaders) async {
    NetworkResponseData response;
    String? uuid;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        uuid = iosDeviceInfo.identifierForVendor!; // unique ID on iOS
      }
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      uuid = androidDeviceInfo.id; // unique ID on Android
    } catch (deviceInfoInitializationError) {}
    try {
      response = await ApiHandler.getRequest(
        customHeaders: urlHeaders,
        url: url.replaceAll('{scrgval}', scrg).replaceAll('{uuidval}', uuid!),
        apiFailureMessage: 'Unable to get tips',
      );
    } catch (apiRequestError) {
      PatientToast.showToast(message: 'Unable to get tips (API)');
      return null;
    }

    return response.data!;
  }

  static Future<dynamic> postSurveyQuestions(
      dynamic body, String url, Map<String, String> urlHeaders) async {
    NetworkResponseData response;
    try {
      response = await ApiHandler.postRequest(
        url: url,
        customHeaders: urlHeaders,
        apiFailureMessage: 'Unable to get tips',
        body: body,
      );
    } catch (apiRequestError) {
      PatientToast.showToast(message: 'Unable to get tips (API)');
      return null;
    }

    if (response.hasError) {
      return null;
    }

    return response.status;
  }
}
