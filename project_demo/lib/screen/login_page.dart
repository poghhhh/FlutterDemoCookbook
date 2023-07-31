import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:project_demo/controller/LoginController.dart';
import 'package:project_demo/model/LoginResponse.dart';
import 'package:project_demo/screen/home_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../controller/TokenController.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();
    final LoginController loginController =
        Get.put(LoginController()); // Use Get.put to initialize the controller
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 50),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Login to using app",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Genos",
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"),
              controller: loginController
                  .usernameController, // Use the usernameController from the LoginController
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password"),
              controller: loginController
                  .passwordController, // Use the passwordController from the LoginController
            ),
            const SizedBox(
              height: 30,
            ),
            // RoundedLoadingButton(
            //   onPressed: () {
            //     _loginRequest(loginController);
            //   },
            //   controller: _btnController,
            //   child:
            //       const Text('Sign in', style: TextStyle(color: Colors.white)),
            // )
            ElevatedButton(
              onPressed: () {
                _loginRequest(loginController);
              },
              child: const Text('Sign in'),
            )
          ],
        ),
      ),
    );
  }
}

_loginRequest(LoginController loginController) async {
  String url = 'https://api.escuelajs.co/api/v1/auth/login';
  Map<String, String> headers = {"Content-type": "application/json"};

  // Create the JSON data with username and password from the controller
  Map<String, String> jsonData = {
    "email": loginController.usernameController.text,
    "password": loginController.passwordController.text,
  };

  // Convert the JSON data to a JSON string
  String json = jsonEncode(jsonData);

  // Convert the URL string to a Uri
  Uri uri = Uri.parse(url);

  // Make the POST request
  final response = await post(uri, headers: headers, body: json);

  // Check the status code of the response
  int statusCode = response.statusCode;

  if (statusCode == 201) {
    // Parse the response body and map it to the model
    Map<String, dynamic> responseData = jsonDecode(response.body);
    TokenModel tokenModel = TokenModel.fromJson(responseData);

    // Store the tokenModel in the TokenController
    Get.find<TokenController>().setToken(tokenModel);

    // Do something with the tokenModel
    print("Access Token: ${tokenModel.access_token}");
    print("Refresh Token: ${tokenModel.refresh_token}");

    Get.offAll(() => const HomePage());
  } else {
    // Handle error responses
    print("Error: ${response.reasonPhrase}");
  }
}
