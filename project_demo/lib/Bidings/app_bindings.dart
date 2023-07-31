import 'package:get/get.dart';
import 'package:project_demo/controller/AccountController.dart';

import '../controller/TokenController.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(TokenController());
    Get.put(AccountController());
  }
}
