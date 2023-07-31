import 'package:get/get.dart';

import '../model/LoginResponse.dart';

class TokenController extends GetxController {
  TokenModel? tokenModel;

  void setToken(TokenModel token) {
    tokenModel = token;
    update(); // Notify listeners about the change
  }

  String? getAccessToken() {
    return tokenModel?.access_token;
  }
}
