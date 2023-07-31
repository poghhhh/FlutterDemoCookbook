import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/getx_Controller.dart';
import 'detail_screen.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX State and Redirect Example',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CounterController counterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'Count: ${counterController.count.value}',
                  style: const TextStyle(fontSize: 24),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                counterController.increment();
              },
              child: const Text('Increment'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                counterController.redirectToDetailScreen();
              },
              child: const Text('Go to Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
