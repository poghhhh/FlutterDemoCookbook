import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/TaskController.dart';
import 'controller/TokenController.dart';
import 'model/Tasks.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = TokenController.to.token.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Token: $token',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final tasks = TaskController.to.taskList;
              return SingleChildScrollView(
                // Wrap with SingleChildScrollView
                child: ListView.builder(
                  shrinkWrap: true, // Set shrinkWrap to true
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.taskName),
                      subtitle: Text(task.time),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskPopup(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showCreateTaskPopup(BuildContext context) {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            TextFormField(
              controller: timeController,
              readOnly: true, // Make the field read-only
              decoration: const InputDecoration(
                labelText: 'Time',
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  // Format the pickedDate as per your requirement
                  String formattedDate = pickedDate.toString();

                  // Update the timeController with the formatted date
                  timeController.text = formattedDate;
                }
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Perform task creation logic using the entered values
              String taskName = taskNameController.text;
              String time = timeController.text;

              // Process the task creation logic here
              // For example, save the task to the database
              Task task = Task(taskName: taskName, time: time);
              int taskId = await TaskController().insertTask(task);
              // Close the pop-up
              Navigator.of(context).pop();

              TaskController.to.fetchTasks();
              // Refresh the task list by calling setState or GetX update
              // Alternatively, you can use a State Management solution like GetX to update the task list automatically.
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}
