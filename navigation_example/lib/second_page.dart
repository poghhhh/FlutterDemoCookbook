import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String data;

  const SecondPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Navigation 2nd")),
      body: Welcome2ndPage(data: data), // Pass the actual data value here
    );
  }
}

class Welcome2ndPage extends StatelessWidget {
  final String data;

  const Welcome2ndPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("This is the 2nd Page of Navigation"),
          const SizedBox(height: 16),
          Text("Data from Page 1: $data"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context, 'Data in page 2'); // Back to redirected page
            },
            child: const Text('Back To Home'),
          ),
        ],
      ),
    );
  }
}
