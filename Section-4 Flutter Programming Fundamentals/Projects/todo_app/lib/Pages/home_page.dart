import 'package:flutter/material.dart';
import 'package:todo_app/Utill/dialog_box.dart';
import 'package:todo_app/data/dataBase.dart';
import 'package:todo_app/Utill/my_button.dart';
import '../Utill/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //list of todo tasks
  List toDoList = [
    ["Make Tutorial", false],
    ["Do Exercise", false],
  ];

  //checkbox was tapped
  Future<void> checkBoxChanged(bool? value, int index) async {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    try {
      await DataBase.saveTodos(toDoList);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save changes')));
    }
  }

  //create a new task
  void createNewTask() async {
    final newTask = await showDialog<String>(
      context: context,
      builder: (context) {
        return const DialogBox();
      },
    );

    if (newTask != null && newTask.isNotEmpty) {
      setState(() {
        toDoList.add([newTask, false]);
      });
      try {
        await DataBase.saveTodos(toDoList);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save task')));
      }
    }
  }

  // delete a task with confirmation
  void deleteTask(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[300],
        title: const Text('Delete task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          MyButton(
            label: 'Cancel',
            elevated: false,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: 8),
          MyButton(
            label: 'Delete',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        toDoList.removeAt(index);
      });
      try {
        await DataBase.saveTodos(toDoList);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Task deleted')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete task')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final stored = DataBase.getTodos();
    if (stored.isNotEmpty) {
      toDoList = List.from(stored);
    } else {
      // save initial defaults
      DataBase.saveTodos(toDoList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(child: Text('TO DO')),
        elevation: 0,
        backgroundColor: Colors.yellow,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
      ),

      body: ValueListenableBuilder(
        valueListenable: DataBase.listenable(),
        builder: (context, box, _) {
          final stored = box.get(DataBase.todosKey);
          final list = (stored != null && stored is List)
              ? List.from(stored)
              : toDoList;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ToDoTile(
                taskName: list[index][0],
                taskCompleted: list[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                onDelete: () => deleteTask(index),
              );
            },
          );
        },
      ),
    );
  }
}
