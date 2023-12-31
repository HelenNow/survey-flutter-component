import 'package:survey/widgets/toast.dart';
import 'package:survey/data/network.dart';

class APIRequestSurvey {
  static Future<dynamic> getSurveyQuestions(dynamic scrg, String url,
      Map<String, String> urlHeaders, String uuid) async {
    NetworkResponseData? response;

    try {
      response = await ApiHandler.getRequest(
        customHeaders: urlHeaders,
        url: url.replaceAll('{scrgval}', scrg).replaceAll('{uuidval}', uuid),
        apiFailureMessage: 'Unable to get tips',
      );
    } catch (apiRequestError) {
      PatientToast.showToast(message: apiRequestError.toString());
      return null;
    }

    return response.data!;
  }

  static Future<dynamic> postSurveyQuestions(
      dynamic body, String url, Map<String, String> urlHeaders) async {
    NetworkResponseData? response;
    try {
      response = await ApiHandler.postRequest(
        url: url,
        customHeaders: urlHeaders,
        apiFailureMessage: 'Unable to get tips',
        body: body,
      );
    } catch (apiRequestError) {
      PatientToast.showToast(message: 'Unable to post QUESTIONS (API)');
      return null;
    }

    if (response.hasError) {
      return null;
    }

    return response.status;
  }
}
