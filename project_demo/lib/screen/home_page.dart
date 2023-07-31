import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:project_demo/controller/AccountController.dart';
import 'package:project_demo/model/InfomationResponse.dart';
import 'package:project_demo/screen/login_page.dart';

import '../controller/TokenController.dart';
import '../model/LoginResponse.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();

    final tokenController = Get.find<TokenController>();

    String? accessToken = tokenController.getAccessToken();

    if (accessToken != null) {
      _fetchAccountInfo(accessToken);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Name: ${accountController.name.value}"),
                    Text("Role: ${accountController.role.value}"),
                  ],
                ),
              )),
          IconButton(
            onPressed: () {
              // Implement the logout functionality here
              // For example, clear the token data and redirect to the login screen.
              tokenController
                  .setToken(TokenModel(access_token: "", refresh_token: ""));
              accountController
                  .setInfomation(InfomationModel(name: "", role: ""));
              Get.offAll(const LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to the Home Screen!"),
      ),
    );
  }
}

_fetchAccountInfo(String accessToken) async {
  String url = 'https://api.escuelajs.co/api/v1/auth/profile';
  Map<String, String> headers = {"Authorization": "Bearer $accessToken"};

  // Make the GET request to fetch account information
  final response = await get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    // Parse the response body and do something with the account information
    Map<String, dynamic> responseData = jsonDecode(response.body);
    InfomationModel infomationModel = InfomationModel.fromJson(responseData);

    Get.find<AccountController>().setInfomation(infomationModel);

    print(responseData);
  } else {
    // Handle error responses
    print("Error: ${response.reasonPhrase}");
  }
}
