import 'package:dio/dio.dart';
import 'package:dio_flutter_example/userlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/TaskController.dart';
import 'controller/TokenController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<TokenController>(TokenController()); // Initialize TokenController
  Get.put<TaskController>(TaskController()); // Initialize the TaskController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("DIO Example"),
        ),
        body: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
  }

  Future<void> _login() async {
    try {
      final response = await _dio.post(
        'https://api.escuelajs.co/api/v1/auth/login',
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      if (response.statusCode == 201) {
        final token = response.data['access_token'];
        // Store token using GetX controller
        TokenController.to.token.value = token;
        // Redirect to the second page
        Get.off(() => const UserList());
      }
      if (response.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Failed"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
