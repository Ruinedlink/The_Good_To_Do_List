import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/widgets/sort_button.dart';
import 'package:todo_model/widgets/task_label.dart';
import 'package:todo_model/widgets/user_lists.dart';

class TaskView extends StatefulWidget {
  final ToDoLists allLists;
  final ViewSortMethod viewSortMethod;
  final SortMethod? sortMethod;
  final ToDoList? selectedList;
  final ValueChanged<Task?> onSelectedItemChanged;
  final Task? selectedTask;
  const TaskView({
    super.key,
    required this.viewSortMethod,
    required this.sortMethod,
    required this.allLists,
    required this.selectedList,
    required this.onSelectedItemChanged,
    required this.selectedTask,
  });

  @override
  State<TaskView> createState() => _TaskView();
}

class _TaskView extends State<TaskView> {
  late ToDoList selectedList;
  late Task? selectedTask;

  @override
  void initState() {
    super.initState();
    selectedList = widget.selectedList!;
    selectedTask = null;
  }

  @override
  void didUpdateWidget(TaskView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedList != oldWidget.selectedList) {
      setState(() {
        selectedList = widget.selectedList!;
        selectedTask = null;
      });
    }
    if (widget.selectedTask != oldWidget.selectedTask) {
      setState(() {
        selectedList = widget.selectedList!;
        selectedTask = widget.selectedTask;
      });
    }
  }

  void _setSelectedTask(Task newTask) {
    debugPrint('New selected task \'${newTask.text}\'');
    setState(() {
      selectedTask = newTask;
      widget.onSelectedItemChanged(newTask);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      if (task.subTasks.isNotEmpty) {
        for (var subTask in task.subTasks) {
          if (selectedTask == subTask) {
            widget.onSelectedItemChanged(null);
          }
        }
      }
      if (selectedTask == task) {
        widget.onSelectedItemChanged(null);
      }
      ToDoList? parentList = widget.allLists.idToList(task.parentId!);
      if (parentList != null) {
        var taskParent = parentList.findTaskById(task.parentId!);
        parentList.removeTaskById(task.id);
        parentList.saveToFile();
        taskParent;
        widget.allLists;
      }
    });
  }

  List<dynamic> get _displayList {
    if (widget.viewSortMethod != ViewSortMethod.none) {
      List<Task> allTasks = [];
      for (ToDoList list in widget.allLists.lists) {
        allTasks.addAll(list.tasks);
      }
      List<Task> currentTasks = sortViewCatagory(
        allTasks,
        widget.viewSortMethod,
      );

      final method = widget.sortMethod;
      return method == null ? currentTasks : sortTasks(currentTasks, method);
    } else {
      final method = widget.sortMethod;
      return method == null
          ? selectedList.tasks
          : sortTasks(selectedList.tasks, method);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: _displayList.length,
            itemBuilder: (context, index) {
              final thisTask = _displayList[index];
              return TaskLabel(
                key: ValueKey(thisTask.id),
                onTap: (value) => _setSelectedTask(value),
                thisTask: thisTask,
                currentList: selectedList,
                selectedTask: selectedTask,
                onDelete: _deleteTask,
              );
            },
            separatorBuilder: (context, int index) {
              return const Divider(
                indent: 20,
                color: Color.fromARGB(30, 255, 255, 255),
                thickness: .5,
              );
            },
          ),
        ),
      ],
    );
  }
}
