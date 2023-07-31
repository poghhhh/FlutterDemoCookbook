import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/update_user.dart';

import 'add_user.dart';
import 'model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Ứng dụng quản lý người dùng',
        initialRoute: '/',
        routes: {
          '/': (context) => const UserListScreen(),
          '/add': (context) => const AddUserScreen(),
        },
      ),
    );
  }
}

class UserProvider with ChangeNotifier {
  final List<User> _users = [];

  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(User oldUser, User updatedUser) {
    final index = _users.indexOf(oldUser);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void deleteUser(User user) {
    _users.remove(user);
    notifyListeners();
  }
}

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var users = userProvider.users;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người dùng'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Tuổi: ${user.age}'),
                  onLongPress: () {
                    _showOptionsDialog(context, user);
                  },
                );
              },
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tùy chọn'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Cập nhật'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateUserScreen(user: user),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  child: const Text('Xóa'),
                  onTap: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .deleteUser(user);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
