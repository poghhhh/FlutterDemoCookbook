import 'package:get/get.dart';
import 'package:project_demo/model/InfomationResponse.dart';

class AccountController extends GetxController {
  InfomationModel? infomationModel;
  var name = "".obs;
  var role = "".obs;

  void setInfomation(InfomationModel infomation) {
    infomationModel = infomation;
    name.value = infomation.name;
    role.value = infomation.role;
    update();
  }
}
