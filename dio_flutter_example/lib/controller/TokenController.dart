import 'package:get/get.dart';

class TokenController extends GetxController {
  static TokenController get to => Get.find();
  RxString token = ''.obs;
}
