import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../Database/Db.dart';
import '../model/Tasks.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();
  RxList<Task> taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks(); // Fetch tasks when the controller is initialized
  }

  void fetchTasks() async {
    List<Map<String, dynamic>> results = await DatabaseHelper().fetchTasks();
    // Convert the fetched maps to Task objects and update the taskList
    taskList.value = results.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> insertTask(Task task) async {
    int taskId = await DatabaseHelper().insertTask(task);
    return taskId;
  }
}
