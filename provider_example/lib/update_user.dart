import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'model/user.dart';

class UpdateUserScreen extends StatelessWidget {
  final User user;

  const UpdateUserScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: user.name);
    final ageController = TextEditingController(text: user.age.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin người dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Tuổi'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final updatedUser = User(
                  nameController.text,
                  int.parse(ageController.text),
                );
                Provider.of<UserProvider>(context, listen: false)
                    .updateUser(user, updatedUser);
                Navigator.pop(context);
              },
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
