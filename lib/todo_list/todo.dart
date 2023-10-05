import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/todo_list/todolist_controller.dart';

class TodoList extends StatelessWidget {
  final TodoListController _controller = Get.put(TodoListController());

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
    List<Widget> dayColumns = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      String formattedDate = DateFormat('d').format(day);
      String formattedDay = DateFormat('E').format(day);

      final isCurrentDate = i == 0;

      dayColumns.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                color: isCurrentDate
                    ? const Color(0xFFD67C6C)
                    : const Color(0xFFEBE983),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDay,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _showAddTaskDialog(context);
            },
            label: const Text(
              'Add New Habit',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: const Color(0xFF97C9D2),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Today.",
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFF302F29),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 14.0),
                  child: Text(
                    currentDate,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF302F29),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ...dayColumns,
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "To Do",
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFF302F29),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                _buildTaskList(false),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFF302F29),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                _buildTaskList(true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    TextEditingController taskController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter a task',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String task = taskController.text;
                if (task.isNotEmpty) {
                  _controller.addTodoItem(task);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Color _getRandomColor() {
    final Random random = Random();
    return Color(0xFF000000 + random.nextInt(0xFFFFFF));
  }

  Widget _buildTaskList(bool isDone) {
    return Obx(
      () => Column(
        children: [
          for (String task in (isDone
              ? _controller.doneTasks.toList()
              : _controller.todoItems.toList()))
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDone ? _getRandomColor() : _getRandomColor(),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 40,
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          task,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      if (!isDone)
                        IconButton(
                          icon: const Icon(Icons.check_box_outlined),
                          onPressed: () {
                            _controller.markTaskAsDone(task);
                          },
                        ),
                      if (isDone)
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () {
                            _controller.removeTodoItem(task);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
