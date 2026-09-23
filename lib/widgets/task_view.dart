import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/widgets/task_label.dart';

class TaskView extends StatefulWidget {
  final ToDoList selectedList;
  final ValueChanged<Task?> onSelectedItemChanged;
  final Task? selectedTask;
  final List<dynamic>? displayList;
  const TaskView({
    super.key,
    required this.selectedList,
    required this.onSelectedItemChanged,
    required this.selectedTask,
    this.displayList,
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
    selectedList = widget.selectedList;
    selectedTask = null;
  }

  @override
  void didUpdateWidget(TaskView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedList != oldWidget.selectedList) {
      setState(() {
        selectedList = widget.selectedList;
        selectedTask = null;
      });
    }
    if (widget.selectedTask != oldWidget.selectedTask) {
      setState(() {
        selectedList = widget.selectedList;
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
      var taskParent = selectedList.findTaskById(task.parentId!);
      selectedList.removeTaskById(task.id);
      selectedList.saveToFile();
      taskParent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = widget.displayList ?? widget.selectedList.tasks;
    return Row(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final thisTask = displayList[index];
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
