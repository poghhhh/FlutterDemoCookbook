import 'package:flutter/material.dart';
import 'package:navigation_example/second_page.dart';

void main() {
  runApp(MaterialApp(
    home: const MyApp(),
    routes: {'/second': (context) => const SecondPage(data: '')},
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigation"),
      ),
      // body: const ImageForClick(),
      body: ButtonTo2ndSrceen(),
    );
  }
}

class ImageForClick extends StatelessWidget {
  const ImageForClick({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const DetailScreen();
        }));
      },
      child: Hero(
        tag: 'imageHero',
        child: Image.network(
          'https://picsum.photos/250?image=9',
        ),
      ),
    ));
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              'https://www.lamborghini.com/sites/it-en/files/DAM/lamborghini/facelift_2019/model_detail/augmented-reality/huracan/huracan_tecnica/hura_tecnica_ar_01.png',
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonTo2ndSrceen extends StatelessWidget {
  final TextEditingController fieldController = TextEditingController();

  ButtonTo2ndSrceen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DataForPass(fieldController: fieldController),
          ElevatedButton(
            onPressed: () async {
              String enteredText = fieldController.text;
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondPage(data: enteredText)),
              );
              if (result != null) {
                // nếu được pop, tức chuyển về từ trang 2
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data received: $result')),
                );
              }
            },
            child: const Text('Go to 2nd Page'),
          ),
        ],
      ),
    );
  }
}

class DataForPass extends StatefulWidget {
  final TextEditingController fieldController;

  const DataForPass({Key? key, required this.fieldController})
      : super(key: key);

  @override
  DataPass createState() => DataPass();
}

class DataPass extends State<DataForPass> {
  @override
  void dispose() {
    widget.fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
      controller: widget.fieldController,
    );
  }
}
