import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;
  final myStorage = GetStorage();

  ThemeController() {
    getIsDark();
  }

  bool getIsDark() {
    isDark.value = myStorage.read('isDark') ?? false;
    return isDark.value;
  }

  void setIsDark(bool val) {
    isDark.value = val;
    myStorage.write('isDark', val);
  }
}
