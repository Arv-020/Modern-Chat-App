import 'package:flutter_easyloading/flutter_easyloading.dart';

class UiHelper {
  static showLoader() {
    EasyLoading.show(
      status: "Loading...",
    );
  }

  static showToast(String toastTitle) {
    EasyLoading.showToast(
      toastTitle,
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }
}
