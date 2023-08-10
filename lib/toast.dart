import 'package:fluttertoast/fluttertoast.dart';
import 'package:survey/colors.dart';

/// A class allowing showing toast messages.
class PatientToast {
  /// Shows a toast message at the bottom of the screen.
  static Future<void> showToast({
    required String message,
    bool isShort = true,
  }) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: isShort ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: ConfigConstants.white,
      textColor: ConfigConstants.black,
      fontSize: ConfigConstants.fontToastMessage,
    );
  }
}
