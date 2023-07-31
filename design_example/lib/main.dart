import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      // Khai báo , sử dụng theme mặc định của hệ thống
      // theme: ThemeData(
      //   primaryColor: Colors.blue,
      //   colorScheme: ColorScheme.fromSwatch(
      //     primarySwatch: Colors.red,
      //     accentColor: Colors.orange,
      //   ),
      //   textTheme: const TextTheme(
      //     headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //     // Add more text styles as needed
      //   ),
      // ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Scaffold Initialize
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Flutter App'),
      ),
      // Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle item 1 click
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Handle item 2 click
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            // Add more ListTiles for additional items
          ],
        ),
      ),
      // body: SnackBarToast(),
      //body: OrientationWidget(),
      //body: TabExample(),
    );
  }
}

//Tab
class TabExample extends StatelessWidget {
  const TabExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text("Tab Demo"),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ));
  }
}

//Snack bar
class SnackBarToast extends StatelessWidget {
  const SnackBarToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          const snackBarMessage = SnackBar(content: Text('Yay! A SnackBar!'));
          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBarMessage);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}

// Thay Đổi UI theo chiều màn hỉnh
class OrientationWidget extends StatelessWidget {
  const OrientationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            );
          }),
        );
      },
    );
  }
}
